//# publish
address 0x1 {
    module TestParameters {
        use std::signer;
        use std::debug;

        #[test(addr = 0x100, signer = addr)]
        public fun test_with_params(s: &signer) {
            // Log provided signer and address parameters
            debug::print(&debug::string("Running test_with_params with signer: "));
            debug::print(&debug::address_to_string(&signer::address_of(s)));
            debug::print(&debug::string(", and addr = 0x100"));
        }

        // runner function for the test
        public fun runner() {
            // Just a no-arg runner to execute the test
            let fake_signer = signer::new(signer::address_of(&signer::spec_signer()));
            test_with_params(&fake_signer);
        }
    }
}
//# run 0x1::TestParameters::runner --signers 0x1

//# publish
address 0x2 {
    module FriendModuleA {
        friend 0x2::FriendModuleB;

        struct Data has store {
            value: u64,
        }

        public fun create_data(value: u64): Data {
            Data { value }
        }

        // This is a private function normally, friend module B can call it
        fun private_increment(d: &mut Data) {
            d.value = d.value + 1;
        }
    }

    module FriendModuleB {
        use 0x2::FriendModuleA;

        public fun increment_data(data: &mut FriendModuleA::Data) {
            FriendModuleA::private_increment(data);
        }

        public fun runner() {
            let mut d = FriendModuleA::create_data(10);
            increment_data(&mut d);
            // no assertions required, just exercising friend calls
        }
    }
}
//# run 0x2::FriendModuleB::runner

//# publish
address 0x3 {
    module DebugLogging {
        use std::debug;

        #[test]
        public fun test_logging() {
            if (debug::is_debug()) {
                // simulate extracting bytecode dump name from a source filename "debug_logging.move"
                let bname = debug::string("debug_logging.mvbd"); // .mvbd = Move Bytecode Dump
                debug::print(&debug::string("Bytecode Dump Name: "));
                debug::print(&bname);
            }
        }

        public fun runner() {
            test_logging();
        }
    }
}
//# run 0x3::DebugLogging::runner

//# publish
address 0x4 {
    module SpecInvariants {
        use std::option;

        struct Counter has key {
            count: u64,
        }

        spec module {
            invariant exists<Counter>(@0x4);
            invariant forall c: &Counter :: c.count >= 0;
        }

        public fun init(): Counter {
            Counter { count: 0 }
        }

        public fun increment(c: &mut Counter) {
            c.count = c.count + 1;
        }

        // runner to exercise spec and increment
        public fun runner() {
            let mut c = init();
            increment(&mut c);
        }
    }
}
//# run 0x4::SpecInvariants::runner

//# publish
address 0x5 {
    module FileDependencies {
        // Simulate a function that errors if intersection of targets and dependencies is detected

        public fun check_and_report(targets: vector<string::String>, dependencies: vector<string::String>) acquires Dummy {
            use std::string;
            use std::vector;
            // We'll just simulate intersection by iterating the vectors
            let mut intersect: vector<string::String> = vector::empty();

            let len_targets = vector::length(&targets);
            let len_deps = vector::length(&dependencies);

            let mut i = 0;
            while (i < len_targets) {
                let t = vector::borrow(&targets, i);
                let mut j = 0;
                while (j < len_deps) {
                    let d = vector::borrow(&dependencies, j);
                    if (string::eq(t, d)) {
                        vector::push_back(&mut intersect, string::copy(t));
                    }
                    j = j + 1;
                }
                i = i + 1;
            }

            if (vector::length(&intersect) > 0) {
                debug::print(&string::utf8(b"Error: Files are both targets and dependencies:"));
                let mut k = 0;
                let len_intersect = vector::length(&intersect);
                while (k < len_intersect) {
                    debug::print(vector::borrow(&intersect, k));
                    k = k + 1;
                }
                abort 100; // simulate error abort
            }
        }

        // dummy struct to acquire if needed in future
        struct Dummy has store {}

        public fun runner() {
            let targets = vector::empty<string::String>();
            let deps = vector::empty<string::String>();
            check_and_report(targets, deps);

            let targets2 = vector::singleton(string::utf8(b"file1.move"));
            let deps2 = vector::singleton(string::utf8(b"file1.move"));
            // This run will abort at runtime with error print if the VM runs abort fully.
            // For testing compilation and reporting.
            check_and_report(targets2, deps2);
        }
    }
}
//# run 0x5::FileDependencies::runner