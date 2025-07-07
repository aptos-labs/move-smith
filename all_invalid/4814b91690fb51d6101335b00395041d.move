
//# publish
module 0xABCDE::DebugLogExample {
    use std::debug;

    // Dummy function to simulate bytecode dump name retrieval
    public fun get_bytecode_name(source_path: vector<u8>): vector<u8> {
        let name = b"DebugLogExample.mv";
        name
    }

    // Enable debug logging with detailed info
    public fun log_debug_info(source_path: vector<u8>) {
        let name = get_bytecode_name(source_path);
        debug::print(&name);
        debug::print(b"Debug info: Enabled detailed debug logging for the module.");
    }
}



//# run 0xABCDE::DebugLogExample::log_debug_info --args b"DebugLogExample.mv"



//# publish
module 0x12345::LambdaTest {
    use std::vector;

    // Define a public entry function that takes a lambda, invokes it, then calls another lambda inside
    public fun run_lambda_chain(lambda1: |u8|u8, lambda2: |u8|u8, input: u8): u8 {
        let result1 = lambda1(input);
        let result2 = lambda2(result1);
        result2
    }

    // Test that the chain of lambdas works properly
    public fun test_lambda_chain(): u8 {
        let lambda_a = |x: u8| { x + 10 };
        let lambda_b = |x: u8| { x * 2 };
        let input_value = 5;
        run_lambda_chain(lambda_a, lambda_b, input_value)
    }
}



//# run 0x12345::LambdaTest::test_lambda_chain



//# publish
module 0xXYZ::AddressModules {
    // Empty module for 'address' block test
}



//# run 0xXYZ::AddressModules::/* no functions */ 
