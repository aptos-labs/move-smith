
//# publish
module 0xB00B::AccessControl {
    // Use 'friend' visibility for functions accessible only within the same crate or to friends
    friend fun secret_function() {
        // Implementation can be empty for test
    }

    // Use 'package' visibility for functions accessible within the package
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
        // This is just a placeholder for the test case, in real code such assignment is invalid outside specs.
        // But we simulate as if within a spec context.
        let module_ref = &0xBABE::AttributeTest;
        // Suppose in spec context, we assign to a field of the module, e.g.,
        // module_ref.attr_value = 42; -- but move does not support direct assignment, so just a placeholder
    }
}


//# run 0xBABE::AttributeTest::annotated_function --args 5u8


//# run 0xBABE::AttributeTest::spec_block_testing


//# run 0xBABE::AttributeTest::assign_module_field


// Featurres:
// 2056f17708d282991858422ba732d384: Use 'friend' visibility for functions accessible only within the same crate or to friends, and distinguish it from package visibility.
// 6339137e67c7ba33d130dcba563938ba: Attach attributes to specification blocks.
// 0e0348ef408dcf627617eaca95a68df8: Handle assignment to module access expressions only within a spec context.
