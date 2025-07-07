
//# publish
module 0xCAFE::Addition {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_sum(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# run 0xCAFE::Addition::add_and_return_sum --args 5u8 10u8




//# run 0xCAFE::Addition::lambda_sum --args 7u8 8u8




//# run 0xCAFE::Addition::inline_add --args 20u8 22u8




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Addition;

    public fun nested_call_sum(a: u8, b: u8): u8 {
        // Call the inline_add function from Addition module and then use the result in add_and_return_sum again
        let inner_sum = Addition::inline_add(a, b);
        Addition::add_and_return_sum(inner_sum, 1)
    }
}




//# run 0xCAFE::NestedCalls::nested_call_sum --args 10u8 15u8




//# publish
module 0xCAFE::LogicTest {
    // Test logical AND and OR expressions and update local variable accordingly
    public fun tester(b1: bool, b2: bool): u8 {
        // remove mut_x because it's unused
        if (b1 && b2) {
            let x = 3u8;
            // shadow mut_x with x within this scope
            x
        } else if (b1 || b2) {
            let x = 2u8;
            x
        } else {
            let x = 1u8;
            x
        }
    }
}



//# run 0xCAFE::LogicTest::tester --args true true




//# run 0xCAFE::LogicTest::tester --args true false




//# run 0xCAFE::LogicTest::tester --args false false




//# publish
module 0xCAFE::ReassignMove {
    struct M has drop, store {
        value: u8
    }

    public fun create_m(val: u8): M {
        M { value: val }
    }

    public fun test_reassign(cond: bool): u8 {
        let m = create_m(5u8);
        let M {value} = m; // move and destructure m, m no longer valid
        let x;
        if (cond) {
            x = value + 1u8;
        } else {
            x = value + 2u8;
        };
        x
    }
}



//# run 0xCAFE::ReassignMove::test_reassign --args true




//# run 0xCAFE::ReassignMove::test_reassign --args false




//# publish
module 0xCAFE::AccessSpecifiers {
    use std::signer;

    struct R has key, store {}

    public fun publish_resource(s: signer) {
        move_to<R>(&s, R {});
    }

    public fun read_resource(addr: address) {
        let _r_ref = borrow_global<R>(addr);
    }

    public fun update_resource(s: signer) {
        let r_mut = borrow_global_mut<R>(signer::address_of(&s));
        // do nothing but having writes specifier
        // (no-op)
    }

    public fun conditional_update(s: signer, flag: bool) {
        if (flag) {
            update_resource(s);
        } else {
            publish_resource(s);
        };
    }
}




//# run 0xCAFE::AccessSpecifiers::publish_resource --signers 0xDEAD




//# run 0xCAFE::AccessSpecifiers::read_resource --args 0xDEAD




//# run 0xCAFE::AccessSpecifiers::update_resource --signers 0xDEAD




//# run 0xCAFE::AccessSpecifiers::conditional_update --signers 0xDEAD --args true




//# run 0xCAFE::AccessSpecifiers::conditional_update --signers 0xDEAD --args false
