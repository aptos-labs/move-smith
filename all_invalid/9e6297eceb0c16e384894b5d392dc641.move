
//# publish
module 0xCAFEBABE::TestModule {
    use std::signer;
    use 0x42::foo;

    // Resource definition for testing
    struct Foo has store, key {
        value: u64,
    }

    // Function that creates a Foo resource for the signer
    public fun create_foo(account: &signer) {
        let foo_resource = foo::make_foo();
        move_to(account, foo_resource);
    }

    // Function stored in f which calls create_foo via an anonymous function
    public fun run_closure(account: &signer) {
        let f = |s: &signer| Self::create_foo(s);
        // Call the anonymous function
        f(account);
    }

    // Runner to test the anonymous function invocation
    public fun run() {
        let sender = signer::borrow_signer(0xDEADBEEF);
        Self::run_closure(&sender);
    }
}


//# run 0xCAFEBABE::TestModule::run --signers 0xDEADBEEF


//# publish
module 0x42::foo {
    // Function that creates and returns a Foo resource
    public fun make_foo(): Foo {
        Foo { value: 42 }
    }
}


//# run 0x42::foo::make_foo --signers 0xDEADBEEF

// Featurres:
// 3b66726e5f08ac212abbef39034ae6cc: Test that calling the anonymous function stored in `f` correctly invokes `0x42::foo::make_foo` and initializes the `Foo` resource for the account.
// fb32f3b3b1dcf46b73265725e707d593: Specify the address for a Move module, which can be checked for redundancy and correctness.
// f1c921aca42f3b921cebd45f3d43cf5e: Use specific syntax to distinguish between various levels of name resolution in module, type, and variant access.
