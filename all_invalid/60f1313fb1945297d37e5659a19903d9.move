
//# publish
module 0xCAFE::LambdaAndCompute {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 after computing sum
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaAndCompute;

    public fun double_inline_call(a: u8, b: u8): u8 {
        let partial = LambdaAndCompute::inline_add(a, b);
        LambdaAndCompute::inline_add(partial, 10u8)
    }

    public fun use_external_lambda(a: u8, b: u8): u8 {
        LambdaAndCompute::use_lambda(a, b)
    }
}


//# publish
module 0xCAFE::ResourceAccessControl {
    use std::signer;

    struct SecretResource has key, store {
        value: u64,
    }

    public fun create_secret_resource(s: signer, val: u64) {
        let addr = signer::address_of(&s);
        let resource = SecretResource { value: val };
        move_to<SecretResource>(&s, resource);
    }

    public fun read_secret_resource(addr: address): u64 acquires SecretResource {
        let res_ref = borrow_global<SecretResource>(addr);
        res_ref.value
    }

    public fun update_secret_resource(s: signer, new_val: u64) acquires SecretResource {
        let addr = signer::address_of(&s);
        let res_mut_ref = borrow_global_mut<SecretResource>(addr);
        res_mut_ref.value = new_val;
    }

    public fun remove_secret_resource(addr: address) acquires SecretResource {
        let resource = move_from<SecretResource>(addr);
        let SecretResource { value: _ } = resource;
    }
}


//# run 0xCAFE::LambdaAndCompute::add_then_return_fixed --args 10u8 15u8


//# run 0xCAFE::LambdaAndCompute::use_lambda --args 5u8 7u8


//# run 0xCAFE::LambdaAndCompute::inline_add --args 3u8 4u8


//# run 0xCAFE::NestedCalls::double_inline_call --args 2u8 3u8


//# run 0xCAFE::NestedCalls::use_external_lambda --args 8u8 9u8


//# run 0xCAFE::ResourceAccessControl::create_secret_resource --signers 0xABCD --args 123456u64


//# run 0xCAFE::ResourceAccessControl::read_secret_resource --args 0xABCD


//# run 0xCAFE::ResourceAccessControl::update_secret_resource --signers 0xABCD --args 654321u64


//# run 0xCAFE::ResourceAccessControl::read_secret_resource --args 0xABCD


//# run 0xCAFE::ResourceAccessControl::remove_secret_resource --args 0xABCD


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7194eb47892e13690c0ddfa779aa8f6c: Use access specifiers with detailed module address, name, resource name, and type arguments to control resource access in Move modules.
