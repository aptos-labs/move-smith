//# publish
module 0x1::PackagePaths {
    use std::string::{String, utf8};
    use std::symbol::{Symbol, string_to_symbol};
    use std::vector;
    use std::signer;
    use std::debug;

    struct PackagePaths has store {
        paths: vector<String>,
    }

    /// Transform a vector<String> into a vector<Symbol>.
    public fun string_vec_to_symbol_vec(strs: vector<String>): vector<Symbol> {
        let mut syms = vector::empty<Symbol>();
        let len = vector::length(&strs);
        let mut i = 0;
        while (i < len) {
            let s = vector::borrow(&strs, i);
            let sym = string_to_symbol(s);
            vector::push_back(&mut syms, sym);
            i = i + 1;
        };
        syms
    }

    /// Create a PackagePaths resource under `account` with provided string paths.
    public fun initialize(account: &signer, paths: vector<String>) {
        move_to(account, PackagePaths { paths })
    }

    /// Transform the 'paths' vector from String to Symbol in the account's resource.
    public fun upgrade(account: &signer) {
        let pkg = borrow_global_mut<PackagePaths>(signer::address_of(account));
        let syms = Self::string_vec_to_symbol_vec(pkg.paths);
        debug::print<u64>(vector::length(&syms));
        // Just drop result for test
    }

    /// Binary operator/constraint test with type abilities and expected failure
    public fun test_bin_ops<T: copy + store>(x: T, y: T): bool {
        // Test ==, != (if T supports it)
        // <, >, <=, >=, |, &, ^, <<, >> available for u64/u8/bool only
        // We'll use u64 as concrete test below
        true
    }

    public fun runner(account: &signer) {
        let s1 = String::utf8(b"foo");
        let s2 = String::utf8(b"bar");
        let s3 = String::utf8(b"baz");

        let strs = vector::empty<String>();
        vector::push_back(&mut strs, s1);
        vector::push_back(&mut strs, s2);
        vector::push_back(&mut strs, s3);
        Self::initialize(account, strs);
        Self::upgrade(account);

        // Symbolic binary ops
        let (a, b) = (1u64, 2u64);
        let res = (
            a == b,
            a != b,
            a < b,
            a > b,
            a <= b,
            a >= b,
            a || 1u64 != 0u64,
            a && b,
            a | b,
            a & b,
            a ^ b,
            a << 1,
            b >> 1,
            a + b,
            b - a,
            a * b,
            b / a,
            b % a,
            // Range operator: [a .. b]
            // Implication operator: a ==> b
            // Reverse implication: a <==> b
            // '||', '&&' expect bool types, so an example
            true || false,
            false && true,
            (a == 1u64) ==> (b == 2u64), // Should be true
            (a > b) <==> (b > a),        // false <==> true = false
        );

        debug::print<bool>(res.0); // Testing: a == b -> false

        // Abilities constraint test
        let _c: vector<u64> = vector::empty<u64>();
        let _d: vector<T> = vector::empty<T>();
        // Uncommenting this line would fail if T did not have +copy and +store
        //vector::push_back(&mut _d, x);
    }
}

//# run 0x1::PackagePaths::runner --signers 0x1

//# run
script {
    use 0x1::PackagePaths;
    use std::string::String;
    // External caller test
    fun main(account: &signer) {
        let strs = vector[String] {
            String::utf8(b"abc"),
            String::utf8(b"def"),
            String::utf8(b"ghi"),
        };
        PackagePaths::initialize(account, strs);
        PackagePaths::upgrade(account);
    }
}

//# publish
module 0x2::VectorFailTest {
    use std::vector;
    use std::signer;

    /// This runner will attempt to pop from an empty vector, which is a vector_error.
    #[expected_failure(vector_error, 1)]
    public fun pop_empty_vector() {
        let v = vector::empty<u8>();
        let _el = vector::pop_back(&mut v);
    }
}

//# run 0x2::VectorFailTest::pop_empty_vector

//# publish
module 0x3::AbilitiesAndOps {
    // Test type constraints
    public fun use_generic<T: copy + store>(val: T): T {
        val
    }
    public fun runner() {
        // All the following ops are supported and binary op parsing tested.
        let x = 5u8;
        let y = 3u8;
        let result = (
            x == y,      // false
            x != y,      // true
            x < y,       // false
            x > y,       // true
            x <= y,      // false
            x >= y,      // true
            x | y,       // 7
            x & y,       // 1
            x ^ y,       // 6
            x << 1,      // 10
            y >> 1,      // 1
            x + y,       // 8
            x - y,       // 2
            x * y,       // 15
            x / y,       // 1
            x % y,       // 2
        );
    }
}

//# run 0x3::AbilitiesAndOps::runner