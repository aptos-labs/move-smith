
//# publish
module 0xCAFE::ShadowingTest {
    use std::signer;

    // A struct to store the state so we can access after function calls
    struct State has store, key {
        x: u8,
        y: u8,
    }

    public fun create_state(s: signer) {
        let state = State {x: 1, y: 0};
        move_to<State>(&s, state);
    }

    public fun get_x(s: signer): u8 {
        let state_ref = borrow_global<State>(signer::address_of(&s));
        state_ref.x
    }

    public fun foo(s: signer) {
        let state_mut_ref = borrow_global_mut<State>(signer::address_of(&s));
        let x = state_mut_ref.x; // outer variable x

        // Define inner function that shadows outer x
        let inner = |_: ()| {
            let x = 3u8; // shadowing outer x
            // update outer state x by assigning to captured outer variable
            state_mut_ref.x = x;
            ()
        };
        inner(());
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


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
// b1ef4ed77187c7b101df5197f583d1cd: Reference modules by address and name for organizing and extracting spec modules
