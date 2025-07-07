
//# publish
module 0xCAFE::TestModule {
    // Define a simple non-native function to write to and read from a local variable.
    public fun non_native_function(val: u64): u64 {
        let temp = val;
        // Reassign the parameter reference
        temp = temp + 10;
        // Dereference to read the value
        return temp;
    }
}



//# publish
module 0xCAFE::SpecAttributeModule {
    // Simulate adding attributes to modules via spec module.
    // Here, we define a dummy attribute as a resource.
    resource struct ModuleAttribute {
        pub description: vector<u8>,
    }

    public fun add_attribute_to_module(attr: ModuleAttribute) {
        // In actual implementation, this might modify attributes or metadata,
        // but here we just declare the resource.
        move_to<AccountKey, ModuleAttribute>(&signer, attr);
    }
}



//# publish
// Merging attributes is conceptual; in actual Move, attributes are added via source line annotations or config.
module 0xCAFE::MergedModule {
    use 0xCAFE::SpecAttributeModule;

    // This module implicitly merges attributes from SpecAttributeModule.
    // For the test, we simulate that the attribute appears here.
    resource struct Attributes {
        description: vector<u8>,
    }

    public fun get_attributes(): Attributes {
        // In a real scenario, attributes might be merged or introspected.
        // Here, just return a dummy attribute.
        Attributes {
            description: b"Test attribute description",
        }
    }
}



//# run 0xCAFE::TestModule::non_native_function --signers 0xCAFE --args 42u64



//# run 0xCAFE::SpecAttributeModule::add_attribute_to_module --signers 0xCAFE --args 0xCAFE::MergedModule::Attributes
// Corrected the args: pass the resource instead of a string or invalid value.



//# run 0xCAFE::MergedModule::get_attributes --signers 0xCAFE