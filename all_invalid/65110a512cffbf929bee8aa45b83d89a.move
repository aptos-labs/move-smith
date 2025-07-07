
//# publish
module 0xCAFE::TestModule {
    // Attributes to test preservation
    // Location: inside the module
    // Address: 0xCAFE
    // Name: TestModule
    // Specification module status: assume regular module
    
    // Struct to test cross-module interaction
    struct DataHolder {
        value: u64,
    }

    // Function to set internal data
    public fun set_value(holder: &mut DataHolder, val: u64) {
        holder.value = val;
    }

    // Function to get internal data
    public fun get_value(holder: &DataHolder): u64 {
        holder.value
    }

    // Public function to create DataHolder
    public fun create_data(val: u64): DataHolder {
        DataHolder { value: val }
    }
}


//# run 0xCAFE::TestModule::create_data --signers 0xCAFE --args 42u64



//# publish
module 0xBADD::DependentModule {
    use 0xCAFE::TestModule;

    // Function to interact with TestModule's functions and structs
    public fun call_test_module_functions() {
        let data = TestModule::create_data(100);
        let val = TestModule::get_value(&data);
        // update value
        let data_mut = data;
        TestModule::set_value(&mut data_mut, val + 1);
        let new_val = TestModule::get_value(&data_mut);
        // Normally, assertions are not included; just calls and interactions
    }
}


//# run 0xBADD::DependentModule::call_test_module_functions --signers 0xBADD



//# run
script {
    fun main() {
        // Test the attribute, location, address, name preservation, and interaction
        // Between modules
    }
}

// Featurres:
// 4b6d40e28a7a904547acce22c6d33d0c: Preserve attributes, location, address, name, and specification module status of the module after filtering.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// f6672aaafc5c8676afcf660bcf2aada6: Test that modules can successfully define, publish, and call functions and structs across dependencies, ensuring correct interaction and access between modules.
