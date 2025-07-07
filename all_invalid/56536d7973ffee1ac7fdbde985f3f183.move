//# publish
address 0xA550C18 {
    module ProgramManager {
        use std::signer;

        // Resource to track registered programs by address
        struct RegisteredPrograms has store {
            // Mapping from address to boolean registration flag
            // For simplicity here, just track if registered or not.
            registered: vector<address>,
        }

        // Initialize the resource under the account if not exists
        public fun init(account: &signer) {
            if (!exists<RegisteredPrograms>(signer::address_of(account))) {
                move_to(account, RegisteredPrograms { registered: vector::empty<address>() });
            }
        }

        // Register a program given an address
        public fun register(account: &signer, addr: address) {
            let addr_self = signer::address_of(account);
            let reg = borrow_global_mut<RegisteredPrograms>(addr_self);
            vector::push_back(&mut reg.registered, addr);
        }

        // Check if address is registered
        public fun is_registered(addr_owner: address, addr_check: address): bool acquires RegisteredPrograms {
            if (!exists<RegisteredPrograms>(addr_owner)) {
                return false;
            }
            let reg = borrow_global<RegisteredPrograms>(addr_owner);
            vector::contains(&reg.registered, &addr_check)
        }

        /// A runner function that executes registration of a new program (simulate parsing and registering)
        public fun do() acquires RegisteredPrograms {
            // For test: add 0x1 and 0x2 to registered programs under 0xA550C18
            let addr_self = @0xA550C18;
            assert!(exists<RegisteredPrograms>(addr_self), 1);
            let reg = borrow_global_mut<RegisteredPrograms>(addr_self);
            // Guard no duplicates
            if (!vector::contains(&reg.registered, &@0x1)) {
                vector::push_back(&mut reg.registered, @0x1);
            }
            if (!vector::contains(&reg.registered, &@0x2)) {
                vector::push_back(&mut reg.registered, @0x2);
            }
        }
    }
}
//# run 0xA550C18::ProgramManager::do

//# publish
address 0x1 {
    module RModule {
        // Define resource R storing an integer
        struct R has key {
            v: u64,
        }

        // Initialize R resource at signer address
        public fun init(account: &signer) {
            move_to(account, R { v: 0 });
        }

        /// Modify resource R's v field by adding delta
        public fun modify(account: &signer, delta: u64) acquires R {
            let r = borrow_global_mut<R>(signer::address_of(account));
            r.v = r.v + delta;
        }

        /// Use #[skip(...)] attribute with lint skip example (simulated)
        #[skip(lint1, lint2)]
        public fun dummy_skip_lint() {
            // Dummy function to test skip attribute
        }

        // Runner function without args, modifies R by +42
        public fun do(account: &signer) acquires R {
            modify(account, 42);
        }
    }
}
//# run 0x1::RModule::do --signers 0x1

//# publish
address 0x2 {
    module AbilityChecker {
        // Resource to test ability constraints
        struct Container<T has store> has key {
            val: T,
        }

        // Function requiring T to have copy ability
        public fun requires_copy<T has copy>(account: &signer, val: T) acquires Container<T> {
            move_to(account, Container<T> { val });
        }

        // Function requiring T to have store ability
        public fun requires_store<T has store>(account: &signer, val: T) acquires Container<T> {
            move_to(account, Container<T> { val });
        }

        // Runner function testing requires_copy with u8 and requires_store with vector<u8>
        public fun do(account: &signer) acquires Container<u8>, Container<vector<u8>> {
            requires_copy(account, 7u8);
            requires_store(account, vector::empty<u8>());
        }
    }
}
//# run 0x2::AbilityChecker::do --signers 0x2

//# publish
address 0x3 {
    module OptionalDeclare {
        use std::vector;
        use std::debug;

        // Function demonstrating Declare with optional type annotations
        public fun declare_vars() {
            // Use Declare without explicit type; compiler infers u64
            Declare x = 100u64;
            // Explicit type annotation u8
            Declare y: u8 = 200u8;
            // Declare with vector of u64 inferred
            Declare z = vector::empty<u64>();

            // Use y to silence unused warnings
            debug::print(&vector::empty<u8>());
        }

        // Runner function calling declare_vars()
        public fun do() {
            declare_vars();
        }
    }
}
//# run 0x3::OptionalDeclare::do

//# run
script {
    use std::debug;
    use 0x1::RModule;
    use 0xA550C18::ProgramManager;
    use 0x2::AbilityChecker;
    use 0x3::OptionalDeclare;

    fun main() {
        // Initialize R resource for 0x1
        RModule::init(&signer::borrow_address_ref(&signer::new_signer(0x1)));

        // Run ProgramManager::init and do
        ProgramManager::init(&signer::borrow_address_ref(&signer::new_signer(0xA550C18)));
        ProgramManager::do();

        // Run RModule::do modifies resource R at 0x1
        // Already done above in run commands, here just simulate call
        // Run AbilityChecker::do with 0x2 signer
        AbilityChecker::do(&signer::borrow_address_ref(&signer::new_signer(0x2)));

        // Run OptionalDeclare::do
        OptionalDeclare::do();

        debug::print(&vector::empty<u8>());
    }
}