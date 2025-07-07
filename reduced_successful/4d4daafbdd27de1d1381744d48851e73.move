
//# publish
module 0xCAFE::TestAdditionAndLambda {
    // Removed unused alias 'std::signer'

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        assert!(sum == x + y, 100);
        // Returns sum + 1 for testing add operation + return
        sum + 1
    }

    public fun call_lambda_with_args(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    public fun use_lambda_return_sum_only(x: u8, y: u8): u8 {
        let (sum, _) = call_lambda_with_args(x, y);
        sum
    }
}



//# run 0xCAFE::TestAdditionAndLambda::add_and_return_sum --args 10u8 15u8



//# run 0xCAFE::TestAdditionAndLambda::call_lambda_with_args --args 4u8 5u8



//# run 0xCAFE::TestAdditionAndLambda::use_lambda_return_sum_only --args 6u8 7u8



//# publish
module 0xCAFE::NestedCallModule {
    // Add `use` statement to import TestAdditionAndLambda from address 0xCAFE
    use 0xCAFE::TestAdditionAndLambda;

    // Implementing the f2 logic directly here since MyModule is not accessible
    // Assumed f2(x: u16) returns tuple (u16, u16)
    fun f2(x: u16): (u16, u16) {
        // For demonstration, split x into two parts, e.g., low 8 bits and high 8 bits
        let val1 = x & 0xFF;
        let val2 = (x >> 8) & 0xFF;
        (val1, val2)
    }

    // Calls local f2 inline and uses the result in a nested call to f1 from TestAdditionAndLambda
    public fun nested_calls(x: u16, y: bool): u8 {
        let (val1, val2) = Self::f2(x);
        // Sum val1 and val2 then call add_and_return_sum to add 1
        let sum = (val1 as u8) + (val2 as u8);
        TestAdditionAndLambda::add_and_return_sum(sum, 0u8)
    }
}



//# run 0xCAFE::NestedCallModule::nested_calls --args 20u16 true
