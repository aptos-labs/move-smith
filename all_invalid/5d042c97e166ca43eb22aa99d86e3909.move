
//# publish
module 0xBEEF::ConstModule {
    // Define a constant with a fixed value
    const MY_CONST: u64 = 0;

    // Function to assign a constant with an expression to a local variable
    public entry fun assign_constant_to_var(x: u64): u64 {
        let result = MY_CONST + x;
        result
    }
}


//# run 0xBEEF::ConstModule::assign_constant_to_var --signers 0xBEEF --args 10u64


//# publish
module 0xDEAD::TestModule {
    use std::signer;

    // Encapsulate multiple related functions
    struct DataResource {
        counter: u64,
    }

    // Function to initialize resource
    public entry fun init_resource(s: signer): () {
        move_to(&s, DataResource { counter: 0 });
    }

    // Function to increment resource counter
    public entry fun increment_counter(s: signer, amount: u64) {
        let resource_ref: &mut DataResource = borrow_global_mut<DataResource>(&signer::address_of(&s));
        resource_ref.counter = resource_ref.counter + amount;
    }

    // Function to get the current counter value
    public fun get_counter(s: signer): u64 {
        let resource_ref: &DataResource = borrow_global<DataResource>(&signer::address_of(&s));
        resource_ref.counter
    }
}


//# run 0xDEAD::TestModule::init_resource --signers 0xBEEF


//# run 0xDEAD::TestModule::increment_counter --signers 0xBEEF --args 5u64


//# run 0xDEAD::TestModule::get_counter --signers 0xBEEF


//# publish
module 0xC0FFEE::EntryFunctionModule {
    use std::signer;

    // Marked as an entry function, callable as a transaction entry point
    public entry fun set_value(s: signer, value: u8) {
        // dummy logic
        let _ = value;
    }
}


//# run 0xC0FFEE::EntryFunctionModule::set_value --signers 0xBEEF --args 42u8


// Featurres:
// 5ad335da8be1c3196ef5853fa8f1703a: Assign a value to the constant using '=' followed by an expression.
// 9def49343c650663209a2268dd6c0e84: Define Move modules to encapsulate related code and resources.
// 9d566eb4836899102ffef9aba3b62e3f: Mark a function as an entry function, allowing it to be published as a transaction entry point using the 'entry' keyword.
