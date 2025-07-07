//# publish
module 0xDEADBEEF::TestModule {
    /// Struct with a simple numeric field.
    struct S {
        value: u64,
    }

    /// Function to create an instance of S.
    public fun new_s(init_value: u64): S {
        S { value: init_value }
    }

    /// Function to calculate the sum of values from different references.
    /// This will test that compiler correctly handles frozen and mutable references and inference of acquired resources.
    public fun sum(s_ref: &S, s_mut_ref: &mut S): u64 {
        // Read from the frozen reference
        let val_from_ref = copy s_ref.value;

        // Mutate the mutable reference
        s_mut_ref.value = s_mut_ref.value + val_from_ref;

        // Return the sum of the original value and the mutated value
        val_from_ref + s_mut_ref.value
    }

    /// Runner function to test sum
    public fun run_sum(): u64 {
        let s = Self::new_s(10);
        let mut s_mut = s; // Mutable copy of s
        // Call sum with references
        Self::sum(&s, &mut s_mut)
    }
}

//# run 0xDEADBEEF::TestModule::run_sum --signers 0x1
