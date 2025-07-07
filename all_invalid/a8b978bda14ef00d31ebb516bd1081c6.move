//# publish
module 0xCAFE::LintAndErrors {
    use std::error;
    use std::signer;

    // A resource struct with multiple fields declared in a brace-enclosed, comma-separated list
    struct DemoFields has store, key {
        a: u8,
        b: u16,
        c: bool,
    }

    // Declaring a function with comma-separated parameters enclosed in parentheses
    public fun create_demo_fields(s: signer, a: u8, b: u16, c: bool) {
        let demo = DemoFields { a, b, c };
        move_to<DemoFields>(&s, demo);
    }

    // Update function to test error reporting using std::error
    public fun update_demo_fields(s: signer, a: u8, b: u16, c: bool): u8 {
        let demo_ref = borrow_global_mut<DemoFields>(signer::address_of(&s));
        demo_ref.a = a;
        demo_ref.b = b;
        demo_ref.c = c;

        // Trigger an error condition if a is zero, to test error reporting
        if (a == 0) {
            error::abort(1234);
        };
        demo_ref.a
    }

    // Function that returns multiple values in a comma-separated list enclosed in parentheses
    public fun get_fields(s: signer): (u8, u16, bool) {
        let demo_ref = borrow_global<DemoFields>(signer::address_of(&s));
        (demo_ref.a, demo_ref.b, demo_ref.c)
    }
}

//# run 0xCAFE::LintAndErrors::create_demo_fields --signers 0x42 --args 1u8 100u16 true

//# run 0xCAFE::LintAndErrors::get_fields --signers 0x42

//# run 0xCAFE::LintAndErrors::update_demo_fields --signers 0x42 --args 10u8 200u16 false

//# run 0xCAFE::LintAndErrors::update_demo_fields --signers 0x42 --args 0u8 50u16 true