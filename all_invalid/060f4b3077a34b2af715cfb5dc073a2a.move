
//# publish
module 0xDEAD::SpecExample {
    // Module with explicit specifications and use annotations.
    use std::vector;

    // Constants for use in spec
    const TEST_CONST: u32 = 0xABCD;

    // Define a struct with specification annotations
    struct SpecStruct has copy, drop, store, key {
        x: u8,
        y: u16,
    }

    // Spec function with imperative expression (marked according to spec)
    public fun spec_compute_sum(a: u8, b: u8): u16 {
        let sum = (a as u16) + (b as u16);
        // Implicitly considered uninterpreted in verification
        sum
    }

    // Use annotated enum
    enum UseEnum has copy, drop {
        Variant1,
        Variant2(u8, u16),
        Variant3 {
            flag: bool
        }
    }

    // Spec function containing imperative expression - should be marked as uninterpreted
    public fun spec_process_enum(e: UseEnum): u8 {
        // branch expression
        match (e) {
            UseEnum::Variant1 => 0,
            UseEnum::Variant2(a, b) => {
                // imperative expression
                let _temp = a + (b as u8);
                _temp
            },
            UseEnum::Variant3 { flag } => {
                if (flag) {
                    1
                } else {
                    2
                }
            },
        }
    }

    // Function with side-effect (imperative expression)
    public fun spec_side_effect() {
        let x = 10;
        // Assignment inside - considered as imperative expression
        // No return value
        let _ = x + 20;
    }

    // Spec function with vector of u8
    public fun spec_vector_sum(vec: vector<u8>): u8 {
        let total: u8 = 0;
        let len = vector::length(&vec);
        let i = 0;
        while (i < len) {
            let val = *vector::borrow(&vec, i);
            total = total + val;
            let _ = i + 1;
        };
        total
    }

    // public spec function that returns a boolean based on imperative expression
    public fun spec_check(x: u16): bool {
        if (x > 100) {
            true
        } else {
            false
        }
    }
}



//# run 0xDEAD::SpecExample::spec_compute_sum --args 12u8 34u8



//# run 0xDEAD::SpecExample::spec_process_enum --type-args UseEnum --args Variant2(5u8, 10u16)




//# run 0xDEAD::SpecExample::spec_side_effect --args



//# run 0xDEAD::SpecExample::spec_vector_sum --args b"abc" // vector with 3 u8 values



//# run 0xDEAD::SpecExample::spec_check --args 150u16