
//# publish
module 0xCAFE::AccessSpecifiers {
    // Test optional access specifiers for module and resources
    use std::signer;

    pub struct PublicResource has key, store {
        value: u64,
    }

    struct PrivateResource has key, store {
        value: u64,
    }

    pub(friend) struct FriendResource has key, store {
        value: u64,
    }

    public entry fun create_public_resource(account: signer, val: u64) {
        let res = PublicResource { value: val };
        move_to<PublicResource>(&account, res);
    }

    public entry fun create_private_resource(account: signer, val: u64) {
        let res = PrivateResource { value: val };
        move_to<PrivateResource>(&account, res);
    }

    public(friend) entry fun create_friend_resource(account: signer, val: u64) {
        let res = FriendResource { value: val };
        move_to<FriendResource>(&account, res);
    }

    public fun read_public_resource(account: signer): u64 {
        let r = borrow_global<PublicResource>(signer::address_of(&account));
        r.value
    }

    fun read_private_resource(account: signer): u64 {
        let r = borrow_global<PrivateResource>(signer::address_of(&account));
        r.value
    }

    pub(friend) fun read_friend_resource(account: signer): u64 {
        let r = borrow_global<FriendResource>(signer::address_of(&account));
        r.value
    }
}


//# publish
module 0xCAFE::LambdaPass {
    // Test passing lambda expressions (closures) as args to public entry functions,
    // including lambdas that call other lambdas

    use std::signer;

    public entry fun apply_lambda(
        s: signer,
        f: |u64|u64,
        input: u64
    ): u64 {
        f(input)
    }

    public entry fun nested_lambda(
        s: signer,
        f_outer: |(|u64|u64), u64| u64,
        f_inner: |u64| u64,
        input: u64
    ): u64 {
        f_outer(f_inner, input)
    }

    public fun simple_increment(x: u64): u64 {
        x + 1
    }

    public fun higher_order_example(): u64 {
        let inner_lambda: |u64|u64 has copy+drop = |x: u64| { x * 2 };
        let outer_lambda: |(|u64|u64), u64|u64 has copy+drop = |f: |u64|u64, y: u64| {
            let intermediate = f(y);
            intermediate + 10
        };
        outer_lambda(inner_lambda, 5u64)
    }
}


//# publish
module 0xCAFE::AliasingTest {
    // Test module access chains and aliasing

    use 0xCAFE::AccessSpecifiers as Access;
    use 0xCAFE::LambdaPass::{apply_lambda, nested_lambda, simple_increment, higher_order_example};

    public entry fun use_access_specifiers(account: signer, val: u64) {
        // call public entry to create resource via alias
        Access::create_public_resource(account, val);
    }

    public entry fun call_lambda_functions(
        account: signer,
        lambda: |u64|u64,
        nested_lambda_fn: |(|u64|u64), u64| u64,
        input: u64
    ): u64 {
        let r1 = apply_lambda(account, lambda, input);
        let r2 = nested_lambda(account, nested_lambda_fn, lambda, input);
        r1 + r2
    }

    public fun call_higher_order_example(): u64 {
        higher_order_example()
    }
}


//# run 0xCAFE::AccessSpecifiers::create_public_resource --signers 0xBEEF --args 42u64


//# run 0xCAFE::AccessSpecifiers::read_public_resource --signers 0xBEEF


//# run 0xCAFE::LambdaPass::apply_lambda --signers 0xBEEF --args 0x1u64
// We need to invoke apply_lambda with a lambda. Since lambda is a complex type, 
// create a wrapper script below.


//# run 0xCAFE::LambdaPass::nested_lambda --signers 0xBEEF --args 0x1u64


//# run 0xCAFE::LambdaPass::higher_order_example


//# run 0xCAFE::AliasingTest::use_access_specifiers --signers 0xBABE --args 100u64


//# run 0xCAFE::AliasingTest::call_lambda_functions --signers 0xBABE --args 0x1u64


//# run 0xCAFE::AliasingTest::call_higher_order_example

// Wrapper script to call apply_lambda with a simple lambda that increments input by 1

//# run
script {
    use 0xCAFE::LambdaPass;

    fun simple_inc(x: u64): u64 {
        x + 1
    }

    fun main(s: signer) {
        let lambda: |u64|u64 has copy+drop = simple_inc;
        let _res = LambdaPass::apply_lambda(s, lambda, 10u64);
    }
}

// Wrapper script to call nested_lambda with lambdas

//# run
script {
    use std::signer;
    use 0xCAFE::LambdaPass;

    fun main(s: signer) {
        let inner_lambda: |u64|u64 has copy+drop = |x: u64| { x * 3 };
        let outer_lambda: |(|u64|u64), u64|u64 has copy+drop = |f, y| { f(y) + 5 };
        let _res = LambdaPass::nested_lambda(s, outer_lambda, inner_lambda, 7u64);
    }
}

// Wrapper script to call call_lambda_functions in AliasingTest with lambdas

//# run
script {
    use 0xCAFE::AliasingTest;

    fun simple(x: u64): u64 {
        x + 2
    }

    fun outer(f: |u64|u64, x: u64): u64 {
        f(x) * 2
    }

    fun main(s: signer) {
        let lambda: |u64|u64 has copy+drop = simple;
        let nested_lambda: |(|u64|u64), u64|u64 has copy+drop = outer;
        let _res = AliasingTest::call_lambda_functions(s, lambda, nested_lambda, 5u64);
    }
}


// Featurres:
// a6241b2c1c8cab59ddee650c0e764b5d: Specify optional access specifiers when defining modules or resources
// 8c738cf5e5ee14fc926782c3f0f6d187: Test that lambda expressions (function values) can be passed as arguments to public entry functions, including using lambdas that call other lambdas as arguments.
// a13f6a11ca9c03e08adf80b5b5c43003: Resolve module access chains that can be interpreted as module references, considering possible aliasing and nested paths.
