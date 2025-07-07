address 0x1 {
    //# publish
    module TestFeatures {
        // A nested module to test referencing via access chains
        module InnerModule {
            public fun get_value(): u64 {
                42
            }
        }

        // Runner function to exercise module references, conditional logic, and iteration
        public fun run_all() {
            // 1. Declare an address block outside modules (done above)

            // 2. Reference modules via module access chains
            let value_ref = &Self::InnerModule::get_value();

            // 3. Implement conditional logic with IfElse expressions
            let output = if (*value_ref > 40) {
                "Greater than 40"
            } else {
                "Less or equal to 40"
            };

            // Print or use output (for test purposes, we just store it)
            // (In practice, test assertions could be added, but omitted as per instructions)
        }

        // Function to process a collection of lvalues
        public fun process_list(list: vector<u64>) {
            let index = 0;
            while (index < vector::length(&list)) {
                let item = *vector::borrow(&list, index);
                // Custom function to process each item
                Self::process_item(item);
                let index = index + 1;
            }
        }

        public fun process_item(item: u64) {
            // Dummy processing
            let _ = item + 1;
        }
    }

    //# run 0x1::TestFeatures::run_all
    //# run 0x1::TestFeatures::process_list --args vector[1u64, 2, 3]
}