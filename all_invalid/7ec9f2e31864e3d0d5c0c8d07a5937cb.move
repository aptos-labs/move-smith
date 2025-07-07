//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Define a schema-like struct with function members for organized code
    struct SpecsHolder {
        specs: vector<vector<u8>>,
        processed: vector<vector<u8>>,
    }

    public fun new_specs_holder(specs: vector<vector<u8>>): SpecsHolder {
        let processed = Self::process_specs(&specs);
        SpecsHolder { specs, processed }
    }

    // 1. Add function member: a method to add a spec
    public fun add_spec(holder: &mut SpecsHolder, spec: vector<u8>) {
        vector::push_back(&mut holder.specs, spec);
        holder.processed = Self::process_specs(&holder.specs);
    }

    // 2. Convert vector of specs into processed specs
    public fun process_specs(specs: &vector<vector<u8>>): vector<vector<u8>> {
        let result = vector::empty<vector<u8>>();
        let len = vector::length(specs);
        let mut i: u64 = 0;
        while (i < len) {
            let spec = vector::borrow(specs, i);
            // For illustration, let's prepend a byte to each spec
            let mut processed_spec = vector::empty<u8>();
            vector::push_back(&mut processed_spec, 0xFF);
            let spec_len = vector::length(spec);
            let mut j: u64 = 0;
            while (j < spec_len) {
                let byte = *vector::borrow(spec, j);
                vector::push_back(&mut processed_spec, byte);
                j = j + 1;
            }
            vector::push_back(&mut result, processed_spec);
            i = i + 1;
        }
        result
    }

    // 3. Unpack multiple fields from a composite data structure
    struct Data {
        field_a: u64,
        field_b: u8,
        field_c: bool,
    }

    public fun unpack_and_process(data: Data) {
        let Data { field_a, field_b, field_c } = data;
        // Process each field separately (No assertions; just dummy operations)
        let _ = field_a + 1;
        let _ = (field_b as u64) + 2;
        if (field_c) {
            let _ = true;
        } else {
            let _ = false;
        }
    }

    //# run 0xCAFE::TestModule::test_feature
    public fun test_feature() {
        let specs = vector::empty<vector<u8>>();
        // Add some specs
        vector::push_back(&mut specs, b"spec1");
        vector::push_back(&mut specs, b"spec2");
        
        let holder = new_specs_holder(specs);
        
        // Add another spec
        add_spec(&mut holder, b"spec3");
        
        // Create data struct and unpack
        let data = Data {
            field_a: 42,
            field_b: 255,
            field_c: true,
        };
        unpack_and_process(data);
    }
}

// Features:
// 3ad547c96786a64cd192079cf221dcfc: Add function members within a schema target of a module for organized code structure.
// 3799c6bfdbc4b15df5c296f602bbe4e3: Convert a vector of specification blocks into a vector of processed specification blocks with a custom translation function.
// 881030f8f9f3c9578f56f854e2315e0d: Unpack multiple fields from a composite data structure and process each field separately.