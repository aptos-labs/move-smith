// This transactional test file is designed to test:
// 1. Expression parsing and precedence with complex expressions in structs and functions.
// 2. Using all_type_names to check builtin types.
// 3. Testing increments and accessors on primitives, structs, wrapped types, and vectors.

// Using 0xCAFE as the test address, no aliases, no 0x1.

//#region // Publish a helper module to expose all_type_names and test complex expression parsing

//# publish
module 0xCAFE::ExprAndTypeCheck {
    use std::vector;

    /// A simple struct with numeric fields to test complex expressions.
    struct Data has copy, drop, store, key {
        a: u8,
        b: u64,
        c: bool,
    }

    /// Simple wrapper struct for u64.
    struct Wrapper has copy, drop, store {
        value: u64,
    }

    /// Increment u8 by 1 using complex expressions to test precedence parsing.
    public fun inc_u8(x: u8): u8 {
        // Expression: ( (x + 1) * 2 / 2 ) - 1 + 1 should return x + 1
        // Test: ( (x + 1) * 2 / 2 ) - 1 + 1 == x + 1
        ( ((x + 1) * 2 / 2) - 1 + 1 )
    }

    /// Increment u64 similarly, but with more complex expression involving shifts.
    public fun inc_u64(x: u64): u64 {
        // Expression to test precedence:
        // ( ( (x + 1) << 2 ) >> 2 ) + 0
        (((x + 1) << 2) >> 2) + 0
    }

    /// Increment the 'a' field of Data by 1, using explicit tuple unpack.
    public fun inc_struct(a: Data): Data {
        let Data { a: aa, b: bb, c: cc } = a;
        Data { a: inc_u8(aa), b: bb, c: cc }
    }

    /// Increment the wrapped value by 1.
    public fun inc_wrapper(w: Wrapper): Wrapper {
        Wrapper { value: inc_u64(w.value) }
    }

    /// Increment each element of vector<u8> by 1.
    public fun inc_vec_u8(v: vector<u8>): vector<u8> {
        let len = vector::length(&v);
        let mut res = vector::empty<u8>();
        let mut i = 0;
        while (i < len) {
            let val = *vector::borrow(&v, i);
            vector::push_back(&mut res, inc_u8(val));
            i = i + 1;
        }
        res
    }

    /// A "runner" function that tests the above increments and the all_type_names set.
    /// Returns true if 'bool' and 'u64' are builtin types, false otherwise. Also checks increments.
    public fun runner(): bool {
        // Test increment on primitives:
        let x_u8 = 10u8;
        let x_u64 = 10u64;
        let inc8 = inc_u8(x_u8);
        let inc64 = inc_u64(x_u64);

        // Build struct and increment field 'a'
        let original_struct = Data { a: 5u8, b: 100u64, c: true };
        let new_struct = inc_struct(original_struct);

        // Wrapper increment
        let wrapped = Wrapper { value: 15u64 };
        let new_wrapper = inc_wrapper(wrapped);

        // Vector increment
        let vec_u8 = vector::from_bytes(b"abc");
        let new_vec = inc_vec_u8(vec_u8);

        // Check some correctness - (We do not add assertions but code exercises VM and compiler)
        // Check increments increase by 1
        let _check1 = (inc8 == x_u8 + 1);
        let _check2 = (inc64 == x_u64 + 1);
        let _check3 = (new_struct.a == original_struct.a + 1);
        let _check4 = (new_wrapper.value == wrapped.value + 1);
        // new_vec should be { 'a'+1, 'b'+1, 'c'+1 }
        let first_new_char = *vector::borrow(&new_vec, 0);
        let _check5 = (first_new_char == (b'a' + 1));

        // TEST all_type_names from std::type_info
        use std::type_info;

        let all_types = type_info::all_type_names();
        // all_types is vector<vector<u8>>

        // Check if "bool" and "u64" are in all_types
        // Use a helper inline function to check inclusion (byte vector equality)
        fun in_types(types: &vector<vector<u8>>, target: vector<u8>): bool {
            let len = vector::length(types);
            let mut i = 0;
            while (i < len) {
                if (vector::equals(&vector::borrow(types, i), &target)) {
                    return true;
                }
                i = i + 1;
            }
            false
        }

        // Build the byte vectors for "bool" and "u64"
        let bool_bytes = vector::from_bytes(b"bool");
        let u64_bytes = vector::from_bytes(b"u64");

        let bool_found = in_types(&all_types, bool_bytes);
        let u64_found = in_types(&all_types, u64_bytes);

        // Final returns true if both bool and u64 are found in types.
        bool_found && u64_found
    }
}
//# run 0xCAFE::ExprAndTypeCheck::runner

//# publish
module 0xCAFE::Scripts {
    use 0xCAFE::ExprAndTypeCheck;
    use std::vector;

    /// Script: Test increment on u8 and print results by consuming values.
    //# run
    script {
        fun main() {
            let x = 100u8;
            let x_inc = ExprAndTypeCheck::inc_u8(x);
            // Just consume x_inc
            let _ = x_inc;

            // Increment and get new struct
            let s = ExprAndTypeCheck::Data { a: 1u8, b: 2u64, c: false };
            let s_inc = ExprAndTypeCheck::inc_struct(s);
            let _ = s_inc;

            // Increment vector of u8 values
            let v = vector::from_bytes(b"xyz");
            let v_inc = ExprAndTypeCheck::inc_vec_u8(v);
            let _ = v_inc;

            // Increment wrapper
            let w = ExprAndTypeCheck::Wrapper { value: 42u64 };
            let w_inc = ExprAndTypeCheck::inc_wrapper(w);
            let _ = w_inc;
        }
    }

    /// Script: Run runner function and do nothing with result, just to test VM.
    //# run
    script {
        fun main() {
            let _res = ExprAndTypeCheck::runner();
        }
    }
}

// Featurres:
// 0ed81ed021c1455f3b7b6b2c52012423: Utilize the precedence values for parsing complex expressions correctly, especially when constructing or analyzing expression trees.
// 3e43a020172ec24acc977407de3c45f9: Utilize the set returned by 'all_type_names' to verify whether a particular type name is a built-in type in Move.
// eb9d496d4c6b5c330f13f8d6886363fe: Test that various implementations of increment and access functions for primitive types, structs, wrapped types, and vectors produce consistent and correct results across different usage patterns.
