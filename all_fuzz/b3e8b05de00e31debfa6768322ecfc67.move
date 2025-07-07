
//# publish
module 0xCAFE::SpecAndRefs {
    use std::signer;

    /// A simple struct with spec
    struct Data has store {
        val: u64
    }

    /// Specification property attached directly to the struct
    spec struct Data {
        val_nonzero: bool
    }

    /// Public function to create Data resource; uses address from sender
    public fun create_data(s: signer, v: u64): Data {
        let d = Data { val: v };
        d
    }

    /// Specification attached to the function
    spec fun create_data(s: signer, v: u64): Data {
        ensures(result.val == v);
    }

    /// Function that borrows Data immutably using a reference
    public fun borrow_data_ref(d_ref: &Data): u64 {
        d_ref.val
    }

    /// Specification for borrowing function
    spec fun borrow_data_ref(d_ref: &Data): u64 {
        ensures(result == d_ref.val);
    }

    /// Runner function that creates a Data with val 42 and borrows it immutably
    public fun runner() {
        let d = create_data(signer::spec_address(), 42);
        let val = borrow_data_ref(&d);
        // no asserts needed, just usage
    }
}


//# run 0xCAFE::SpecAndRefs::runner


// Featurres:
// 003e2fe37c925af98131d91096205537: Specify the sender address when declaring a module or rely on default error handling if the sender address is not provided.
// 8c1b5b863460050c34cbffbb2f5dd393: Attach specification blocks directly to functions and structs to articulate their formal properties.
// b209c36a585632f90e3d0971998eb855: Use reference types to borrow data immutably without taking ownership.
