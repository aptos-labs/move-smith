//# publish
address 0x42 {
    module foo {
        use std::signer;

        struct Foo has store, key {
            value: u64
        }

        public fun make_foo(account: &signer): Foo {
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
        use std::vector;

        /// Run function calls `init_foo` and also calls the anonymous function stored in `f`
        public fun run(account: &signer) {
            // Call init_foo directly
            foo::init_foo(account);

            // Define an anonymous function assigned to `f`
            let f = fun(s: &signer) {
                // call make_foo and move to storage
                let foo_instance = foo::make_foo(s);
                move_to(s, foo_instance);
            };

            f(account);
        }

        public fun runner(account: &signer) {
            run(account);
        }
    }
}
//# run 0xCAFE::Tester::runner --signers 0xCAFE

//# run
script {
    use std::signer;
    use 0xCAFE::Tester;

    fun main(account: signer) {
        // Call run function within Tester module to exercise all test parts
        Tester::run(&account);
    }
}

// Featurres:
// e411bebffcfa12ee60924cca645c4435: Write transaction scripts for execution on-chain
// 2efdd5eadd46989b80dc7348772f0d7c: Call functions or methods with runtime arguments using parentheses, such as `my_fn(args)`.
// 3b66726e5f08ac212abbef39034ae6cc: Test that calling the anonymous function stored in `f` correctly invokes `0x42::foo::make_foo` and initializes the `Foo` resource for the account.
