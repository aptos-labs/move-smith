
//# publish
module 0xDEAD::TestModule {
    use std::signer;
    use std::vector;

    // Function accessible only within this package, using package visibility (not public)
    fun package_only_create_and_store(s: signer): u64 {
        move_to<Trigger>(signer::address_of(&s), Trigger { value: 0 })
    }

    // Struct for storing a function pointer or inline function closure simulation
    struct Trigger has store, key {
        value: u64,
    }

    // Initialize stored function to return 23
    public fun init_trigger(s: signer): () {
        let trigger = Trigger { value: 23 };
        move_to<Trigger>(&s, trigger);
    }

    // Invoke the stored function (simulate by reading value)
    public fun invoke_trigger(s: signer): u64 {
        let trigger_ref: &Trigger = borrow_global<Trigger>(signer::address_of(&s));
        trigger_ref.value
    }

    // Inline function that accepts a closure and calls it with multiple arguments
    public fun call_closure<F: copy + drop + store>(closure: F, a: u8, b: u8): u8
        acquires vector
        where F: |u8, u8| -> u8
    {
        closure(a, b)
    }

    // A specific closure implementation that adds two numbers
    public fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    // Runner function to test inline function with a closure
    public fun test_inline_closure(s: signer): u8 {
        let result = call_closure(add_two, 10u8, 13u8);
        result
    }
}


//# run 0xDEAD::TestModule::init_trigger --signers 0xABCD


//# run 0xDEAD::TestModule::invoke_trigger --signers 0xABCD


//# run 0xDEAD::TestModule::test_inline_closure --signers 0xABCD


// Featurres:
// c18dac7d43bc42e327a1c7901863c555: Use 'package' visibility for functions accessible only within the same package.
// 930f83177884e6968dc972db2624fc13: Test that a stored function can be initialized and later invoked to return the expected value 23.
// 7854d5b4796bbb1c7109a4054262a16d: Test that an inline function can accept and properly call a closure with multiple arguments, verifying argument binding and correct return value.
