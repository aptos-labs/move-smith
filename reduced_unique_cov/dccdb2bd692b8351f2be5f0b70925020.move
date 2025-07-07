
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 0) {
            // do nothing
        } else {
            // unreachable for unsigned addition unless both are 0
        };
        42u8
    }

    public fun with_lambda_example(): u8 {
        let lambda: fun(u8, u8): u8 has copy + drop = fun(x: u8, y: u8): u8 {
            x + y
        };
        lambda(10u8, 20u8)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}



//# run 0xCAFE::AddModule::add_then_return_42 --args 5u8 7u8



//# run 0xCAFE::AddModule::with_lambda_example



//# publish
module 0xCAFE::RefModule {
    struct RefStruct has copy, drop {
        a: u8,
        b: u8,
    }

    public fun test_references() {
        let s = RefStruct {a: 10u8, b: 20u8};

        let r: &RefStruct = &s;
        let RefStruct {a: ref_ref_a, b: ref_ref_b} = *r;

        // Rebinding references
        let ref_ref_a = ref_ref_b;
        let ref_ref_b = ref_ref_a;

        let sm = RefStruct {a: 30u8, b: 40u8};
        let rm: &mut RefStruct = &mut sm;

        let RefStruct {a: ref_mut_a, b: ref_mut_b} = *rm;
        *ref_mut_a = 100u8;
        *ref_mut_b = 200u8;
    }
}



//# run 0xCAFE::RefModule::test_references



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun nested_inline_call(x: u8): u8 {
        AddModule::inline_increment(x)
    }
}



//# run 0xCAFE::CallerModule::nested_inline_call --args 41u8



//# publish
module 0xCAFE::InvariantModule {
    spec module {
        invariant forall(x: u8) { x <= 255 }
    }

    public fun always_true_spec() {
        //@ invariant true;
    }
}



//# publish
module 0xCAFE::LoopModule {
    public fun conditional_infinite_loop(cond: bool): u8 {
        let i = 0u8;
        loop {
            if (cond) {
                return 1u8;
            };
            i = i + 1u8;
            if (i > 10) {
                break;
            };
        };
        0u8
    }
}



//# run 0xCAFE::LoopModule::conditional_infinite_loop --args true



//# run 0xCAFE::LoopModule::conditional_infinite_loop --args false
