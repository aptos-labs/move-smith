//# publish
address 0x1 {
    module TestModule {
        use std::signer;
        use std::debug;
        use std::abort;

        #[skip(empty_block, unused_variable)]
        resource struct R has key {
            value: u64,
        }

        public fun create_r(account: &signer, init_val: u64) {
            move_to(account, R { value: init_val });
        }

        public fun read_r(r: &R): u64 {
            r.value
        }

        public fun modify_r(r: &mut R, new_val: u64) {
            r.value = new_val;
        }

        public fun do(r: &mut R, v: bool) {
            if (v) {
                // Should modify value
                modify_r(r, 42);
            } else {
                // Should not modify value
            }
        }

        public fun abort_if(v: bool, code: u64) {
            if (v) {
                abort(code);
            }
            // Code after abort should not run if aborted.
            debug::print(&vector::utf8(b"After abort_if\n"));
        }

        public fun runner(account: &signer) {
            if (!exists<R>(signer::address_of(account))) {
                create_r(account, 0);
            }
            let r_ref = borrow_global_mut<R>(signer::address_of(account));
            do(r_ref, true);
            do(r_ref, false);
        }
    }
}
//# run 0x1::TestModule::runner --signers 0x1

//# run 0x1::TestModule::abort_if --args true 100u64
//# run 0x1::TestModule::abort_if --args false 200u64

//# publish
address 0x1 {
    module ParseAndSave {
        use std::string;
        use std::debug;

        /// Parses a dummy target Move module and a dependency, simulating address mapping.
        /// This is a stub illustrating the idea, not real parsing.
        public fun parse_target_and_deps(): bool {
            // Pretend we parsed a module and dependency with address mappings
            debug::print(&vector::utf8(b"Parsed target and dependency files with address mappings.\n"));
            true
        }

        /// Simulate saving compiled modules and scripts to disk with proper names
        public fun save_compiled(name: &string::String, content: &string::String) {
            // Just print to debug to simulate saving
            debug::print(&vector::utf8(b"Saving compiled file: "));
            debug::print(&string::concat(name, string::utf8(" (content length: ")));
            debug::print(&string::concat(&string::u64_to_string(u64::from_u8(string::length(content) as u8)), string::utf8(")\n")));
        }

        public fun runner() {
            let target_parsed = parse_target_and_deps();
            assert!(target_parsed, 1);
            save_compiled(&string::utf8("TestModule.mv"), &string::utf8("module bytecode"));
            save_compiled(&string::utf8("TestScript.move"), &string::utf8("script bytecode"));
        }
    }
}
//# run 0x1::ParseAndSave::runner

//# run
script {
    use std::signer;
    use 0x1::TestModule;

    fun main(account: signer) {
        // Create resource and test do() function
        TestModule::create_r(&account, 5);
        let r_ref = borrow_global_mut<0x1::TestModule::R>(signer::address_of(&account));

        TestModule::do(r_ref, true); // should modify
        TestModule::do(r_ref, false); // should not modify

        // Test abort_if with false condition (no abort)
        TestModule::abort_if(false, 123);

        // The below will abort, so code below will never run
        // TestModule::abort_if(true, 999);

        // Print final value after modification
        let final_val = TestModule::read_r(r_ref);
        std::debug::print(&vector::utf8(b"Final R.value: "));
        std::debug::print(&std::string::u64_to_string(final_val));
        std::debug::print(&vector::utf8(b"\n"));
    }
}