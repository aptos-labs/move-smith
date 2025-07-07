
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returns sum + 10 to differentiate from simple sum
        sum + 10
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(5u8, 7u8)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Call the inline function from AddModule and add 5 to the result
    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let sum = AddModule::inline_adder(x, y);
        sum + 5
    }

    // Function that accepts a lambda that takes a u8 and returns u8
    public fun apply_lambda_on_value(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // Compose lambdas where inner lambda calls another lambda
    public fun nested_lambda_call(val: u8): u8 {
        let inner: |u8|u8 has copy+drop = |x: u8| { x + 1 };
        let outer: |u8|u8 has copy+drop = |y: u8| { inner(y) * 2 };
        outer(val)
    }
}


//# publish
module 0xCAFE::CycleA {
    use 0xCAFE::CycleB;

    public fun call_b(): u8 {
        CycleB::f_b(7u8)
    }
}


//# publish
module 0xCAFE::CycleB {
    // Attempt cycle back to CycleA would cause cyclic dependency in compile
    // So we just have a simple function here to avoid real cyclic dependency

    public fun f_b(x: u8): u8 {
        x + 1
    }
}


//# run
script {
    use 0xCAFE::AddModule;
    use 0xCAFE::CallerModule;

    fun main() {
        let res1 = AddModule::add_two_values(10u8, 15u8);
        let res2 = AddModule::lambda_example();
        let res3 = CallerModule::call_inline_and_add(3u8, 4u8);
        let res4 = CallerModule::apply_lambda_on_value(|x: u8| x * 3, 7u8);
        let res5 = CallerModule::nested_lambda_call(4u8);

        // Call CycleA function which internally calls CycleB::f_b
        let res6 = 0xCAFE::CycleA::call_b();

        // Use Call and ExpCall style expressions by calling function pointers and inline

        let add_lambda: |u8, u8| u8 has copy+drop = AddModule::inline_adder;
        let call_res = add_lambda(1u8, 2u8);

        let expcall_lambda: |u8| u8 has copy+drop = |x: u8| x * 2;
        let expcall_res = expcall_lambda(10u8);
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 100u8 23u8


//# run 0xCAFE::AddModule::lambda_example


//# run 0xCAFE::CallerModule::call_inline_and_add --args 2u8 3u8


//# run 0xCAFE::CallerModule::apply_lambda_on_value --args 9u8


//# run 0xCAFE::CallerModule::nested_lambda_call --args 5u8


//# run 0xCAFE::CycleA::call_b


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 8c738cf5e5ee14fc926782c3f0f6d187: Test that lambda expressions (function values) can be passed as arguments to public entry functions, including using lambdas that call other lambdas as arguments.
// 6e7f8c199062bf035188cb2f18b2119e: Detect and prevent cyclic dependencies between Move modules.
// 4b2614c9bb3829530ed34b3fe278aa0e: Call functions, including lambda or function pointer calls, with `Call` and `ExpCall` expressions.
