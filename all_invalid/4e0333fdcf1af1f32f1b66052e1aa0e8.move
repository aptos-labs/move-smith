//# publish
address 0x42 {
    module foo {
        struct Foo has store, key {
            value: u64
        }

        public fun make_foo(_account: &signer): Foo {
            Foo { value: 123 }
        }

        public fun init_foo(account: &signer) {
            let foo = make_foo(account);
            move_to(account, foo);
        }

        public fun runner(account: &signer) {
            init_foo(account);
        }
    }
}

//# publish
address 0xCAFE {
    module Tester {
        use std::signer;
        use 0x42::foo;

        /// Run function calls `init_foo` and also calls the function stored in `f`
        public fun run(account: &signer) {
            // Call init_foo directly
            foo::init_foo(account);

            // Define a named function assigned to `f` instead of anonymous function
            let f = run_inner;
            f(account);
        }

        // Named function since Move does not support anonymous functions
        public fun run_inner(s: &signer) {
            let foo_instance = foo::make_foo(s);
            move_to(s, foo_instance);
        }

        public fun runner(account: &signer) {
            run(account);
        }
    }
}
//# run 0xCAFE::Tester::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::Tester;

    fun main(account: signer) {
        Tester::run(&account);
    }
}