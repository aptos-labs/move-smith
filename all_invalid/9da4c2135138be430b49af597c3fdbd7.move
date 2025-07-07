
//# publish
module 0xCAFE::SpecAndRefs {
    use std::signer;

    /// A simple struct with spec
    struct Data has store {
        val: u64
    }

    /// Specification property attached directly to the struct
    spec Data {
        val_nonzero: bool;
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
