//# publish
module 0xCAFE::SeqUpdateTest {
    // Test 1: Sequential updates to a local variable and type specification

    /// Sum local variable by accumulating values across multiple expressions.
    /// Use inline functions to showcase their chaining.
    public fun runner() {
        let a: u64 = 0;
        let a = a + Self::add_one(a);    // a = 0 + 1 = 1
        let a = Self::add_two(a);        // a = 1 + 2 = 3
        let a = Self::add_n(a, 4);       // a = 3 + 4 = 7

        // Call nested inlines that chain together
        let a = Self::double_plus_next(a); // a = (7 * 2) + (7 + 1) = 14 + 8 = 22

        // Use another inline series: ((a + 1) + (a + 2))
        let a = Self::sum_successors(a);  // a = (22 + 1) + (22 + 2) = 23 + 24 = 47

        // Drop the final value to satisfy the linear type system
        let _ = a;
    }

    public inline fun add_one(x: u64): u64 {
        x + 1
    }

    public inline fun add_two(x: u64): u64 {
        x + 2
    }

    public inline fun add_n(x: u64, n: u64): u64 {
        x + n
    }

    // Call inline from another inline: double value, add next value.
    public inline fun double_plus_next(x: u64): u64 {
        Self::double(x) + Self::add_one(x)
    }

    public inline fun double(x: u64): u64 {
        x * 2
    }

    // Chained inline: sum (x + 1) and (x + 2) via calls.
    public inline fun sum_successors(x: u64): u64 {
        Self::add_one(x) + Self::add_two(x)
    }
}

//# run 0xCAFE::SeqUpdateTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::TypeAnnotationTest {
    /// Test specifying variable types with colon syntax across various contexts.
    public fun runner() {
        let u: u8 = 10;
        let v: u64 = u as u64 + 999u64;
        let w: bool = v > 1000;
        let x: vector<u8> = b"aptos";
        let (a: u8, b: u8) = (1u8, 2u8);
        let (big: u64, mini: u8) = (9999u64, 8u8);

        // Just to consume variables
        let _ = (u, v, w, x, a, b, big, mini);
    }
}

//# run 0xCAFE::TypeAnnotationTest::runner --signers 0xBEEF


//# publish
module 0xCAFE::InlineFnChaining {
    /// Simple two-level inline call
    public inline fun foo(x: u64): u64 {
        Self::bar(x + 1)
    }

    public inline fun bar(y: u64): u64 {
        y * 2
    }

    // Calls foo(9) which does bar(10) -> 10*2 = 20
    public fun runner() {
        let res: u64 = Self::foo(9);
        let _ = res;
    }
}

//# run 0xCAFE::InlineFnChaining::runner --signers 0xDEAD


//# run
script {
    use 0xCAFE::SeqUpdateTest;
    use 0xCAFE::InlineFnChaining;
    use 0xCAFE::TypeAnnotationTest;

    fun main(account: &signer) {
        SeqUpdateTest::runner();
        InlineFnChaining::runner();
        TypeAnnotationTest::runner();
    }
}

// Featurres:
// 2baf1ad04dd93499c7dba7597bb32763: Test that multiple sequential updates to a local variable are correctly accumulated and summed across multiple expressions.
// ad0fdbba830f476f843fb06d467e41f6: Define inline functions that can call other inline functions.
// d0b098ad8683852699d7cda3649455e4: Specify the type of a variable using a colon followed by the type after the variable name.
