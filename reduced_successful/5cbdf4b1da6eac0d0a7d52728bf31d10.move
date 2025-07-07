
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Simple example implementation: return (x, x+1)
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaExamples {
    struct Captured has copy, drop {
        v: u8
    }

    public fun add_two_u8(a: u8, b: u8): u8 {
        // sum and then add fixed 42 for returning
        let sum = a + b;
        sum + 42
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        // lambda adding two numbers then adding 10
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            s + 10
        };
        lambda(a, b)
    }

    public fun nested_inline_call(x: u16): u32 {
        // Call to inline function f2 in MyModule
        let (a, b) = 0xCAFE::MyModule::f2(x);
        // Return sum as u32
        (a as u32) + (b as u32)
    }

    public fun closure_with_capture(x: u8): u8 {
        let c = Captured {v: x};
        // closure capturing c.v and function argument x
        let closure: |u8| u8 has copy+drop = |param: u8| {
            // sum field v of captured struct and param and x
            c.v + param + x
        };
        closure(5u8)
    }

    public fun runner(): u8 {
        let a = add_two_u8(7u8, 8u8);
        let b = use_lambda(3u8, 4u8);
        let nested = nested_inline_call(5u16);
        let c = closure_with_capture(10u8);
        let sum = a + b + (nested as u8) + c;
        // return combined sum to test overall execution
        sum
    }
}



//# run 0xCAFE::LambdaExamples::add_two_u8 --args 10u8 20u8



//# run 0xCAFE::LambdaExamples::use_lambda --args 1u8 2u8



//# run 0xCAFE::LambdaExamples::nested_inline_call --args 100u16



//# run 0xCAFE::LambdaExamples::closure_with_capture --args 7u8



//# run 0xCAFE::LambdaExamples::runner
