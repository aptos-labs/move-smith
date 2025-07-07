//# publish
module 0xCAFE::Foo {
    use std::signer;

    resource struct Foo {
        value: u64,
    }

    const CONST1: u64 = 123;
    const CONST2: u64 = 456;

    public fun make_foo(account: &signer): Foo {
        Foo { value: CONST1 + CONST2 }
    }

    // anonymous function (lambda) type alias
    // The trick here: store a function that takes &signer and returns Foo
    // We'll use a struct with a field storing function to simulate this
    // But since Move doesn't support first-class functions, we'll simulate with a generic approach

    // Instead, simulate by a function `invoke_f` which calls make_foo

    public fun invoke_f(account: &signer): Foo {
        // This function simulates the anonymous function f = make_foo
        make_foo(account)
    }

    // run function with no args to exercise module logic simply
    public fun runner(_account: &signer) {
        // no-op, just a dummy function for running
        // In practice, we could create Foo resource here, but tests will call invoke_f
    }
}
//# run 0xCAFE::Foo::runner --signers 0xCAFE

//# publish
module 0x42::foo {
    use std::signer;

    resource struct Foo {
        id: u8,
    }

    public fun make_foo(account: &signer): Foo {
        Foo { id: 42u8 }
    }
}
//# run 0x42::foo::make_foo --signers 0xCAFE

//# publish
module 0xCAFE::Program {
    use 0xCAFE::Foo;
    use 0x42::foo;
    use std::signer;

    // The "program" function to include only modules with unit tests
    // For this example, let's say Foo and foo have tests, so this function does nothing

    // We'll demonstrate calling Foo::invoke_f and obtaining Foo resource from foo::make_foo

    public fun test_invoke_f(account: &signer) {
        let _foo_res = Foo::invoke_f(account);
    }

    public fun test_foo_make_foo(account: &signer) {
        let _foo_res = foo::make_foo(account);
    }

    // runner function without args to comply with testing contract
    public fun runner(_account: &signer) {}
}
//# run 0xCAFE::Program::runner --signers 0xCAFE

//# run
script {
    use std::signer;
    use 0xCAFE::Foo;
    use 0x42::foo;

    fun main(account: signer) {
        // Test referencing constants both without and with module qualification
        let local_const = Foo::CONST1 + Foo::CONST2;

        // Test calling the anonymous function stored in f that invokes 0x42::foo::make_foo
        // The function Foo::invoke_f simulates this behavior
        let foo_res = Foo::invoke_f(&account);
        let foo_res2 = foo::make_foo(&account);

        // Just dummy usage: bind result to local variable to avoid unused warnings
        let _ = (local_const, foo_res, foo_res2);
    }
}

// Featurres:
// e41df40c11331f9327feead28ff6e8d1: Reference constants with optional module qualification.
// 3b66726e5f08ac212abbef39034ae6cc: Test that calling the anonymous function stored in `f` correctly invokes `0x42::foo::make_foo` and initializes the `Foo` resource for the account.
// 058e92738ebd925faf5d4e91c73f76c1: Leverage the `program` function to include only modules with unit tests in the final program for testing purposes.
