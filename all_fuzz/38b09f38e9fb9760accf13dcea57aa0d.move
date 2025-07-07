
//# publish
module 0xCAFE::TestModuleA {
    /// A simple function that adds two u8 values and returns the sum plus a constant offset.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun caller_of_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |val: u8| {
            val * 2u8
        };
        lambda(x)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    // Example of a function using skip attribute (commented out because this is just an example)
    // // skip(address)]
    // public fun skip_example(x: u8): u8 {
    //     x + 1u8
    // }

    public fun with_ability_constraints<T: copy+drop>(x: T): T {
        x
    }
}


//# run 0xCAFE::TestModuleA::add_and_offset --args 5u8 7u8


//# run 0xCAFE::TestModuleA::caller_of_lambda --args 3u8


//# publish
module 0xCAFE::TestModuleB {
    use 0xCAFE::TestModuleA;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let sum = TestModuleA::inline_adder(a, b);
        sum * 2u8
    }
}


//# run 0xCAFE::TestModuleB::nested_inline_call --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 1685438536d8cc8c135091d1019a6c42: Ensure that when using the `skip` attribute, the specified lint names are known and valid, or the compiler will generate an error.
// 1f1e15d73a91ef2d9e16f4165568f8a3: Include ability constraints in type parameter declarations to enforce capabilities.
