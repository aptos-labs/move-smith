//# publish
module 0xCAFE::SpecAndFuncs {
    use std::vector;

    struct Data has store {
        value: u64,
    }

    /// Spec for the module
    spec module {
        // Ensure no global Data resource exists at any address
        invariant forall addr: address. !exists<Data>(addr);
    }

    /// Function to create a Data resource at the caller's address
    public fun create_data(account: &signer, val: u64) {
        let data = Data { value: val };
        move_to<Data>(account, data);
    }

    /// Function to update the stored value
    public fun update_data(account: &signer, new_val: u64) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(account));
        data_ref.value = new_val;
    }

    /// Function to read the stored value
    public fun read_data(account: &signer): u64 {
        let data_ref: &Data = borrow_global<Data>(signer::address_of(account));
        data_ref.value
    }

    /// Function without arguments to test unique function names
    public fun unique_fn_a(): u64 {
        42u64
    }

    /// Another uniquely named function
    public fun unique_fn_b(x: u64): u64 {
        x * 2
    }

    /// Another function with spec block inside
    public fun fn_with_spec() {
        spec {
            // A simple dummy ensures inside function spec
            ensures true;
        }
    }
}

//# run 0xCAFE::SpecAndFuncs::unique_fn_a

//# run 0xCAFE::SpecAndFuncs::unique_fn_b --args 10u64

//# run 0xCAFE::SpecAndFuncs::create_data --signers 0xBEEF --args 100u64

//# run 0xCAFE::SpecAndFuncs::read_data --signers 0xBEEF

//# run 0xCAFE::SpecAndFuncs::update_data --signers 0xBEEF --args 200u64

//# run 0xCAFE::SpecAndFuncs::read_data --signers 0xBEEF

//# run 0xCAFE::SpecAndFuncs::fn_with_spec

// Featurres:
// 9d40c81f170d4ee5e3c954925313da38: Compile the entire Move program as a whole for analysis purposes.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
// 6d0be2c02eeb777440500277409d24ee: Define specification blocks for Move modules.
