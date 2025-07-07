
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // ignore sum, always return 42
        42u8
    }

    public fun get_adder(): |u8, u8| u8 has copy+drop {
        let lambda = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 15u8


//# run 0xCAFE::AdditionModule::get_adder


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline_add_and_lambda(x: u8, y: u8): u8 {
        let inline_sum = inline_add(x, y);
        let adder = AdditionModule::get_adder();
        let lambda_sum = adder(x, y);
        inline_sum + lambda_sum
    }
}


//# run 0xCAFE::NestedCaller::call_inline_add_and_lambda --args 3u8 4u8


//# publish
module 0xCAFE::UnusedChecker {
    // Function with unused variable and parameter
    public fun unused_var_and_param(_unused_param: u8): u8 {
        let unused_var = 0u8;
        7u8
    }

    // Function with all parameters used - ensure no warnings on used params
    public fun used_params(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::UnusedChecker::unused_var_and_param --args 10u8


//# run 0xCAFE::UnusedChecker::used_params --args 5u8 6u8


//# publish
module 0xCAFE::KeyDropGeneric {
    use std::signer;

    // Struct with key and drop abilities
    struct KDKeyDrop has key, drop {
        id: u64,
    }

    // A generic function requiring T: key + drop
    public fun borrow_and_move<T: key + drop>(addr: address) {
        // Borrow and then move the resource from storage
        let resource_ref = borrow_global<T>(addr);
        let _id = 0u64;
        // 'resource_ref' unused other than borrow to test unused var detection
        let _ = _id;

        let _moved = move_from<T>(addr);
    }

    // Function to create and store KDKeyDrop at signer's address
    public fun create_and_store(s: signer) {
        let resource = KDKeyDrop { id: 123 };
        move_to<KDKeyDrop>(&s, resource);
    }
}


//# run 0xCAFE::KeyDropGeneric::create_and_store --signers 0xDEAD


//# run 0xCAFE::KeyDropGeneric::borrow_and_move --args 0xDEAD


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0f73841b7d38953764a6f6cb7e505d4a: Use hexadecimal format for the numerical address when no named address is found.
// 5909ed0cbb657584f606bc62ef533156: Check for unused variables and parameters.
// ac9ab191f3aac312916f7734f8577b5b: Test that a type with both the `key` and `drop` abilities is rejected when passed to a generic function parameter requiring `key + drop` and used with both `borrow_global` and `move_from` in the same function.
