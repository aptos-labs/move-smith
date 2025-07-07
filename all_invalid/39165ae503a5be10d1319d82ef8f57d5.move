
//# publish
module 0xBADD::FunctionPointerTest {
    use std::vector;

    // A simple function to test storing function pointers
    public fun static_func(a: u8): u8 {
        a + 1
    }

    // A lambda capturing a variable (simulate closure)
    public fun make_lambda(capture: u8): |u8| u8 {
        |b: u8| capture + b
    }

    // Function pointer enum to store various function pointers
    enum FuncPtr has copy, drop {
        StaticFun(fun(a: u8): u8),
        Lambda(fun: |u8| u8),
        // For simplicity, we consider only function pointer types, no vectors for now
    }

    // A resource that stores a function pointer
    struct FuncResource has key, store {
        func: FuncPtr
    }

    // Store a function pointer resource
    public fun store_static_func(s: &signer) {
        let fp = FuncPtr::StaticFun(static_func);
        move_to<FuncResource>(s, FuncResource { func: fp });
    }

    // Store a lambda as function pointer resource
    public fun store_lambda(s: &signer, capture: u8) {
        let lambda = make_lambda(capture);
        let fp = FuncPtr::Lambda(lambda);
        move_to<FuncResource>(s, FuncResource { func: fp });
    }

    // Invoke stored function pointer
    public fun invoke_func(s: &signer, arg: u8): u8 acquires FuncResource {
        let resource_ref: &FuncResource = borrow_global<FuncResource>(signer::address_of(s));
        let FuncResource { func } } = resource_ref;
        match (func) {
            FuncPtr::StaticFun(f) => f(arg),
            FuncPtr::Lambda(f) => f(arg),
        }
    }
}


//# run 0xBADD::FunctionPointerTest::store_static_func --signers 0xC0DE


//# run 0xBADD::FunctionPointerTest::invoke_func --signers 0xC0DE --args 5u8


//# run 0xBADD::FunctionPointerTest::store_lambda --signers 0xC0DE --args 42u8


//# run 0xBADD::FunctionPointerTest::invoke_func --signers 0xC0DE --args 3u8


// Featurres:
// 4c71f16b0df6e618f8a9ab7ac9045e8d: Organize compiled units into separate directories for modules and scripts.
// 7e514438995aec8f61f75d30e19f687c: Perform AST simplification on all target functions within modules.
// 2e519c18a9e5a3cb570c8d8c2e7c7d3a: Test that Move function-pointer enums can store, move, and invoke both standalone functions and lambda captures (including persistent functions and vector-of-funs), and can be composed within other enums and used as resource fields.
