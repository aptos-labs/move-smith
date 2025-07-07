
//# publish
module 0xCAFE::SpecLambda {
    use std::signer;

    /// A resource that stores a u8 value
    struct Data has store, key {
        value: u8,
    }

    /// Store a Data resource at the signer's address with a given value
    public fun store_data(account: signer, val: u8) {
        let data = Data { value: val };
        move_to<Data>(&account, data);
    }

    /// Update the stored value using a lambda function passed in spec (simulated by a public function taking a function)
    /// The lambda function takes the old value and returns a new value
    public fun update_with_lambda(account: signer, updater: |u8|u8) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(&account));
        let new_val = updater(data_ref.value);
        data_ref.value = new_val;
    }

    /// Increment function to use as example lambda: increments by 1
    public fun increment(x: u8): u8 {
        x + 1
    }

    /// Runner function that stores initial value 10 and updates it by incrementing twice
    public fun runner(account: signer) {
        store_data(account, 10);
        update_with_lambda(account, increment);
        update_with_lambda(account, |x: u8| { x * 2 });
    }

    /// Demonstrate use of a function with type parameter
    public fun identity<T: copy>(x: T): T {
        x
    }

    /// Runner function for identity to test optional type param function
    public fun run_identity() {
        let a = identity<u8>(5u8);
        let b = identity<u64>(123u64);
        let _ = (a, b);
    }
}


//# run 0xCAFE::SpecLambda::runner --signers 0xBEEF


//# run 0xCAFE::SpecLambda::run_identity


//# publish
module 0xCAFE::AliasDemo {
    use std::signer;

    struct Dummy has key, store {
        id: u8,
    }

    /// Store a dummy resource at signer address with given id
    public fun store_dummy(account: signer, id: u8) {
        let d = Dummy { id };
        move_to<Dummy>(&account, d);
    }

    /// Read dummy id
    public fun read_dummy(account: signer): u8 {
        let d_ref = borrow_global<Dummy>(signer::address_of(&account));
        d_ref.id
    }

    /// Remove dummy resource from signer's address
    public fun remove_dummy(account: signer) {
        let d = move_from<Dummy>(signer::address_of(&account));
        let Dummy { id: _ } = d;
    }
}

// Using module alias after publishing both modules
use 0xCAFE::AliasDemo as AD;
use 0xCAFE::SpecLambda as SL;


//# run AD::store_dummy --signers 0xABCD --args 42u8


//# run AD::read_dummy --signers 0xABCD


//# run AD::remove_dummy --signers 0xABCD


//# run SL::store_data --signers 0xABCD --args 15u8


//# run SL::update_with_lambda --signers 0xABCD --args  |x: u8| { x + 5 }


// Featurres:
// 692a8477b375dc6229cbf28d9917e838: Allow lambda parameters in spec functions; these parameters will be symbolized and tracked for use in expanded expressions.
// 5bb7e3dfbdf603732bf7d8b63e1abb18: Declare modules with symbolic names and resolve them via aliases.
// a0056ab4bdc4a5e262f9b3fda402ab12: Define functions with a name and optional type parameters.
