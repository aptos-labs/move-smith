
//# publish
module 0xCAFE::MyModule {
    public fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            x + 10
        } else {
            x
        }
    }
}


//# publish
module 0xCAFE::LambdaModule {
    public fun add_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun lambda_add_two_numbers(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(7u8, 8u8)
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let sum = 0xCAFE::MyModule::f1(a, true);
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + b
        };
        lambda(sum)
    }

    public fun test_return_previous_var(x: u8): u8 {
        let temp = x + 5;
        temp
    }
}



//# run 0xCAFE::LambdaModule::add_values --args 10u8 20u8



//# run 0xCAFE::LambdaModule::lambda_add_two_numbers



//# run 0xCAFE::LambdaModule::call_inline_and_lambda --args 3u8 4u8



//# run 0xCAFE::LambdaModule::test_return_previous_var --args 55u8



//# publish
module 0xCAFE::WhitespaceModule {
    
        
    public fun whitespace_test(x: u8, y: u8): u8 {
        
            // spaces, tabs, and newlines are allowed and ignored in the parser
            
        let     sum     =     x + y    
        ;
        
        sum
    }
}



//# run 0xCAFE::WhitespaceModule::whitespace_test --args 12u8 8u8
