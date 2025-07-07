//# publish
address 0x1 {
    module Utils {
        use std::string;

        /// Dummy dummy function to be used in tests to simulate parsing targets and dependencies.
        public fun parse_targets_and_deps(): bool {
            // Simulation: pretend we parse files with addresses.
            // Just return true to indicate success.
            true
        }

        /// Helper generic function with ability constraint 'copy' that returns the input.
        public fun identity<T: copy>(x: T): T {
            x
        }
    }
}

//# publish
address 0x2 {
    module ResourceModule {
        use std::signer;
        use std::string;

        /// Define a resource R containing a u64 value
        resource struct R {
            value: u64,
        }

        /// Instantiate R with the given value under the signer
        public fun publish_r(account: &signer, v: u64) {
            move_to(account, R { value: v });
        }

        /// Modifier function: if v is even, increments R.value by v, else decrements by v.
        /// This shows that do() modifies or interacts with R based on v.
        public fun do(account: &signer, v: u64) {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (v % 2 == 0) {
                r.value = r.value + v;
            } else {
                r.value = r.value - v;
            };
        }

        /// Runner function that does a sample do() modification on R with value 42.
        public fun run_do(account: &signer) {
            do(account, 42);
        }
    }
}
//# run 0x2::ResourceModule::run_do --signers 0x2


//# publish
address 0x3 {
    module LintSkipAndExpr {
        use std::vector;

        /// Define dummy lint names as strings, just for simulation.
        /// Using #[skip(...)] attribute with a list of lint checks to skip.
        #[skip(unused_variable, non_snake_case, dead_code)]
        public fun skipped_lint_fn() {
            let unused_var = 123;
            let SomeVar = 456;
            let dead_fun = 789;
            // Nothing important here, purpose is skip lint checks
        }

        /// To test colon syntax in expressions to specify explicit fields,
        /// define a struct with fields, then assign specifying fields explicitly.
        struct S {
            a: u64,
            b: bool,
        }

        public fun explicit_field_assignment(): S {
            // Use colon syntax to explicitly mention fields in the struct literal.
            S { a: 10, b: true }
        }
    }
}

//# run 0x3::LintSkipAndExpr::skipped_lint_fn


//# publish
address 0x4 {
    module BindAndReverse {
        use std::vector;
        use std::string;

        // This function simulates processing a list of lvalues in reverse order.
        // For simplicity, lvalues here are strings representing variable names.
        // The function "binds" each unbound variable by appending "_bound" suffix.
        // We'll demonstrate iterating vector<string> in reverse order, modifying each.

        public fun process_lvalues(mut lvalues: vector<string::String>) {
            let len = vector::length(&lvalues);
            let i = len;
            let mut idx = i;
            while (idx > 0) {
                idx = idx - 1;
                let lv = vector::borrow(&lvalues, idx);
                // Simulate binding: just print or mutate lvalues[idx] here
                // Move does not have print; so we simulate by re-assigning the string with "_bound"
                let mut new_name = string::new();
                string::append(&mut new_name, lv);
                string::append(&mut new_name, "_bound");
                // Unsafe reassignment to vector item for simulation (normally vectors are mutable here)
                // Since vector is mutable argument, we can use vector::borrow_mut
                vector::borrow_mut(&mut lvalues, idx).copy_from(&new_name);
            }
            // No return, just simulates binding done in reverse order
        }

        /// Runner function to exercise process_lvalues
        public fun runner() {
            let mut names = vector::empty<string::String>();
            vector::push_back(&mut names, string::utf8("x"));
            vector::push_back(&mut names, string::utf8("y"));
            vector::push_back(&mut names, string::utf8("z"));

            process_lvalues(names);
        }
    }
}
//# run 0x4::BindAndReverse::runner


//# publish
address 0x5 {
    module GenericAbilities {

        /// Define a generic struct Container holding a value of type T with key ability
        struct Container<T: key> has key {
            val: T,
        }

        /// Generic function with ability constraints: T must have store and copy
        public fun new_container<T: store + copy>(val: T): Container<T> {
            Container { val }
        }

        /// Runner function to create a container with u64 (has store + copy)
        public fun run_new_container_u64() {
            let c = new_container(123u64);
            let _v = c.val; // use to avoid unused variable
        }
    }
}
//# run 0x5::GenericAbilities::run_new_container_u64


//# run
script {
    use 0x1::Utils;
    use 0x2::ResourceModule;
    use 0x3::LintSkipAndExpr;
    use 0x4::BindAndReverse;
    use 0x5::GenericAbilities;
    use std::signer;

    fun main(account: &signer) {
        // 1: test parsing targets and dependencies
        let _parsed = Utils::parse_targets_and_deps();

        // 2: publish resource R and run do()
        ResourceModule::publish_r(account, 100);
        ResourceModule::do(account, 7);
        ResourceModule::do(account, 8);

        // 3: call lint skip function
        LintSkipAndExpr::skipped_lint_fn();
        let _s = LintSkipAndExpr::explicit_field_assignment();

        // 4: run process_lvalues in BindAndReverse
        BindAndReverse::runner();

        // 5: generic function with ability constraints
        GenericAbilities::run_new_container_u64();
    }
}