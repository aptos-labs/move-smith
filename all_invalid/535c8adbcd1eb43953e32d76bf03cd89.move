// Declare an address block outside of modules or scripts
address 0xABC {
    // Test case for assigning a local copy of a struct and modifying through mutable reference
    //# publish
    module 0xABC::StructTest {
        // Define a simple struct with a field
        struct MyStruct has copy, drop, store {
            value: u64,
        }

        // Runner function to test copying and modification
        public fun run_test() {
            let s = MyStruct { value: 42 };
            // Create a mutable copy
            let mut s_copy = s;
            // Borrow a mutable reference to the copy
            let s_ref = &mut s_copy;
            // Modify the field through the reference
            s_ref.value = 100;
            // Return the modified value
            value(s_ref)
        }

        // Getter function to retrieve the field value
        public fun value(s: &mut MyStruct): u64 {
            s.value
        }
    }

    // Script to invoke run_test and verify the behavior
    //# run
    script {
        // Call the runner function inside the module
        0xABC::StructTest::run_test()
    }
}

// Reference modules via module access chains, combining nested modules
//# publish
module 0xDEF::Outer {
    module Inner {
        // Define a simple function in nested module
        public fun get_magic_number(): u64 {
            123456
        }
    }
}

// Script to call nested module function using module access chain
//# run
script {
    // Access nested module via chained access
    0xDEF::Outer::Inner::get_magic_number()
}

// Create tuple-like struct variants with positional fields
//# publish
module 0x123::TupleVariants {
    // Define tuple-like structs (variant with positional fields)
    struct Pair has copy, drop, store {
        0: u64,
        1: bool,
    }

    // Function that constructs and returns a Pair
    public fun create_pair(val: u64, flag: bool): Pair {
        Pair { 0: val, 1: flag }
    }

    // Function to modify the 'first' field of the pair
    public fun update_first(p: &mut Pair, new_val: u64) {
        p.0 = new_val;
    }
}

// Script to create a pair and modify it
//# run
script {
    let p = 0x123::TupleVariants::create_pair(10, true);
    let mut p_mut = p;
    0x123::TupleVariants::update_first(&mut p_mut, 999);
    // Return the modified first field
    p_mut.0
}