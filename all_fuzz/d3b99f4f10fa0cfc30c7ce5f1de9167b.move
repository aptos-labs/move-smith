
//# publish
module 0xCAFE::TestModuleA {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // This function returns sum + 10 as a specific value
        sum + 10
    }

    public fun lambda_test(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun conditional_return(b: bool): u8 {
        let ret: u8;
        if (b) {
            ret = 100u8;
        } else {
            ret = 200u8;
        };
        ret
    }

    public fun tuple_return(a: u8, b: u8): (u8, u8) {
        (a, b)
    }

    // Cannot accept tuple parameters, so accept two u8 parameters instead
    public fun tuple_argument(x: u8, y: u8): u8 {
        x + y
    }
}



//# publish
module 0xCAFE::TestModuleB {
    // No need to "use" statement because these are sibling modules in the same address,
    // and use is not standard in Aptos Move for sibling modules.
    public fun call_inline_increment_from_a(x: u8): u8 {
        0xCAFE::TestModuleA::inline_increment(x)
    }
}



//# run 0xCAFE::TestModuleA::add_and_return_sum --args 5u8 6u8


//# run 0xCAFE::TestModuleA::lambda_test --args 10u8 15u8


//# run 0xCAFE::TestModuleB::call_inline_increment_from_a --args 99u8


//# run 0xCAFE::TestModuleA::conditional_return --args true


//# run 0xCAFE::TestModuleA::conditional_return --args false


//# run 0xCAFE::TestModuleA::tuple_return --args 7u8 8u8


//# run 0xCAFE::TestModuleA::tuple_argument --args 7u8 8u8
