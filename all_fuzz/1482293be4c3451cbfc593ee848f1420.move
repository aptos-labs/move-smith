
//# publish
module 0xCAFE::AddModule {
    // Module to test addition of two u8 values and return specific values

    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun make_adder(x: u8): |u8| u8 {
        // Returns a lambda that adds x to its argument
        |y: u8| {
            x + y
        }
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 4u8 5u8


//# run 0xCAFE::AddModule::add_and_return --args 10u8 5u8


//# run 0xCAFE::AddModule::make_adder



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun call_lambda_example(): u8 {
        let adder = AddModule::make_adder(10u8);
        adder(5u8)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_lambda_example



//# run
script {
    use 0xCAFE::AddModule;
    use 0xCAFE::CallerModule;

    fun main() {
        let result1 = AddModule::add_and_return(7u8, 2u8);
        let result2 = AddModule::add_and_return(8u8, 5u8);
        let result3 = CallerModule::call_inline_add(1u8, 2u8);
        let result4 = CallerModule::call_lambda_example();

        // Just to keep these values in scope to avoid warnings
        result1;
        result2;
        result3;
        result4;
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d0f45a8325cce9350e8c9b2b6b3cb0c2: Define a script block in your Move code using the 'script' keyword and curly braces.
