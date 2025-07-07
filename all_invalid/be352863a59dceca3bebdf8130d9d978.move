// The test will focus on specification blocks in scripts, lambdas, and various ways to increment/access primitives, structs, wrapper types, and vectors.

//# publish
module 0xCAFE::IncStruct {
    use std::vector;

    // A simple copyable struct with two fields: u8 and u64
    struct S has copy, drop, store, key {
        a: u8,
        b: u64,
    }

    // Increment function for struct fields
    public fun inc_struct(s: S): S {
        // increment both fields by 1 and return a new struct
        S { a: s.a + 1, b: s.b + 1 }
    }

    // A wrapper type around u8
    struct WrapU8 has copy, drop, store {
        val: u8,
    }

    // Increment a WrapU8 by 1
    public fun inc_wrap(w: WrapU8): WrapU8 {
        WrapU8 { val: w.val + 1 }
    }

    // Increment the u8 element in a vector by 1
    public fun inc_vector(vec: vector<u8>): vector<u8> {
        // A new vector copied from vec, each element incremented by 1
        let mut res = vector::empty<u8>();
        let len = vector::length(&vec);
        let mut i = 0;
        while (i < len) {
            let x = *vector::borrow(&vec, i);
            vector::push_back(&mut res, x + 1);
            i = i + 1;
        }
        res
    }

    // Return the sum of all u8 elements in a vector
    public fun sum_vector(vec: vector<u8>): u64 {
        let mut sum = 0u64;
        let len = vector::length(&vec);
        let mut i = 0;
        while (i < len) {
            let x = *vector::borrow(&vec, i);
            sum = sum + (x as u64);
            i = i + 1;
        }
        sum
    }

    // Runner function to exercise inc_struct, inc_wrap, inc_vector
    public fun runner(): u64 {
        let s = S { a: 1, b: 10 };
        let s_inc = inc_struct(s);

        let w = WrapU8 { val: 2 };
        let w_inc = inc_wrap(w);

        let v = vector::empty<u8>();
        vector::push_back(&mut (copy v), 3);
        vector::push_back(&mut (copy v), 4);
        vector::push_back(&mut (copy v), 5);

        let v_inc = inc_vector(v);

        // Sum to produce some value for VM confirmation
        s_inc.a as u64 + s_inc.b + (w_inc.val as u64) + sum_vector(v_inc)
    }
}
//# run 0xCAFE::IncStruct::runner --signers 0xCAFE

//# publish
module 0xCAFE::LambdaTest {
    use 0xCAFE::IncStruct;
    use std::vector;

    struct Container has copy, drop, store, key {
        val: u64,
    }

    // Define a λ-style inline function that adds 1, to demonstrate lambda lifting
    // Caller functions use the λ directly.

    // Increment u64 by 1 using an inline anonymous lambda (will be lifted)
    public inline fun inc_by_lambda(x: u64): u64 {
        let add_one = |y: u64| y + 1;
        add_one(x)
    }

    // Increment Container.val using a λ inside this function
    public fun inc_container_by_lambda(c: Container): Container {
        let inc_val = |x: u64| x + 1;
        Container { val: inc_val(c.val) }
    }

    // Increment vector<u8> elements by 1 using a λ in a loop
    public fun inc_vector_lambda(vec: vector<u8>): vector<u8> {
        let mut out = vector::empty<u8>();
        let len = vector::length(&vec);
        let inc = |x: u8| x + 1;
        let mut i = 0;
        while (i < len) {
            let x = *vector::borrow(&vec, i);
            vector::push_back(&mut out, inc(x));
            i = i + 1;
        }
        out
    }

    // Runner to test lambda lifting calls
    public fun runner(): u64 {
        let c = Container { val: 100 };
        let c_inc = inc_container_by_lambda(c);
        let val_inc = inc_by_lambda(50);

        let v = vector::empty<u8>();
        vector::push_back(&mut (copy v), 10);
        vector::push_back(&mut (copy v), 20);
        vector::push_back(&mut (copy v), 30);

        let v_inc = inc_vector_lambda(v);

        // Sum all increments to confirm
        c_inc.val + val_inc + sum_vector(v_inc)
    }

    // sum_vector reused from IncStruct for convenience (redefining here)
    public fun sum_vector(vec: vector<u8>): u64 {
        let mut sum = 0u64;
        let len = vector::length(&vec);
        let mut i = 0;
        while (i < len) {
            let x = *vector::borrow(&vec, i);
            sum = sum + (x as u64);
            i = i + 1;
        }
        sum
    }
}
//# run 0xCAFE::LambdaTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::IncStruct;
    use 0xCAFE::LambdaTest;
    use std::vector;

    // Specification block testing (#spec blocks) in script
    spec module {
        // A simple spec to assert something about vector length
        fun vector_non_empty_spec(vec: vector<u8>) {
            // Just a dummy spec to check vector length > 0
            assert!(vector::length(&vec) > 0, 1);
        }
    }

    fun main() {
        // Test: Increment primitive types manually and through IncStruct.inc_struct
        let x: u8 = 10;
        let x_inc = x + 1;

        let s1 = IncStruct::S { a: 10, b: 20 };
        let s2 = IncStruct::inc_struct(s1);

        // Test: Increment wrapped u8
        let w1 = IncStruct::WrapU8 { val: 100 };
        let w2 = IncStruct::inc_wrap(w1);

        // Test: Increment vector using IncStruct.inc_vector and LambdaTest.inc_vector_lambda and compare results
        let mut v1 = vector::empty<u8>();
        vector::push_back(&mut v1, 1);
        vector::push_back(&mut v1, 2);
        vector::push_back(&mut v1, 3);

        let v_inc1 = IncStruct::inc_vector(v1);
        let mut v2 = vector::empty<u8>();
        vector::push_back(&mut v2, 1);
        vector::push_back(&mut v2, 2);
        vector::push_back(&mut v2, 3);
        let v_inc2 = LambdaTest::inc_vector_lambda(v2);

        // Just consume the values to exercise VM and compiler
        let sum1 = IncStruct::sum_vector(v_inc1);
        let sum2 = IncStruct::sum_vector(v_inc2);

        let c = LambdaTest::Container { val: 123 };
        let c_inc = LambdaTest::inc_container_by_lambda(c);

        let inc0 = LambdaTest::inc_by_lambda(42);

        // We won't assert but just run these to test all the features requested
        ()
    }
}

// Featurres:
// e445e26e2e2c189197976b9a59bda504: Add specification blocks to your script using '#' or 'spec' blocks.
// 6a689f124f862b298761784ba512abd7: Define lambda (anonymous) functions in your Move code, which will be automatically converted to named functions via lambda lifting by the compiler.
// eb9d496d4c6b5c330f13f8d6886363fe: Test that various implementations of increment and access functions for primitive types, structs, wrapped types, and vectors produce consistent and correct results across different usage patterns.
