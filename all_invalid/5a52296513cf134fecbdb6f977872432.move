//# publish
module 0xCAFE::MutateAndCallTest {
    use 0xCAFE::Vector;

    // Struct with a mutable field to test direct mutation via dotted expressions
    struct DataHolder {
        value: u64,
    }

    // An inline function that modifies the field of a referenced DataHolder
    public inline fun mutate_value(holder: &mut DataHolder, new_value: u64) {
        // Mutate the field directly
        holder.value = new_value;
    }

    // A simple operator function that increments a u64 value
    public fun increment(val: u64): u64 {
        val + 1
    }

    // Function to get a new DataHolder with specified value
    public fun create_holder(initial_value: u64): DataHolder {
        DataHolder { value: initial_value }
    }

    // Public function to call the mutate_value using call expression
    public fun run_mutation(holder_ref: &mut DataHolder, new_value: u64) {
        // Call the mutate_value function dynamically
        call mutate_value(&mut holder_ref, new_value);
    }

    // Function to demonstrate calling the increment function
    public fun use_increment(val: u64): u64 {
        call increment(val)
    }
}

//# run 0xCAFE::MutateAndCallTest::run_mutation --signers 0xCAFE --args 0xCAFE::MutateAndCallTest::DataHolder 42u64
//# run 0xCAFE::MutateAndCallTest::use_increment --signers 0xCAFE --args 42u64
// The above run will test mutating fields directly and calling functions with call expression, including passing references