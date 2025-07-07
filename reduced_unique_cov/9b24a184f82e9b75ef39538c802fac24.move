
//# publish
module 0xCAFE::Adder {
    // This module tests simple addition and inline function call
    
    /// Adds two u8 values and returns sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Inline function to add three u16 values
    public inline fun add_three(a: u16, b: u16, c: u16): u16 {
        a + b + c
    }
}



//# publish
module 0xCAFE::LambdaExamples {
    // This module tests lambda expressions and passing lambdas as function arguments

    public fun run_lambda() {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y + 5
        };
        let _result = lambda(3u8, 4u8);
    }

    public fun call_lambda_functor(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    public fun example_caller(): u8 {
        // anonymous lambda that doubles input
        let double_lambda: |u8|u8 has copy+drop = |v: u8| { v * 2 };
        call_lambda_functor(double_lambda, 10u8)
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    // This module tests calling inline functions and nested call chains

    public fun nested_sum(a: u16, b: u16, c: u16): u16 {
        let inner_sum = Adder::add_three(a, b, c);
        inner_sum + 5
    }
}



//# publish
module 0xCAFE::CopyAssignTest {
    // This module tests copying and assigning u64 values through multiple bindings

    public fun copy_and_assign(x: u64): u64 {
        let a = x;
        let b = a;
        let c = b;
        c
    }
}



//# publish
module 0xCAFE::SpecSchemaWithTypeParam {
    // This module demonstrates attaching specification blocks with schemas with type parameters

    struct Container<T> has copy, drop, store {
        val: T
    }

    spec schema ValEquals<T> {
        val: &T;
        equal_to_expected: bool;
    }

    spec fun check_val<T>(c: &Container<T>, expected: &T): ValEquals<T> {
        ValEquals<T> { val: &c.val, equal_to_expected: true }
    }
}



//# run 0xCAFE::Adder::add_and_offset --args 5u8 7u8



//# run 0xCAFE::LambdaExamples::run_lambda



//# run 0xCAFE::LambdaExamples::example_caller



//# run 0xCAFE::NestedCalls::nested_sum --args 1u16 2u16 3u16



//# run 0xCAFE::CopyAssignTest::copy_and_assign --args 100u64
