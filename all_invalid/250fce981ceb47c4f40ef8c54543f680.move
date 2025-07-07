//# publish
module 0xCAFE::DebugAndLambdaTest {
    use std::debug;

    // Inline function that accepts a lambda as an argument and invokes it
    public inline fun call_lambda(x: u8, f: |u8|u8): u8 {
        f(x)
    }

    // Entry function to be called as a script entry point
    public entry fun entry_invoke_lambda(signer: signer) {
        let lambda: |u8| u8 = |a: u8| { a * 2 };
        let _result = call_lambda(10u8, lambda);
        debug::print(&b"Invoked lambda with value doubled\n");
    }

    // Normal public function (non-entry)
    public fun normal_function(x: u8): u8 {
        x + 42u8
    }
}

//# run 0xCAFE::DebugAndLambdaTest::entry_invoke_lambda --signers 0xCAFE

// Featurres:
// 33a0e94ea63008c770c66e673cd53379: Enable debugging mode for the Move compiler by setting the 'MOVE_COMPILER_DEBUG' or 'MVC_DEBUG' environment variable.
// ce0b87fbc06882d26f1bfd9a5b30df50: Test that an inline function can accept a function value (lambda/closure) as an argument and invoke it correctly.
// 6316d8fa2d30e15c3c8423f8853e1553: Create function definitions with correct naming, visibility, and optional 'entry' modifier.
