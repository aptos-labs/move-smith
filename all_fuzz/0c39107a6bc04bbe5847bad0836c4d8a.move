
//# publish
module 0xCAFE::AdditionModule {
    // Function adds two u8s and returns their sum plus 1
    public fun add_then_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function that returns a lambda that adds two u8s and doubles the result
    public fun get_lambda(): |u8, u8|u8 has copy + drop {
        let lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            let s = x + y;
            s * 2
        };
        copy lambda
    }

    // Runner function testing code blocks
    public fun runner_code_block(): u8 {
        let a = 3;
        let b = 4;
        {
            let c = a + b;
            let d = c * 2;
            d + 1
        }
    }
}


//# run 0xCAFE::AdditionModule::add_then_increment --args 10u8 15u8


//# run 0xCAFE::AdditionModule::runner_code_block


//# publish
module 0xCAFE::LambdaUser {
    use 0xCAFE::AdditionModule;

    // Use inline call of AdditionModule's lambda
    public fun run_lambda_with_args(x: u8, y: u8): u8 {
        let lambda = AdditionModule::get_lambda();
        lambda(x, y)
    }

    // Nested call of add_then_increment from AdditionModule
    public fun nested_add_call(x: u8, y: u8): u8 {
        AdditionModule::add_then_increment(x, y)
    }
}


//# run 0xCAFE::LambdaUser::run_lambda_with_args --args 2u8 3u8


//# run 0xCAFE::LambdaUser::nested_add_call --args 5u8 6u8


// Dummy script to test bytecode dumping and transactional scripting

//# run
script {
    use 0xCAFE::AdditionModule;
    use 0xCAFE::LambdaUser;

    fun main() {
        let r1 = AdditionModule::add_then_increment(7u8, 8u8);
        let lambda = AdditionModule::get_lambda();
        let r2 = lambda(2u8, 3u8);
        let r3 = LambdaUser::run_lambda_with_args(9u8, 1u8);
        let r4 = LambdaUser::nested_add_call(11u8, 12u8);

        // sum of returns to avoid warning
        let _ = r1 + r2 + r3 + r4;
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4647e21fab2800f3dfe3303a6341d9da: Attach compiled modules and scripts to the environment for further use.
// 6368e3be802f97bc891c1d6ad6d9ce48: Automatically dump the bytecode of functions during pipeline execution for debugging purposes.
// 02631bce2439dd3897f85984bbc2d9bd: Write code blocks (sequences) comprising multiple statements and an optional final expression.
