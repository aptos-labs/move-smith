
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 10u8; // add constant to test computation
        result
    }

    // Function using lambda expression to multiply two u8 numbers and return the product
    public fun multiply_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    // Inline function returning u8 sum of two numbers
    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::AddModule::multiply_with_lambda --args 7u8 6u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddModule;

    public fun nested_sum_and_add(x: u8, y: u8): u8 {
        let partial = AddModule::add_inline(x, y);
        AddModule::add_and_return_sum(partial, 5u8)
    }

    public fun lambda_caller_lambda(z: u8): u8 {
        let lambda: |u8|u8 = |v: u8| {
            nested_sum_and_add(v, 3u8)
        };
        lambda(z)
    }

    // Instantiate generic struct and return a field value
    struct GenericHolder<T> has copy, drop {
        value: T
    }

    public fun use_generic_struct(a: u8): u8 {
        let holder = GenericHolder<u8> { value: a };
        holder.value
    }

    // Runner function to test nested sum call
    public fun runner(): u8 {
        let s1 = nested_sum_and_add(20u8, 22u8);
        let s2 = lambda_caller_lambda(10u8);
        let s3 = use_generic_struct(99u8);
        s1 + s2 + s3
    }
}


//# run 0xCAFE::NestedCall::nested_sum_and_add --args 2u8 3u8


//# run 0xCAFE::NestedCall::lambda_caller_lambda --args 5u8


//# run 0xCAFE::NestedCall::use_generic_struct --args 42u8


//# run 0xCAFE::NestedCall::runner


//# run
script {
    use 0xCAFE::AddModule;
    use 0xCAFE::NestedCall;

    fun main() {
        let add_result = AddModule::add_and_return_sum(4u8, 5u8);
        let mul_result = AddModule::multiply_with_lambda(3u8, 4u8);
        let nested_result = NestedCall::nested_sum_and_add(7u8, 8u8);
        let lambda_result = NestedCall::lambda_caller_lambda(6u8);
        let generic_result = NestedCall::use_generic_struct(123u8);
        let runner_result = NestedCall::runner();

        // no assertions needed; just running for compiler and VM exercise;
        // values are not used further
        let _ = add_result;
        let _ = mul_result;
        let _ = nested_result;
        let _ = lambda_result;
        let _ = generic_result;
        let _ = runner_result;
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 20b305c5a5055d33eca4e37722be0cb7: Define modules and script modules in Move code to generate file format compiled units.
// 71814ed2b9300233e88c1463ffcc3e9a: Define and instantiate custom structs, including parameterized (generic) structs.
