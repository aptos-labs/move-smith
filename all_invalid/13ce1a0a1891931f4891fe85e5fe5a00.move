//# publish
module 0xCAFE::TestRefVector {

    use std::vector;

    struct Data has copy, drop, store {
        value: u64,
        list: vector::Vector<u8>,
    }

    public fun new_data(): Data {
        Data {
            value: 0u64,
            list: vector::empty<u8>(),
        }
    }

    // A function that receives a mutable Data reference, modifies its fields,
    // calls another function with mutable reference parameter and returns u64 val.
    public fun update_data(data: &mut Data): u64 {
        // Assign initial value.
        data.value = 10u64;
        vector::push_back(&mut data.list, 42u8);

        // Nested function call on mutable reference.
        nested_increment(&mut data.value);

        // Modify vector again.
        vector::push_back(&mut data.list, 99u8);

        data.value
    }

    fun nested_increment(val: &mut u64) {
        *val = *val + 32u64;
        // Another nested call to demonstrate deeper mutable ref nested call.
        nested_double(val);
    }

    fun nested_double(val: &mut u64) {
        *val = *val * 2u64;
    }

    // Test function to check variable reassignment inside function.
    public fun variable_reassignment(): u64 {
        let mut x = 1u64;
        x = x + 1u64;
        x = x * 5u64;
        let mut a = 100u8;
        a = 200u8;
        let mut b = vector::empty<u8>();
        vector::push_back(&mut b, 1u8);
        vector::push_back(&mut b, a);
        42u64 + x // 42 + 10 = 52
    }

    public fun runner(): u64 {
        let mut data = new_data();
        let val = update_data(&mut data);
        // val should be ((10 + 32) * 2) = 84
        // variable_reassignment returns 52u64, added to val to test sequential call
        val + variable_reassignment()
    }
}
//# run 0xCAFE::TestRefVector::runner

// Featurres:
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// 1d5959af559a846bd2bbdb5e7fc2490e: Verify that sequential modifications and nested function calls with mutable references correctly update the variables and produce the expected computed results in a Move module.
// 77fe1a5914789e39c4ec3e7cf17de9cb: Test that variables can be assigned and reassigned within a function without errors.
