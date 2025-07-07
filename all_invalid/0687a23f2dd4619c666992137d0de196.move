// # publish
module 0xCAFE::TestModule {

    use std::debug;
    use std::env;

    /// A public function with public visibility that can be called from any module.
    public fun public_function(a: u64, b: u64): u64 {
        a + b
    }

    /// A helper function to simulate retrieving a token's location span.
    /// Since Move does not have a standard API for token spans, we will simulate it with a dummy struct and value.
    /// This function returns a dummy "span" representation as a vector<u8>.
    public fun get_token_span(): vector<u8> {
        // Simulate a token span: for example, "0xCAFE:Line 10-12" as bytes.
        b"0xCAFE:Line 10-12"
    }

    /// A function to fetch the environment variables for compiler experiments.
    /// Returns a tuple of two booleans for whether 'MVC_EXP' and 'MOVE_COMPILER_EXP' are set (non-empty).
    public fun check_env_vars(): (bool, bool){
        let mvc_exp = env::get_env(b"MVC_EXP");
        let move_compiler_exp = env::get_env(b"MOVE_COMPILER_EXP");
        let mvc_flag = !vector::is_empty(&mvc_exp);
        let move_compiler_flag = !vector::is_empty(&move_compiler_exp);
        (mvc_flag, move_compiler_flag)
    }

    /// A runner function to call all internal tests from the module side.
    public fun runner() {
        // Call the public_function and discard the output.
        let _ = public_function(10, 32);

        // Call get_token_span and discard the output.
        let _span = get_token_span();

        // Call check_env_vars and discard the output.
        let (_mvc, _move_exp) = check_env_vars();
    }
}
// # run 0xCAFE::TestModule::runner --signers 0xCAFE

// # run
script {
    use 0xCAFE::TestModule;

    fun main() {
        let sum = TestModule::public_function(100, 200);
        let span = TestModule::get_token_span();
        let (mvc_set, move_compiler_set) = TestModule::check_env_vars();

        // Just use values so compiler/Vm doesn't optimize out calls.
        debug::print(&b"Sum of 100 + 200 is:"[0..22]);
        debug::print(&vector::as_bytes(&b"0123456789"[0..0])); // empty print

        // We do not assert, just call functions to test compiler and VM.
        // Use sum to prevent warning
        let _ = sum + 0;
        let _ = span;
        let _ = mvc_set;
        let _ = move_compiler_set;
    }
}

// Featurres:
// 19657f4e140dd59df743a6ba2b8514a4: Declare functions with public visibility that can be called from any module.
// d90691870e0502a5a93f1dc4fe4ecfc9: Retrieve the location span of the consumed token for diagnostic or debugging purposes.
// 4e4182339c369d854f1903c208e6f1b0: Access environmental variables 'MVC_EXP' and 'MOVE_COMPILER_EXP' to determine compiler experiment configurations.
