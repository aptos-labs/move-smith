//# publish
address 0xA550C18 {
    module TestModule {
        use std::signer;

        // A simple resource R to interact with
        resource struct R has store {
            value: u64,
        }

        // Initialize resource R under the signer if not exists
        public fun init(account: &signer) {
            if (!exists<R>(signer::address_of(account))) {
                move_to(account, R { value: 0 });
            }
        }

        // Modify resource depending on value v
        #[skip(lint_arithmetic, lint_unused)]
        public fun do(account: &signer, v: bool) {
            let addr = signer::address_of(account);
            assert!(exists<R>(addr), 1);
            let r_ref = borrow_global_mut<R>(addr);

            // If v is true, increment value by 1, else decrement by 1
            if (v) {
                r_ref.value = r_ref.value + 1;
            } else {
                r_ref.value = r_ref.value - 1;
            }
        }

        // Helper "runner" function to run do() twice: once true, once false
        public fun runner(account: &signer) {
            init(account);
            // run do(true)
            do(account, true);
            // run do(false)
            do(account, false);
        }

        // Illustrating bind_list by converting a list of pattern bindings to lvalues:
        // Here we simulate a context as an example. We just return the count of bindings.
        public fun bind_list_example() : u64 {
            // The following simulates bind_list usage in a dummy way:
            // This is just to syntactically show usage of bind_list in Move.
            // Normally bind_list is used internally in the Move compiler/toolchain.
            #[skip(lint_unnecessary_list)]
            let bindings = vector::empty<u8>();
            vector::push_back(&mut bindings, 0);
            vector::push_back(&mut bindings, 1);
            vector::push_back(&mut bindings, 2);
            // count bindings as a proxy for operation
            let count = vector::length(&bindings);
            count
        }
    }
}
//# run 0xA550C18::TestModule::runner --signers 0xA550C18
//# run 0xA550C18::TestModule::bind_list_example

//# run
script {
    use 0xA550C18::TestModule;
    use std::signer;

    fun main(account: signer) {
        // Initialize resource R under the signer
        TestModule::init(&account);

        // Call do(true)
        TestModule::do(&account, true);

        // Call do(false)
        TestModule::do(&account, false);

        // Run the runner to test do function twice more
        TestModule::runner(&account);

        // Call bind_list_example to test bind_list usage
        let _count = TestModule::bind_list_example();
    }
}