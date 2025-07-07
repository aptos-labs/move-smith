
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
    // define Foo struct within this module
    struct Foo has store, key {
        value: u64,
    }

    // Function that creates and returns a Foo resource
    public fun make_foo(): Foo {
        Foo { value: 42 }
    }
}



//# run 0x42::foo::make_foo --signers 0xDEADBEEF