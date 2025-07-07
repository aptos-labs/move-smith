
//# publish
address_map {
    feature_map: vector<u8>, // Named address map for feature flags
}


//# publish
module 0xCAFE::AddressMapModule {
    // Function to get the address map
    public fun get_feature_map_addr(): vector<u8> {
        address_map::borrow_global::<vector<u8>>(&0xCAFE, b"feature_map")
    }
}


//# publish
module 0xCAFE::ScriptFilter {
    // Function to filter and transform script specifications
    public fun filter_transform_scripts(scripts: vector<vector<u8>>): vector<vector<u8>> {
        // Example: filter scripts that contain the byte 'A', transform by appending 'X'
        let result = vector::empty<vector<u8>>();
        let len = vector::length(&scripts);
        let i = 0;
        while (i < len) {
            let script = vector::borrow(&scripts, i);
            if (vector::contains(script, b"A")) {
                let transformed_script = vector::clone(script);
                vector::push_back(&mut transformed_script, b"X");
                vector::push_back(&mut result, transformed_script);
            }
            i = i + 1;
        }
        result
    }

    // Inline lambda to handle parameter substitution and return sum
    public fun compute_sum_with_lambda(x: u64, y: u64): u64 {
        let sum = (|a: u64, b: u64| a + b)(x, y);
        sum
    }
}


//# run 0xCAFE::AddressMapModule::get_feature_map_addr --signers 0xCAFE

//# run 0xCAFE::ScriptFilter::filter_transform_scripts --signers 0xCAFE --args 0x6120636861636b // contains 'a' (ASCII 0x61)

//# run 0xCAFE::ScriptFilter::compute_sum_with_lambda --signers 0xCAFE --args 5u64 10u64

// Featurres:
// 4ea79ea9656b6403591e39dee7b164b5: Access and utilize named address maps within a package.
// 9d772f2dfc9e51f96f4a68dcceb3c7e7: Manage script specifications by filtering and transforming them as needed.
// 6de0284693831c5e0d88fbb1cd795883: Test that the inline lambdas correctly handle parameter substitution and produce the expected arithmetic result when called with specific inputs.
