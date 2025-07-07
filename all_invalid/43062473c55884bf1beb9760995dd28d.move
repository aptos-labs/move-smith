address 0x1 {
    module TestModule {
        use std::debug;

        /// Struct with custom attributes:
        #[custom_attribute_1]
        #[custom_attribute_2(value = 42)]
        struct MyStruct has store {
            val: u64,
        }

        /// Internal (default) visibility function - valid in scripts
        fun internal_fn(): u64 {
            42
        }

        /// Public function - should trigger a diagnostic in script context
        public fun public_fn(): u64 {
            0
        }

        /// Script function (entry point) - must be internal visibility only
        script {
            fun main_script() {
                // Check diagnostic label including snippet
                debug::print(&b"Diagnostic: function 'public_fn' has invalid visibility 'public'."[..]);

                // Call the valid internal function
                let v = internal_fn();

                // Create instance of struct with custom attributes
                let s = MyStruct { val: v };
                debug::print(&b"Struct val: "[..]);
                debug::print_u64(s.val);
            }
        }
    }
}

// Featurres:
// a3ed19c19dd63b956349eaca76d07950: Include code snippets or identifiers in diagnostic messages as labels.
// d6b18feb62bf10640ad30fdeb701a653: Ensure that script functions do not use public, package, or friend visibility, as scripts must only contain internally visible functions.
// c387d85b261e63d8878df1ed45b08008: Add custom attributes to structs through the 'attributes' field in the struct definition.
