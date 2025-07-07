// SPDX-License-Identifier: Apache-2.0
// # publish
module 0xCAFE::ControlAndRef {
    use std::signer;
    use std::vector;

    /// A simple struct with copy and drop abilities so we can copy it around.
    struct Data has copy, drop, store {
        value: u64,
    }

    /// Constructs a Data instance with a value.
    public fun create_data(val: u64): Data {
        Data { value: val }
    }

    /// Consumes data and returns value.
    public fun extract_value(data: Data): u64 {
        data.value
    }

    /// Exposes an immutable reference to the data's value.
    public fun borrow_immut(data: &Data): u64 {
        data.value
    }

    /// Exposes a mutable reference and increments the value by 1.
    public fun borrow_mut_and_increment(data: &mut Data) {
        data.value = data.value + 1;
    }

    /// Runner function that demonstrates label usage in bytecode via Move control flow.
    /// This function computes factorial using a loop and label-like control flow by 
    /// using `loop` and `break` with returns mimicking labels.
    public fun factorial(n: u64): u64 {
        let mut result = 1u64;
        let mut i = 1u64;

        // Mimic label start:
        loop {
            if (i > n) {
                break;
            }
            result = result * i;
            i = i + 1;
        }
        result
    }

    /// Runner function that creates data, mutably borrows it, increments and returns new value.
    public fun runner(): u64 {
        let mut d = create_data(10);
        borrow_mut_and_increment(&mut d);
        borrow_immut(&d)
    }
}
// # run 0xCAFE::ControlAndRef::runner

//# run 0xCAFE::ControlAndRef::factorial --args 5u64

//# run
script {
    use 0xCAFE::ControlAndRef;

    fun main() {
        // Test direct function calls in a script
        
        // Create Data instance
        let d = ControlAndRef::create_data(42u64);
        let val1 = ControlAndRef::borrow_immut(&d);
        // val1 should be 42

        // Mutable borrow in script context requires mutable binding
        let mut d2 = ControlAndRef::create_data(100u64);
        ControlAndRef::borrow_mut_and_increment(&mut d2);
        let val2 = ControlAndRef::borrow_immut(&d2);
        // val2 should be 101

        // Test factorial routine
        let fact_6 = ControlAndRef::factorial(6u64);
        // fact_6 should be 720

        // Consume values to avoid unused warnings
        let _ = (val1, val2, fact_6);
    }
}

// Featurres:
// 336076452978ed665784ddcf662dcede: Write tests for Move modules that are primary targets of compilation
// 22fc7f5e0dd6dc029c1c5f9e355f0384: Use labels in your bytecode sequence to mark specific points in control flow.
// d8cdb5d241984672a40e8f3d21c38758: Reference types mutably or immutably with 'Ref'.
