
//# publish
module 0xCAFE::ShadowingTest {
    use std::signer;
    use std::vector;

    struct State has store, key {
        x: u8,
        y: u8,
    }

    public fun create_state(s: signer) {
        let state = State { x: 1, y: 0 };
        move_to<State>(&s, state);
    }

    public fun get_x(s: signer): u8 {
        let state_ref = borrow_global<State>(signer::address_of(&s));
        state_ref.x
    }

    public fun foo(s: signer) {
        // Borrow mutable reference outside inner function
        let state_mut_ref = borrow_global_mut<State>(signer::address_of(&s));
        let x = state_mut_ref.x; // outer variable x

        // Instead of capturing the mutable reference (which is disallowed),
        // pass the mutable reference as an argument to the inner closure.
        // Because Move closures cannot capture mutable references,
        // we'll make inner a local function instead.

        inner(&mut state_mut_ref);
    }

    // Define inner as a public friend function (or private function) taking mutable ref
    fun inner(state_mut_ref: &mut State) {
        let x = 3u8; // shadowing outer x
        state_mut_ref.x = x;
    }
}




//# run 0xCAFE::ShadowingTest::create_state --signers 0xBEEF


//# run 0xCAFE::ShadowingTest::get_x --signers 0xBEEF


//# run 0xCAFE::ShadowingTest::foo --signers 0xBEEF


//# run 0xCAFE::ShadowingTest::get_x --signers 0xBEEF




//# publish
module 0xCAFE::CallArgumentsTest {
    use std::signer;

    public fun sum_three(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }

    public fun call_sum() : u8 {
        sum_three(1u8, 2u8, 3u8)
    }
}




//# run 0xCAFE::CallArgumentsTest::call_sum




//# publish
module 0xCAFE::PropertySetTest {
    use std::signer;

    struct Props has store, key {
        flag: bool,
        count: u64,
        ratio: u8,
    }

    public fun create_props(s: signer) {
        move_to<Props>(&s, Props {
            flag: true,
            count: 123456789u64,
            ratio: 42u8,
        });
    }

    public fun update_props(s: signer) {
        let props_mut_ref = borrow_global_mut<Props>(signer::address_of(&s));
        props_mut_ref.flag = false;
        props_mut_ref.count = props_mut_ref.count + 1u64;
        props_mut_ref.ratio = 100u8 - props_mut_ref.ratio;
    }

    public fun get_props(s: signer): (bool, u64, u8) {
        let props_ref = borrow_global<Props>(signer::address_of(&s));
        (props_ref.flag, props_ref.count, props_ref.ratio)
    }
}




//# run 0xCAFE::PropertySetTest::create_props --signers 0xBEEF




//# run 0xCAFE::PropertySetTest::get_props --signers 0xBEEF




//# run 0xCAFE::PropertySetTest::update_props --signers 0xBEEF




//# run 0xCAFE::PropertySetTest::get_props --signers 0xBEEF





//# publish
module 0xCAFE::SpecModules {
    // Dummy module to simulate a spec module
    public fun spec_foo(): u8 {
        7u8
    }
}




//# publish
module 0xCAFE::ModuleExtraction {
    use 0xCAFE::SpecModules;

    public fun call_spec(): u8 {
        SpecModules::spec_foo()
    }
}




//# run 0xCAFE::ModuleExtraction::call_spec
