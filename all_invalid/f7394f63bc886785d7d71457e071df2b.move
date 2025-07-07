//# publish
module 0xCAFE::Util {
    // A public function that can be shadowed by a function parameter
    public fun foo(x: u64): u64 {
        x + 10
    }

    // Expose a function pointer to foo for tests
    public fun foo_ref(): &fun(u64): u64 {
        &foo
    }
}

//# publish
module 0xCAFE::ShadowingTest {
    use 0xCAFE::Util;

    // Test shadowing: parameter "foo" shadows imported Util::foo
    public fun shadow_test(foo: fun(u64): u64, x: u64): u64 {
        foo(x) // Call the parameter, not Util::foo
    }

    // Test: pass a lambda that shadows Util::foo and call shadow_test
    public fun runner(): u64 {
        let lambda = fun(x: u64): u64 { x * 2 };
        shadow_test(lambda, 21) // Should return 42
    }
}
//# run 0xCAFE::ShadowingTest::runner

//# publish
module 0xCAFE::DeepPaths {
    struct MyResource has key, store {
        value: u64
    }

    // Create and store a resource in the address
    public fun create_resource(account: &signer, value: u64) {
        move_to(account, MyResource { value })
    }
    
    // Borrow the resource at the address via deep '::' path chains (with no wildcards in Move, but chains)
    public fun borrow_rc(addr: address): &u64 {
        // Emulate deep name path: 0xCAFE::DeepPaths::MyResource
        &borrow_global<MyResource>(addr).value
    }

    // Nested '::' access
    public fun nested_path_test(addr: address): u64 {
        let v = 0xCAFE::DeepPaths::borrow_rc(addr);
        *v
    }
    // for script
    public fun runner(account: &signer) {
        create_resource(account, 0x5Au64);
    }
}
//# run 0xCAFE::DeepPaths::runner --signers 0xC0FFEE
//# run 0xCAFE::DeepPaths::nested_path_test --signers 0xBEEF --args 0xC0FFEE

//# publish
module 0xCAFE::SignerTest {
    // Test: accept a signer, &signer and an address
    public fun signer_and_addr_test(s: &signer, addr: address): address {
        // Copy signer's address and sum bytes (as trivial logic test/return)
        let s_addr = signer::address_of(s);
        // Just return the addr passed in to exercise param usage. 
        addr
    }
    // Test runner for use in script
    public fun runner(s: &signer): address {
        signer_and_addr_test(s, signer::address_of(s))
    }
}
//# run 0xCAFE::SignerTest::runner --signers 0xDEAD
//# run 0xCAFE::SignerTest::signer_and_addr_test --signers 0xCAFE --args 0xC0FFEE

// Featurres:
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
// ab2e8f0a65a05231f9790decb75653c4: Create expressions that access named resources or modules through a chain of '::' separated identifiers, optionally including wildcards.
// 83c06cbebf5e16f55464d356698f5ce6: Use signer, &signer, or address types as parameters in test functions, with address or signer values assigned through test attributes.
