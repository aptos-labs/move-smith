//# publish
address 0xABCD {
    module ExperimentOverrides {
        use std::signer;
        use std::vector;

        #[skip(no_unsed_function)]
        spec module {
            // Spec example: number of entries processed must be non-zero (dummy example)
            // This declaration exercises spec parsing
            spec fun entries_processed_nonzero(): bool {
                true
            }
        }

        // Private function, unused, should be detected as unused
        fun unused_private_function(): u64 {
            42
        }

        // Public function, unused externally, but accessible inside module
        public fun unused_public_function(): u64 {
            123
        }

        // Internal function to be called only from within inline function
        fun helper_internal_function(): u64 {
            999
        }

        // Inline function calls only accessible functions
        inline fun inline_runner(): u64 {
            // Call accessible function helper_internal_function (same module private)
            helper_internal_function()
        }

        // Runner function without args for test
        public fun runner(): u64 {
            // Call inline function which calls internal function
            inline_runner()
        }
    }
}
//# run 0xABCD::ExperimentOverrides::runner

//# publish
address 0xEF01 {
    module ProgramParser {
        use std::signer;
        use std::string;

        #[skip(no_runtime_lint)]

        /// Parse a target file contents simulated as byte vector, return length.
        /// Simulates parsing target and dependency files with address mappings.
        public fun parse_target_file(file_content: vector<u8>): u64 acquires ProgramParser {
            vector::length(&file_content) as u64
        }

        /// Parse a dependency file contents simulated as byte vector, return length.
        public fun parse_dependency_file(file_content: vector<u8>): u64 {
            vector::length(&file_content) as u64
        }

        /// Runner that simulates parsing multiple files with address mappings.
        public fun runner(): u64 {
            let target = b"module 0xABCD::M {}";
            let dep = b"module 0x1234::DepModule {}";
            let tl = parse_target_file(vector::from_bytes(target));
            let dl = parse_dependency_file(vector::from_bytes(dep));
            tl + dl
        }       
    }
}
//# run 0xEF01::ProgramParser::runner

//# publish
address 0xFFEE {
    module OverrideSettings {
        use std::signer;

        /// Simulate settings with multiple entries for same key; later overrides earlier.
        struct Setting has key {
            value: u64,
        }

        public fun set_setting(account: &signer, initial: bool): u64 {
            // Imagine logic to set settings; for test just return dummy
            if (initial) {
                10
            } else {
                20
            }
        }

        public fun runner(): u64 {
            // Return value from second override (simulated)
            set_setting(&signer::address_of(&signer::borrow_signer(&0xFFEE)), false)
        }
    }
}
//# run 0xFFEE::OverrideSettings::runner --signers 0xFFEE

//# run
script {
    use std::debug;
    use 0xEF01::ProgramParser;
    use 0xABCD::ExperimentOverrides;
    use 0xFFEE::OverrideSettings;
    use std::signer;

    fun main(account: signer) {
        let parser_len = ProgramParser::runner();
        debug::print(&vector::from_bytes(b"Parser len: "));
        debug::print(&std::string::utf8(parser_len));
        
        let exp_res = ExperimentOverrides::runner();
        debug::print(&vector::from_bytes(b"Experiment runner: "));
        debug::print(&std::string::utf8(exp_res));

        let override_val = OverrideSettings::runner();
        debug::print(&vector::from_bytes(b"Override value: "));
        debug::print(&std::string::utf8(override_val));
    }
}