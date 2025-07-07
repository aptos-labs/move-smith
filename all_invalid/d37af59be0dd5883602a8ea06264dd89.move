
//# publish
module 0xCAFE::FilterAndAttributesTest {
    use std::error;
    use std::signer;
    use std::vector;

    struct DummyResource has key, store {
        val: u8
    }

    public fun create_dummy(s: signer, val: u8) {
        let res = DummyResource { val };
        move_to<DummyResource>(&s, res);
    }

    public fun modify_dummy(s: signer, new_val: u8) {
        let r_mut = borrow_global_mut<DummyResource>(signer::address_of(&s));
        r_mut.val = new_val;
    }

    public fun trigger_abort(): u8 {
        // Abort unconditionally with major status 1001 and minor 42
        abort error::invalid_state(42);
    }

    public fun dummy_runner() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 42);
    }
}


//# run 0xCAFE::FilterAndAttributesTest::create_dummy --signers 0xBEEF --args 10u8


//# run 0xCAFE::FilterAndAttributesTest::modify_dummy --signers 0xBEEF --args 20u8

// We expect this to fail at runtime with major status 1001 and minor 42
// The attribute specifies the expected failure status codes
// expected_failure(major_status_code(1001), minor_status_code(42))]

//# run 0xCAFE::FilterAndAttributesTest::trigger_abort


//# run
script {
    // Attribute attached to use statements for demonstration
    // allow_unused_import]
    use 0xCAFE::FilterAndAttributesTest;
    // allow_unused_import]
    use std::vector;

    fun main() {
        // Using the module functions inside a script
        // The use of // allow_unused_import] attribute above guards compiler warnings
        // Just invoking dummy_runner to test script with use attributes
        FilterAndAttributesTest::dummy_runner();
    }
}


// Featurres:
// 8ba51c39e3186257d41cce7669e7a504: Define custom checks or transformations for scripts by implementing filtering in the compiler.
// a618575568cc48edf7aa4150c6567ef8: Attach attributes to individual 'use' declarations inside your script.
// e3177c9c5c4c2af6b70738a89240bfb7: Specify a major status code that your test is expected to produce using `#[expected_failure(major_status_code(...))]` attribute, with optional minor status code.
