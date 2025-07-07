
//# publish
module 0xCAFE::MutableRefAddressReturn {
    use std::signer;

    struct Counter has copy, drop, store {
        value: u64,
        owner: address,
    }

    /// Initialize a Counter with given owner address and starting value 0
    public fun init_counter(addr: address): Counter {
        Counter { value: 0u64, owner: addr }
    }

    /// Increment counter.value until it reaches limit using a mutable reference inside an inline block `while` loop.
    /// The mutable reference is obtained inside the inline block.
    /// We ensure that mutations propagate correctly.
    public fun increment_until_limit(mut counter: &mut Counter, limit: u64) {
        while ({
            // mutable reference to counter is used here in inline block for mutation
            let c_ref: &mut Counter = counter;
            c_ref.value < limit
        }) {
            let c_ref: &mut Counter = counter;
            c_ref.value = c_ref.value + 1u64;
        };
    }

    /// Function to demonstrate address literal conversion to address and use in a struct field,
    /// with mutation of that struct's field's owner via a mutable reference.
    /// We employ numeric literal addresses and symbolic ones.
    public fun mutate_owner_with_address_literals(mut c: &mut Counter) {
        // Address from numeric literal
        let numeric_addr: address = @0x42;
        c.owner = numeric_addr;

        // Address from symbolic constant
        let symbolic_addr: address = @0xCAFE;
        c.owner = symbolic_addr;
    }

    /// Function returns the current counter value explicitly using `return`
    public fun get_value_explicit_return(c: &Counter): u64 {
        return c.value
    }

    /// Function increments counter until limit and returns the final value explicitly using `return`
    public fun increment_and_return(mut c: &mut Counter, limit: u64): u64 {
        while ({
            let c_ref: &mut Counter = c;
            c_ref.value < limit
        }) {
            let c_ref: &mut Counter = c;
            c_ref.value = c_ref.value + 1u64;
        };
        return c.value
    }

    /// Runner function that creates a counter, increments to 5, mutates owner addresses, and returns final value after increments
    public fun test_runner(): u64 {
        let addr: address = @0xBEEF;
        let counter = init_counter(addr);
        let mut_ref = &mut counter;
        increment_until_limit(mut_ref, 5u64);

        // Mutate owner addresses
        mutate_owner_with_address_literals(mut_ref);

        // Explicit return
        increment_and_return(mut_ref, 10u64)
    }
}


//# run 0xCAFE::MutableRefAddressReturn::increment_until_limit -- no signers or args needed


//# run 0xCAFE::MutableRefAddressReturn::mutate_owner_with_address_literals -- no signers or args needed


//# run 0xCAFE::MutableRefAddressReturn::get_value_explicit_return -- no signers or args needed


//# run 0xCAFE::MutableRefAddressReturn::increment_and_return -- no signers or args needed


//# run 0xCAFE::MutableRefAddressReturn::test_runner


// Featurres:
// beba1f5415671ca9544da1e91fa5f84a: Test that a while loop with mutable reference modification inside an inline block correctly updates the struct’s field and maintains valid bytecode without verifier errors.
// 8126be794e550d2d18902def6bd87eb6: Convert attribute values to Move address values, supporting both numerical and symbolic addresses.
// a16a6c9869c23dafcdafa035bd0cf5e4: Return values from functions using the 'return' statement
