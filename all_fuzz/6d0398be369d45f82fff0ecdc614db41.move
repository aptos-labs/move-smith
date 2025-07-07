
//# publish
module 0xCAFE::MyModule {
    // define the missing inline function f2 returning a tuple (u16, u16)
    public inline fun f2(val: u16): (u16, u16) {
        (val, val + 1)
    }
}

//# publish
module 0xCAFE::Addition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let return_value = sum + 10;
        return_value
    }

    public fun call_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(2u8, 3u8)
    }

    public fun use_inline_and_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            // use inline function from MyModule with casting
            let (x1, _x2) = 0xCAFE::MyModule::f2((x as u16) + (y as u16));
            // sum of x, y plus first returned inline function value cast to u8
            x + y + (x1 as u8)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::Addition::add_and_return_sum --args 5u8 7u8



//# run 0xCAFE::Addition::call_lambda_example



//# run 0xCAFE::Addition::use_inline_and_lambda --args 3u8 4u8
