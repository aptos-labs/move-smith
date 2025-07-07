
//# publish
module 0xCAFE::LambdaModule {
    use std::vector;

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) {
            10u8
        } else {
            sum
        };
        result
    }

    public fun lambda_example(x: u8): u8 {
        let increment: |u8|u8 has copy+drop = |a: u8| {
            a + 1
        };
        increment(x)
    }

    public inline fun inline_addition(a: u8): u8 {
        a + 2
    }
}


//# run 0xCAFE::LambdaModule::add_two_values --args 4u8 7u8


//# run 0xCAFE::LambdaModule::lambda_example --args 5u8


//# run 0xCAFE::LambdaModule::inline_addition --args 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    fun inline_lit_class<T: copy + drop + store>(val: T): T {
        val
    }

    public fun call_inline_from_other_module(x: u8): u8 {
        let intermediate = LambdaModule::inline_addition(x);
        inline_lit_class(intermediate)
    }
}


//# run 0xCAFE::CallerModule::call_inline_from_other_module --args 5u8


//# publish
module 0xCAFE::ModuleA {
    friend 0xCAFE::ModuleB;
    use 0xCAFE::ModuleB;

    public fun from_a(): u8 {
        ModuleB::from_b()
    }
}


//# publish
module 0xCAFE::ModuleB {
    friend 0xCAFE::ModuleA;
    use 0xCAFE::ModuleA;

    public fun from_b(): u8 {
        42u8
    }
}

// This cyclic dependency is intended to test compiler error (not runnable)


//# publish
module 0xCAFE::AbilitiesModule {
    use std::vector;

    public fun example_generic<T: copy + drop + store + key>(x: T, vec: vector<T>): (T, vector<T>) {
        (x, vec)
    }
}


//# run 0xCAFE::AbilitiesModule::example_generic --args 10u8 vector[u8][1u8, 2u8, 3u8]



//# publish
module 0xCAFE::PrimitiveOps {
    use std::vector;

    public fun test_operations() {
        let a: u8 = 5;
        let b: u8 = 10;
        let c: bool = true;
        let d: bool = false;

        let _eq = a == b;
        let _neq = a != b;
        let _and = c && d;
        let _or = c || d;
        let _not = !c;

        let _bitwise_and = a & b;
        let _bitwise_or = a | b;
        let _bitwise_xor = a ^ b;

        let _add = a + b;
        let _sub = b - a;

        let vector_u8 = vector[0u8, 1u8, 2u8];
        let is_empty = vector::is_empty(&vector_u8);
        let len = vector::length(&vector_u8);
    }
}


//# run 0xCAFE::PrimitiveOps::test_operations


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e804905ce6742f65f069209e4daac6e8: Create mutual or cyclic dependencies between modules using 'use' or 'friend' relationships (although resulting in a compiler error).
// 2c877806b5aaac93b9a83e2cbd0f5fa0: Annotate each type parameter with its name and a list of abilities that it must satisfy.
// 865cb079e5af2fe3e29a6af9a9639ece: Test the correctness of equality, inequality, logical, bitwise, and numeric operations on various primitive types and vectors.
