//# publish
address 0x1 {
    module ProgramLoader {
        use std::vector;
        use std::string;

        // A struct to simulate program files with targets, dependencies, and address mappings
        struct Program has store {
            target: vector<u8>,
            dependencies: vector<vector<u8>>,
            address_map: vector<(vector<u8>, address)>,
        }

        public fun parse_program(target: vector<u8>, dependencies: vector<vector<u8>>, addrs: vector<(vector<u8>, address)>): Program {
            Program { target, dependencies, address_map: addrs }
        }

        // Dummy loader to simulate the loading process
        public fun load(_program: &Program) {
            // Do nothing - just simulate parsing and loading
        }

        // Runner function without arguments
        public fun runner() {
            let dummy_target = b"target.move";
            let dummy_deps = vector::empty<vector<u8>>();
            let dummy_addr_map = vector::empty<(vector<u8>, address)>();
            let program = parse_program(dummy_target, dummy_deps, dummy_addr_map);
            load(&program);
        }
    }
}
//# run 0x1::ProgramLoader::runner

//# publish
address 0x1 {
    // #[skip(lint1,lint2)] attribute example skipping some lint checks on a module
    #[skip(unused_variable,non_camel_case_types)]
    module ResourceInteraction {
        use std::signer;

        // Define resource R with an integer value
        struct R has key {
            v: u64,
        }

        // Publish R with initial value
        public fun publish_r(account: &signer, v: u64) {
            move_to(account, R { v });
        }

        // Function to get mutable reference to R
        public fun borrow_r(account: &signer): &mut R {
            borrow_global_mut<R>(signer::address_of(account))
        }

        // The do() function modifies or interacts with R based on the value of v
        public fun do(account: &signer) {
            let r_ref = borrow_r(account);
            if (r_ref.v == 0) {
                // If v == 0, increment by 10
                r_ref.v = r_ref.v + 10;
            } else {
                // Otherwise, decrement by 1
                r_ref.v = r_ref.v - 1;
            }
        }

        // Runner function: publish R with v=0, call do(), then call do() again
        public fun runner(account: &signer) {
            publish_r(account, 0);
            do(account);
            do(account);
        }
    }
}
//# run 0x1::ResourceInteraction::runner --signers 0x1

//# publish
address 0x1 {
    module AbilityDropCheck {
        use std::signer;

        // Define token as an identifier with content "DROP"
        // We test that the resource with Drop ability is recognized with token "DROP"
        #[drop] // The drop ability marker for R
        struct R has key, drop {
            v: u8,
        }

        public fun create(account: &signer, v: u8) {
            move_to(account, R { v });
        }

        // Just drop the resource explicitly by moving it out
        public fun drop_resource(account: &signer) {
            let r = move_from<R>(signer::address_of(account));
            // r is dropped here implicitly
        }

        // Runner function: create resource and drop it
        public fun runner(account: &signer) {
            create(account, 42);
            drop_resource(account);
        }
    }
}
//# run 0x1::AbilityDropCheck::runner --signers 0x1

//# publish
address 0x1 {
    module CallExpressions {
        use std::signer;

        // A simple function to add two u64 numbers
        public fun add(a: u64, b: u64): u64 {
            a + b
        }

        // A runner function demonstrating "Call" expression style function call
        public fun call_basic() {
            let x = add(4, 5);
            // no asserts needed
        }

        // A function that accepts a lambda (function pointer)
        public fun call_lambda(f: &fn(u64, u64): u64, a: u64, b: u64): u64 {
            (*f)(a, b)
        }

        // Runner function demonstrating "ExpCall" — calling a function pointer
        public fun call_exp() {
            let f: fn(u64,u64): u64 = add;
            let res = call_lambda(&f, 7, 8);
            // no asserts needed
        }

        // Runner function calling both
        public fun runner() {
            call_basic();
            call_exp();
        }
    }
}
//# run 0x1::CallExpressions::runner