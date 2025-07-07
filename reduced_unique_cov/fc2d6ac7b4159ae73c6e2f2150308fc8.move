
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Simple example: return (x, x + 1)
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::AddModule {
    // import MyModule to call f2
    use 0xCAFE::MyModule;

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < a) {
            // Overflow occurred, abort with code 1
            abort 1;
        };
        // Return sum plus fixed offset 5 (to check correct addition before a specific return)
        sum + 5
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        // Lambda that returns product plus sum
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * y + (x + y)
        };
        lambda(a, b)
    }

    public fun call_other_inline(x: u16): u16 {
        // Calls an inline function f2 from MyModule to get tuple, then sum components
        let (a, b) = MyModule::f2(x);
        a + b
    }

    // Private function: should not be accessible outside
    fun private_function(): u8 {
        42
    }
}



//# run 0xCAFE::AddModule::add_two_u8 --args 10u8 20u8



//# run 0xCAFE::AddModule::use_lambda --args 3u8 4u8



//# run 0xCAFE::AddModule::call_other_inline --args 100u16



//# publish
module 0xCAFE::VectorAborts {
    use std::vector;

    public fun abort_on_overflow_push() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 255);
        // Add 1 to cause overflow: 255 + 1 = 0 (overflow)
        let val = *vector::borrow(&v, 0);
        if (val == 255) {
            let res = val + 1;
            if (res < val) {
                abort 100; // Overflow detected
            };
        };
    }

    public fun abort_on_div_zero() {
        let denom = 0u8;
        if (denom == 0) {
            abort 101;
        };
        let _res = 10 / denom;
    }

    public fun abort_on_out_of_range_shift() {
        let x: u8 = 1;
        let shift_amount = 8u8; // u8 shift max index is 7
        if (shift_amount >= 8) {
            abort 102;
        };
        let _y = x << shift_amount;
    }
}



//# run 0xCAFE::VectorAborts::abort_on_overflow_push



//# run 0xCAFE::VectorAborts::abort_on_div_zero



//# run 0xCAFE::VectorAborts::abort_on_out_of_range_shift
