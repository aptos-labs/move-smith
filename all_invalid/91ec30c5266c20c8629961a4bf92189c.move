//# publish
address 0xCAFE {
    module Diagnostics {
        use std::debug;

        const ENV_VAR: vector<u8> = b"DISPLAY_COLOR";

        /// This function tries to read an environment variable and returns
        /// true if it is set to "NONE" (case sensitive).
        public fun is_color_enabled(): bool {
            // Dummy simulation: We suppose env var "DISPLAY_COLOR" can be read.
            // Since Move can't read env vars, simulate with a constant.
            // Return false if ENV_VAR is equal to b"NONE"
            let none_val = b"NONE";
            let mut i = 0;
            while (i < Vector::length(&ENV_VAR) && i < Vector::length(&none_val)) {
                if (Vector::borrow(&ENV_VAR, i) != Vector::borrow(&none_val, i)) {
                    return true;
                }
                i = i + 1;
            };
            // if lengths differ, color enabled
            if (Vector::length(&ENV_VAR) != Vector::length(&none_val)) {
                return true;
            }
            false
        }

        /// Dummy function to print a diagnostic message with or without color codes.
        public fun print_diagnostic() {
            if (Self::is_color_enabled()) {
                debug::print("[\u{1b}[31mERROR\u{1b}[0m] Diagnostic message with color\n");
            } else {
                debug::print("[ERROR] Diagnostic message without color\n");
            }
        }

        /// Runner function to test above
        public fun runner() {
            Self::print_diagnostic();
        }
    }
}

//# run 0xCAFE::Diagnostics::runner

//# publish
address 0xCAFE {
    module ConstantsRange {
        /// Some consts in u64 range
        const MAX_U64: u64 = 18446744073709551615;
        const MID_U64: u64 = 1234567890123456789;
        const ZERO: u64 = 0;

        /// Runner function to test that constants are accessible (no overflow)
        public fun runner() {
            let _ = Self::MAX_U64;
            let _ = Self::MID_U64;
            let _ = Self::ZERO;
        }
    }
}

//# run 0xCAFE::ConstantsRange::runner

//# publish
address 0xCAFE {
    module AnnotatedSpecModule {
        spec module {
            /// Specification annotation example
            invariant true;
        }

        /// Use annotation example
        spec fun dummy_spec() {
            // use of spec function
        }

        /// Regular function
        public fun runner() {
            // nothing to run here, just tag with spec annotations.
        }
    }
}

//# run 0xCAFE::AnnotatedSpecModule::runner

// Featurres:
// 064d9fdd5f44111051f10668210602d5: Display diagnostics with color-only if environment variable is set to 'NONE'.
// 36f33fe235cdad4c61527b4091b05f11: Ensure constant values are within the u64 range.
// b2cc35d56ab7f2b6f53c0e9c0ea3e065: Include only modules with specification annotations such as 'Spec' or 'Use' in the source code.
