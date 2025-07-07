// 1. Configure external lint checks for modules and functions
//# publish
address 0x1 {
    // move-lint: deny(unused_struct)
    /// This module will fail linting if there are unused structs.
    module LintExample {
        // move-lint: allow(non_camel_case_types)
        /// This struct will not trigger a lint warning for non-camel-case name.
        struct my_struct has copy, drop {
            x: u64,
            y: Nested,
        }

        /// Nested struct to test dotted expressions.
        struct Nested has copy, drop {
            value: u64,
        }

        fn make_nested(v: u64): Nested {
            Nested { value: v }
        }

        // move-lint: deny(unused_function)
        /// This function must be used otherwise lint will complain.
        public entry fun runner(s: &signer) {
            let ms = my_struct { x: 100, y: Self::make_nested(200) };
            let _val = ms.y.value; // Dotted expression for nested field access
        }
    }
}

//# run 0x1::LintExample::runner --signers 0x1

// 2. Use dotted expressions in a script
//# run
script {
    use 0x1::LintExample::{my_struct, Nested};

    fun main(account: &signer) {
        let ms = my_struct { x: 42, y: Nested { value: 1000 } };
        let field1 = ms.x;
        let nested = ms.y;
        let field2 = nested.value;
        let field3 = ms.y.value; // Dotted nested access
    }
}

// 3. Filter modules, scripts, or addresses based on specific criteria during compilation
// (This is a directive to the test framework, not valid Move code, but for test demonstration, we use addresses & names to see filtering.)
//# publish
address 0xABCD {
    module FilteredModule {
        // Dummy content; may be filtered out by test runner based on address (e.g. not 0x1) or module name.
        fun hello() {}
    }
}

//# publish
address 0x1 {
    module ShouldBePresent {
        fun greet() {}
    }
}

//# run 0x1::ShouldBePresent::greet --signers 0x1

// Only modules published under 0x1 should be included if filtering by address=0x1.
// Only scripts named `main` execute if filtering by script name equals "main".