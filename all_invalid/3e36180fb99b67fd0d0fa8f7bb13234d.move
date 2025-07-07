
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

    public fun trigger_abort(): ! {
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
// // expected_failure(major_status_code(1001), minor_status_code(42))]


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
