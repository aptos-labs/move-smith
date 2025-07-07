//# publish
address 0x1 {
    module LintModule {
        use std::debug;
        use std::signer;

        #[skip(val_unnecessary_cast, val_redundant_return)]
        struct R has key {
            val: u64,
        }

        public fun new_r(v: u64): R {
            R { val: v }
        }

        public fun do(r: &mut R, v: u64) {
            if (v % 2 == 0) {
                r.val = v + 10;
            } else {
                r.val = v * 3;
            }
        }

        // Runner function that creates an R and calls do with different values
        public fun runner(s: &signer) {
            let mut r = new_r(1);
            do(&mut r, 2);
            do(&mut r, 3);
            debug::print(&r.val);
        }
    }
}
//# run 0x1::LintModule::runner --signers 0x1

//# publish
address 0x1 {
    module InterfaceModule {
        use std::vector;

        #[skip(mod_unnecessary_public_without_docs)]
        public struct MyResource has key, store {
            value: u64
        }

        public fun public_function(v: u64): u64 {
            v * 2
        }

        public fun another_public_function(): u64 {
            42
        }

        /// Generates the interface text representing the public API of this module.
        public fun generate_interface(): vector<u8> {
            // Hard-coded string for simplicity - normally the interface generator is external.
            let api_txt = b"module 0x1::InterfaceModule {\n\
                            public struct MyResource has key, store;\n\
                            public fun public_function(u64): u64;\n\
                            public fun another_public_function(): u64;\n\
                            }\n";
            vector::from_bytes(api_txt)
        }
    }
}
//# run 0x1::InterfaceModule::generate_interface --signers 0x1

//# run
script {
    use 0x1::LintModule;
    use 0x1::signer;
    use 0x1::InterfaceModule;

    fun main(account: &signer) {
        // Test constructing R and using do()
        let mut r = LintModule::new_r(5);
        LintModule::do(&mut r, 4);
        LintModule::do(&mut r, 7);

        // Print to exercise debug
        // (print is not strictly checked/asserted)
        0x1::debug::print(&r.val);

        // Test interface generation
        let interface_text = InterfaceModule::generate_interface();
        0x1::debug::print(&interface_text);

        // Call the runner function in LintModule to test signers and modification
        LintModule::runner(account);
    }
}