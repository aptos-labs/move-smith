//# publish
module 0xabcde::swap_and_compute {
    public fun complex_swap(): u64 {
        let a = 5;
        let b = 15;
        let total = 0;

        // First nested block swaps and modifies
        { 
            let (a, b) = (b, a + 10);  // a = 15, b = 5 + 10 = 15
            total = total + a + b;    // total = 0 + 15 + 15 = 30
        }

        // Second nested block further modifies
        { 
            let (a, b) = (a * 2, b - 3); // a = 15 * 2 = 30, b = 15 - 3 = 12
            total = total + a + b;      // total = 30 + 30 + 12 = 72
        }

        // Third nested block tests reuse of original bindings
        { 
            let (a, b) = (b + 10, a / 2); // a = 12 + 10 = 22, b = 30 / 2 = 15
            total = total + a + b;        // total = 72 + 22 + 15 = 109
        }

        total
    }
}

//# run 0xabcde::swap_and_compute::complex_swap

//# publish
module 0xfedcb::sequential_reassignment {
    struct Data has copy, drop {
        x: u64,
        y: u64,
        z: u64,
    }

    fun reassign_sequence(p: Data): Data {
        let mut one = p;
        let mut two = one;
        let mut three = two;
        let mut four = three;

        // Sequentially reassign values
        one = Data {x: one.x + 1, y: one.y + 1, z: one.z + 1};
        two = one;
        three = two;
        four = three;

        // Return the final state
        four
    }

    public fun main(): bool {
        let input = Data {x: 1, y: 2, z: 3};
        let result = reassign_sequence(input);
        // Check if the result has the incremented values
        result.x == 2 && result.y == 3 && result.z == 4
    }
}

//# run 0xfedcb::sequential_reassignment::main