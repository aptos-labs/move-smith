
//# publish
module 0xCAFE::ComputeAdd {
    /// A simple function that adds two u8s and then returns a fixed value 42u8.
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum; // Usage of sum to show correct computation
        42u8
    }

    /// A function that takes a u8 and returns a lambda that adds that value to its argument.
    public fun make_adder(x: u8): |u8|u8 {
        let add_x = |y: u8| { x + y };
        add_x
    }

    /// Uses the lambda returned by make_adder and applies it to 5.
    public fun use_adder(x: u8): u8 {
        let adder = make_adder(x);
        adder(5)
    }
}



//# run 0xCAFE::ComputeAdd::add_and_return_fixed --args 20u8 22u8



//# run 0xCAFE::ComputeAdd::use_adder --args 10u8




//# publish
module 0xCAFE::NestedInlineCall {
    /// Inline function f2 defined here instead of using MyModule.
    /// This replaces the call to the unavailable MyModule::f2.
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    /// Calls local function f2 inline function, returns the sum of both tuple values
    public fun call_my_module_f2(a: u16): u16 {
        let (x, y) = f2(a);
        x + y
    }
}



//# run 0xCAFE::NestedInlineCall::call_my_module_f2 --args 100u16




//# publish
module 0xCAFE::ReferenceSafetyTest {
    /// This function does nothing practical but exists to create annotation showing reference safety.
    /// Checks reference usage via dummy borrow operations.
    public fun dummy_ref_safety() {
        let x = 10u8;
        let y = &x;
        let _z = *y;
    }
}



//# run 0xCAFE::ReferenceSafetyTest::dummy_ref_safety




//# publish
module 0xCAFE::BranchMutationTest {
    /// This function demonstrates a local mutable variable changed inside branches,
    /// and then used after calls and control-flow changes.
    public fun mutate_local_var(x: u8, flag: bool): u8 {
        let val = x;

        if (flag) {
            val = val + 5;
        } else {
            val = val + 10;
        };

        // Call to ComputeAdd::add_and_return_fixed to produce some side effect (though unused result)
        let _ = 0xCAFE::ComputeAdd::add_and_return_fixed(val, 1u8);

        // Another branch mutation after call
        if (val > 10) {
            val = val * 2;
        } else {
            val = val + 1;
        };

        val
    }
}



//# run 0xCAFE::BranchMutationTest::mutate_local_var --args 3u8 true



//# run 0xCAFE::BranchMutationTest::mutate_local_var --args 3u8 false
