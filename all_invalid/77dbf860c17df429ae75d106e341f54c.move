
//# publish
module 0xB00B::AccessControl {
    // Use 'friend' visibility for functions accessible only within the same crate or to friends
    friend fun secret_function() {
        // Implementation can be empty for test
    }

    // Use 'public' visibility for functions accessible outside
    public fun public_function() {
        // Implementation can be empty for test
    }
}



//# run 0xB00B::AccessControl::public_function



//# run 0xB00B::AccessControl::secret_function --signers 0xB00B



//# publish
module 0xBABE::AttributeTest {
    // Specify a module attribute with special properties
    // package]
    struct AttrStruct has store, key {
        attr_value: u64,
        attr_name: vector<u8>,
    }

    // Attach an attribute to a function
    // friend]
    public fun annotated_function(x: u8): u8 {
        // Function body
        if (x > 0) {
            let _msg = b"Positive";
        } else {
            let _msg = b"Non-positive";
        };
        x
    }

    // Specification block with attributes
    /// // spec_attribute1]
    /// #![spec_attribute2]
    /// // spec_attribute3]
    public fun spec_block_testing() {
        // The block tests assignment to a module access expression only within a spec context
        // This is a compile-time check; in Move, it would be a comment or separate notation.
    }

    // Example to handle assignment to module access expression (禁止 in actual code, but could be in test)
    public fun assign_module_field() {
        // Simulate access to the module's attribute
        // Instead of direct reference, call a function or use a global resource
        // But since direct module field assignment isn't valid, this is a placeholder.
        // For the sake of the test, assume we're just referencing the module.
        // No actual assignment here.
    }
}



//# run 0xBABE::AttributeTest::annotated_function --args 5u8



//# run 0xBABE::AttributeTest::spec_block_testing



//# run 0xBABE::AttributeTest::assign_module_field
