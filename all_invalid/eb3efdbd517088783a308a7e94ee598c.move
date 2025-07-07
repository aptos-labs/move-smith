
//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;

    // Dummy Foo resource and module defined here to simulate external call
    // We provide a simple Foo with a make_foo function
    struct Foo has store, key { val: u8 }

    public fun make_foo(s: &signer) {
        let foo = Foo { val: 42 };
        move_to<Foo>(s, foo);
    }

    //
    // 1. Test "acquires" resource borrowing and closures restrictions
    //

    struct Res has key, store {
        x: u8,
    }

    public fun init_res(s: signer, val: u8) {
        let res = Res { x: val };
        move_to<Res>(&s, res);
    }

    // Function to test acquiring Res resource and attempting to capture mutable reference in closure
    // This should be rejected by the Move compiler - so this function is commented out to keep code compiling.
    /*
    public fun closure_with_acquire_ref(s: &signer) acquires Res {
        let res_ref: &mut Res = borrow_global_mut<Res>(signer::address_of(s));
        let f = || {
            // Trying to capture &mut Res ref in a lambda is invalid and should fail compile
            let _val = res_ref.x;
        };
        f();
    }
    */

    // To exercise the borrow and show resource acquiring works properly, a correct usage:
    public fun read_res_value(s: &signer) acquires Res {
        let res_ref: &Res = borrow_global<Res>(signer::address_of(s));
        res_ref.x
    }

    //
    // 2. Mutable variables and nested block semantics
    //

    public fun mutable_nested_blocks(x: u8): u8 {
        let a = x;
        {
            // Nested block
            a = a + 1;
            {
                // Nested nested block
                a = a * 2;
            };
            a = a + 3;
        };
        a
    }

    //
    // 3. Anonymous function invocation and resource initialization
    //

    public fun anon_function_initializes_foo(s: signer) {
        let f: |()|() = || {
            // call to make_foo
            AdvancedTest::make_foo(&s);
        };
        f();
    }

    public fun foo_value(s: &signer): u8 acquires Foo {
        let foo_ref = borrow_global<Foo>(signer::address_of(s));
        foo_ref.val
    }

    //
    // 4. Combined behavior verification
    //

    public fun combined_test(mut s: signer): u8 acquires Res, Foo {
        let x = 0u8;
        {
            // acquire Res resource and borrow mutably
            let res_ref: &mut Res = borrow_global_mut<Res>(signer::address_of(&s));
            res_ref.x = res_ref.x + 1;

            // nested lambda uses variable but NOT capturing res_ref
            let f: |()|() = || {
                x = x + 10;
            };
            f();

            // call make_foo via lambda
            let foo_init: |()|() = || {
                AdvancedTest::make_foo(&s);
            };
            foo_init();
        };

        // read resources to influence return value
        let res_val: u8 = borrow_global<Res>(signer::address_of(&s)).x;
        let foo_val: u8 = borrow_global<Foo>(signer::address_of(&s)).val;
        x + res_val + foo_val
    }
}



//# run 0xCAFE::AdvancedTest::init_res --signers 0xBEEF --args 5u8



//# run 0xCAFE::AdvancedTest::read_res_value --signers 0xBEEF



//# run 0xCAFE::AdvancedTest::mutable_nested_blocks --args 2u8



//# run 0xCAFE::AdvancedTest::anon_function_initializes_foo --signers 0xBEEF



//# run 0xCAFE::AdvancedTest::foo_value --signers 0xBEEF



//# run 0xCAFE::AdvancedTest::combined_test --signers 0xBEEF
