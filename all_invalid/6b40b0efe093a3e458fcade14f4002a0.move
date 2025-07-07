//# publish
module 0xCAFE::PersistentFunctionTest {
    use std::signer;

    // A struct that holds a persistent function value
    struct WithPersistentFun has copy, drop, store, key {
        #[persistent]
        fun_value: |u8, u8| u8,
    }

    // A simple pure function with no side effects for testing
    public fun add(a: u8, b: u8): u8 {
        a + b
    }

    // Create an instance with persistent function and save it on chain
    public fun store_fun_value(s: signer) {
        let fun_struct = WithPersistentFun { fun_value: add };
        move_to<WithPersistentFun>(&s, fun_struct);
    }

    // Load the struct and call the persistent function by reference
    public fun call_persistent_fun(s: signer, x: u8, y: u8): u8 {
        let struct_ref = borrow_global<WithPersistentFun>(signer::address_of(&s));
        (struct_ref.fun_value)(x, y)
    }

    // A function that uses local declare with multiple variables
    public fun declare_locals_demo(x: u8, y: u8): u8 {
        declare a, b, c;
        a = x;
        b = y;
        c = a + b;
        c
    }

    // Compose calling functions from this module internally
    public fun call_inner_functions(x: u8, y: u8): u8 {
        let intermediate = add(x, y);
        let declared_result = declare_locals_demo(intermediate, x);
        declared_result
    }
}

//# run 0xCAFE::PersistentFunctionTest::store_fun_value --signers 0xBEEF

//# run 0xCAFE::PersistentFunctionTest::call_persistent_fun --signers 0xBEEF --args 10u8 20u8

//# run 0xCAFE::PersistentFunctionTest::declare_locals_demo --args 7u8 8u8

//# run 0xCAFE::PersistentFunctionTest::call_inner_functions --args 5u8 6u8

// Featurres:
// 8db12352c42c4ea104290654dfb2da9d: Test that a function value with the #[persistent] attribute can be safely stored inside a struct, persisted on-chain, and successfully called via a reference after retrieval.
// de04319eb88235b3bcf9371bc1ad5660: Declare local variables in Move code using `declare` statements with a list of variables.
// c150678e2ba024f66c89f243d725cb9d: Call functions from other functions unless restricted by Move's function call rules.
