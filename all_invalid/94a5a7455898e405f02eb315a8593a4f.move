//# publish
module 0xA11c::TestModule {
    use std::signer;
    use std::debug;
    use std::vector;

    /// 1. Function to explicitly specify module address and call an inline function with reference parameters
    public fun call_inline_with_references(signer: &signer) {
        // Define a dummy inline function that accepts references to u64 and adds them
        fun inline_add(a: &u64, b: &u64): u64 {
            *a + *b
        }

        let val1 = 10u64;
        let val2 = 20u64;
        // Use inline function with references
        let sum = inline_add(&val1, &val2);
        debug::print(&sum);
    }

    /// 2. Function to run a while loop counting from 0 to 5
    public fun test_while_loop() {
        let mut count = 0u64;
        while (count < 5) {
            count = count + 1;
        };
        // count should be 5 after loop
        assert!(count == 5, 42);
    }

    /// 3. Function to test references with mutable and immutable qualifiers
    public fun test_references() {
        let mut x = 42u64;
        // Immutable reference
        let r_imm: &u64 = &x;
        debug::print(r_imm);
        // Mutable reference
        let r_mut: &mut u64 = &mut x;
        *r_mut = 100;
        debug::print(&x);
    }

    /// 4. Struct with attributes, abilities, type parameters, and layout annotations
    #[attribute_here]
    struct TestStruct<T: copy + drop + key> has copy, drop, key {
        id: u64,
        values: vector<u64>,
        phantom: std::marker::PhantomData<T>,
    }

    /// Runner function to exercise calls
    public fun run_all(signer: &signer) {
        call_inline_with_references(signer);
        test_while_loop();
        test_references();

        // Instantiate the struct and do something with it
        let values = vector::empty<u64>();
        let my_struct = TestStruct::<u64> {
            id: 1,
            values,
            phantom: std::marker::PhantomData,
        };
        debug::print(&my_struct.id);
    }
}

//# run 0xA11c::TestModule::run_all --signers 0x1