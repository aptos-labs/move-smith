
//# publish
module 0xCAFE::AccessSpecifiers {
    // Test optional access specifiers for module and resources

    use std::signer;

    struct PublicResource has key, store {
        value: u64,
    }

    struct PrivateResource has key, store {
        value: u64,
    }

    // Fix: `friend` keyword applies only to functions/structs, not bare identifiers.
    // Make FriendResource a friend struct by declaring it with `friend` or use proper visibility modifiers.

    // There's no direct support for friend structs in current Move version, so let's remove the invalid 'friend FriendResource;' line
    // and instead we will mark `FriendResource` struct as friend with friend visibility for its functions (see Move docs).

    struct FriendResource has key, store {
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

    // No friend entry functions in Move currently, so mark as 'public entry'
    public entry fun create_friend_resource(account: signer, val: u64) {
        let res = FriendResource { value: val };
        move_to<FriendResource>(&account, res);
    }

    public fun read_public_resource(account: signer): u64 {
        let r = borrow_global<PublicResource>(signer::address_of(&account));
        r.value
    }

    // This is private function
    fun read_private_resource(account: signer): u64 {
        let r = borrow_global<PrivateResource>(signer::address_of(&account));
        r.value
    }

    // Change friend fun to `public fun` or `public(friend)` if supported, else just public
    public fun read_friend_resource(account: signer): u64 {
        let r = borrow_global<FriendResource>(signer::address_of(&account));
        r.value
    }
}



//# publish
module 0xCAFE::LambdaPass {
    // Test passing lambda expressions (closures) as args to public entry functions,
    // including lambdas that call other lambdas

    use std::signer;

    // The Fn trait and dyn Fn types with closures are not yet supported like in Rust.
    // We'll remove these types and replace with function pointer types available in Move:

    // So instead of &dyn Fn(...) -> ..., use a function pointer type: e.g. `&fun`

    // Update accordingly:

    public entry fun apply_lambda(
        s: signer,
        f: fun(u64): u64,
        input: u64
    ): u64 {
        f(input)
    }

    public entry fun nested_lambda(
        s: signer,
        f_outer: &fun(fun(u64): u64, u64): u64,
        f_inner: fun(u64): u64,
        input: u64
    ): u64 {
        (*f_outer)(f_inner, input)
    }

    public fun simple_increment(x: u64): u64 {
        x + 1
    }

    public fun higher_order_example(): u64 {
        let inner_lambda: fun(u64): u64 = fun(x: u64): u64 { x * 2 };
        // The type for outer_lambda should be &fun(fun(u64): u64, u64): u64
        // But we cannot assign an inline closure to a fun pointer, so instead define a
        // named function:

        fun outer_lambda(f: fun(u64): u64, y: u64): u64 {
            let intermediate = f(y);
            intermediate + 10
        }

        outer_lambda(inner_lambda, 5u64)
    }
}



//# publish
module 0xCAFE::AliasingTest {
    // Test module access chains and aliasing

    use 0xCAFE::AccessSpecifiers;
    use 0xCAFE::LambdaPass::{apply_lambda, nested_lambda, simple_increment, higher_order_example};

    public entry fun use_access_specifiers(account: signer, val: u64) {
        // call public entry to create resource via alias
        AccessSpecifiers::create_public_resource(account, val);
    }

    public entry fun call_lambda_functions(
        account: signer,
        lambda: fun(u64): u64,
        nested_lambda_fn: &fun(fun(u64): u64, u64): u64,
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
        let lambda: fun(u64): u64 = simple_inc;
        let _res = LambdaPass::apply_lambda(s, lambda, 10u64);
    }
}

// Wrapper script to call nested_lambda with lambdas


//# run
script {
    use 0xCAFE::LambdaPass;

    fun outer(f: fun(u64): u64, y: u64): u64 {
        f(y) + 5
    }

    fun main(s: signer) {
        let inner_lambda: fun(u64): u64 = fun(x: u64): u64 { x * 3 };
        let outer_lambda = &outer;
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

    fun outer(f: fun(u64): u64, x: u64): u64 {
        f(x) * 2
    }

    fun main(s: signer) {
        let lambda: fun(u64): u64 = simple;
        let nested_lambda = &outer;
        let _res = AliasingTest::call_lambda_functions(s, lambda, nested_lambda, 5u64);
    }
}
