
//# publish
module 0xCAFE::ValueMoveTest {
    use std::signer;

    /// Struct to hold a u64 value for testing moves and independence.
    // Add the `key` ability to allow storing under an address and moving.
    struct ValueHolder has store, key {
        val: u64,
    }

    /// Creates a ValueHolder resource with given initial value at the signer's address.
    public fun create_value_holder(s: signer, initial: u64) {
        let vh = ValueHolder { val: initial };
        move_to<ValueHolder>(&s, vh);
    }

    /// Reads the val field from the ValueHolder resource at the signer's address.
    public fun read_value_holder(s: signer): u64 {
        let vh_ref = borrow_global<ValueHolder>(signer::address_of(&s));
        vh_ref.val
    }

    /// Updates the val field of the ValueHolder resource at the signer's address.
    public fun update_value_holder(s: signer, new_val: u64) {
        let vh_mut_ref = borrow_global_mut<ValueHolder>(signer::address_of(&s));
        vh_mut_ref.val = new_val;
    }

    /// Demonstrates value move and independence semantics.
    /// Moves the resource out of signer addr into local `x`,
    /// moves `x` into local `y`, updates `x`.
    /// Returns tuple of final values of x.val and y.val.
    /// The function uses package visibility on cyclic function internally.
    public fun value_move_and_independence(s: signer, initial: u64, new_val: u64): (u64, u64) {
        // Move resource out of signer into local `x`
        let x = move_from<ValueHolder>(signer::address_of(&s));
        // Move x into y; x becomes invalid for use after this
        let y = move x;

        // Now, to test independence: we create a new resource with new_val and assign it to x
        let x = ValueHolder { val: new_val };

        (x.val, y.val)
    }

    /// A package visibility cyclic function that returns the input unchanged.
    /// This simulates a cyclic identity function inside the package.
    package fun cyclic(input: u64): u64 {
        input
    }

    /// Function that calls the package visibility cyclic function.
    /// Input goes through cyclic and increases by one.
    public fun call_cyclic_and_increase(input: u64): u64 {
        let x = cyclic(input);
        x + 1
    }

    /// Combined scenario:
    /// Moves a ValueHolder resource out, passes its val through cyclic,
    /// creates a new resource with val + 10 and assigns to x (to simulate mutation),
    /// returns tuple of x.val and cycled y value.
    public fun combined_scenario(s: signer): (u64, u64) {
        let x = move_from<ValueHolder>(signer::address_of(&s));
        // Move x into y
        let y = move x;

        // Pass y.val through cyclic function (package visibility)
        let cycled_val = cyclic(y.val);

        // Create new ValueHolder with cycled_val + 10 as x
        let x = ValueHolder { val: cycled_val + 10 };

        (x.val, cycled_val)
    }
}



//# run 0xCAFE::ValueMoveTest::create_value_holder --signers 0xBEEF --args 100u64



//# run 0xCAFE::ValueMoveTest::value_move_and_independence --signers 0xBEEF --args 100u64 200u64



//# run 0xCAFE::ValueMoveTest::call_cyclic_and_increase --args 123u64



//# run 0xCAFE::ValueMoveTest::create_value_holder --signers 0xBEEF --args 50u64



//# run 0xCAFE::ValueMoveTest::combined_scenario --signers 0xBEEF
