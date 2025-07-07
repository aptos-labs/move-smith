
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Example implementation assuming f2 returns (x, x+1)
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::Calculator {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        // If sum is less than 100, return sum + 10, else return sum
        if (sum < 100) {
            sum + 10
        } else {
            sum
        }
    }

    public fun use_lambda_and_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
    
    public fun inline_caller(x: u16): u32 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        let sum = (a + b) as u32;
        sum
    }
}



//# run 0xCAFE::Calculator::add_two_numbers --args 40u8 50u8



//# run 0xCAFE::Calculator::add_two_numbers --args 60u8 50u8



//# run 0xCAFE::Calculator::use_lambda_and_add --args 7u8 8u8



//# run 0xCAFE::Calculator::inline_caller --args 20u16
