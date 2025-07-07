
//# publish
module 0xCAFE::MathLambda {
    // Test 1 + 2 + 4 + 5

    // Function that adds two u8 values and returns a hardcoded u8
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;

        // Nested code block mutates outer-scope variable sum
        {
            let inner_sum = sum + 1;
            let sum = inner_sum;
            sum
        };

        sum
    }

    // Function that defines and calls a lambda adding two numbers and doubling the result
    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let res = a + b;
            res * 2
        };
        lambda(x, y)
    }

    // Function showing safe usage of references
    public fun ref_mutate(x: &mut u8) {
        *x = *x + 1;
    }

    public fun ref_test(): u8 {
        let mut_val = 10u8;
        let ref_to_mut_val: &mut u8 = &mut mut_val;
        ref_mutate(ref_to_mut_val);
        let ref_to_val: &u8 = &mut_val;
        *ref_to_val
    }
}


//# run 0xCAFE::MathLambda::add_and_return --args 3u8 4u8


//# run 0xCAFE::MathLambda::apply_lambda --args 2u8 5u8


//# run 0xCAFE::MathLambda::ref_test


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathLambda;

    // Call an inline function inside MathLambda via wrapper
    public inline fun inline_double_sum(a: u8, b: u8): u8 {
        MathLambda::apply_lambda(a, b)
    }

    // Nested call chaining
    public fun nested_chain(x: u8, y: u8): u8 {
        let first = MathLambda::add_and_return(x, y);
        let second = inline_double_sum(first, y);
        second
    }
}


//# run 0xCAFE::NestedCalls::inline_double_sum --args 3u8 4u8


//# run 0xCAFE::NestedCalls::nested_chain --args 1u8 2u8


//# publish
module 0xCAFE::EnumVariants {
    // Test 6 with mutating fields inside enum variants

    enum MyEnum has copy, drop {
        A { val: u8 },
        B { val: u8 },
    }

    // Return val fields added, mutate one val field
    public fun test_variants(): u8 {
        let a = MyEnum::A { val: 3u8 };
        let b = MyEnum::B { val: 5u8 };

        let sum = match (&a, &b) {
            (MyEnum::A { val: val_a }, MyEnum::B { val: val_b }) => *val_a + *val_b,
        };

        // Mutate val in variant A
        a = MyEnum::A { val: 10u8 };

        let new_sum = match (&a, &b) {
            (MyEnum::A { val: val_a }, MyEnum::B { val: val_b }) => *val_a + *val_b,
        };

        new_sum
    }
}


//# run 0xCAFE::EnumVariants::test_variants


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 8f0a7d00391a2f2ee7d7c59a4afa8206: Test that nested code blocks can access and mutate outer-scope variables correctly within an expression.
// 7bd4a348fb0b20c70f26990142b873c4: Verify that references are used safely and conform to Move's reference safety guarantees.
// 27caab84d63bd8f11cd0e5aff2f33529: Test that fields with the same name in different variants of an enum can be accessed and mutated correctly via variant bindings.
