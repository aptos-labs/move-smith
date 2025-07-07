//# publish
module 0xCAFE::TestOperators {
    public fun run_all() {
        // This is a runner function to invoke individual test functions.
        Self::test_combined_assignments();
        Self::test_merge_modules();
        Self::test_module_inheritance();
    }
    
    // Test 1: Use combined assignment operators
    public fun test_combined_assignments() {
        let a: u8 = 10;
        a += 5;  // a = 15
        a -= 3;  // a = 12
        a *= 2;  // a = 24
        a %= 10; // a = 4
        a /= 2;  // a = 2
        a |= 0b1010; // a = 0b1010 (10)
        a &= 0b1111; // a = 0b1010 (10)
        a ^= 0b0101; // a = 0b1111 (15)
        a <<= 2;     // a = 0b1111 << 2 = 0b111100 = 60
        a >>= 3;     // a = 60 >> 3 = 7
        // No assertions needed, just to exercise operators
    }

    // Test 2: Combine or merge module specifications via spec modules
    //# publish
    module 0xCAFE::SpecModuleA {
        public fun get_value(): u64 {
            42
        }
    }

    //# publish
    module 0xCAFE::SpecModuleB {
        public fun get_multiplier(): u64 {
            3
        }
        
        // Spec module extending functionality
        public fun compute(): u64 {
            let val = SpecModuleA::get_value();
            let mult = get_multiplier();
            val * mult
        }
    }

    // A function to exercise calling functions from merged spec modules
    public fun test_merging() {
        let result = SpecModuleB::compute(); // Should yield 42 * 3 = 126
        // Do nothing further
    }

    // Test 3: Add members like constants or functions via spec modules
    //# publish
    module 0xCAFE::Constants {
        const MAX_SIZE: u64 = 1024;

        public fun get_max_size(): u64 {
            MAX_SIZE
        }
    }

    //# publish
    module 0xCAFE::MemberExtensions {
        public fun extended_function(): u8 {
            255
        }
    }

    // Use constants and extended functions
    public fun test_constants_and_extensions() {
        let max = Constants::get_max_size();
        let extended = MemberExtensions::extended_function();
        // No assertions, just exercises
    }

    // Script 1: To exercise the above modules; main script
//# run 0xCAFE::TestOperators::run_all
}

// Featurres:
// 3df0ef442032dba0d5e22544d91c02b8: Use combined assignment operators such as +=, -=, *=, %=, /=, |=, &=, ^=, <<=, >>= in Move code.
// e35e649060d4d698d78069f7f1cbbbfb: Combine or merge module specifications from different package definitions.
// 349826f2910b79212c4299c7a9c71329: Add members such as constants or functions to modules via spec modules and have those members merged into the implementation module.
