//# publish
module 0xCAFE::TestSpec {
    use std::signer;

    // Spec block testing multiple spec members and function declarations with parentheses
    spec TestSpec {
        // A spec boolean variable
        let spec_bool = true;

        // A spec constant
        const spec_const: u8 = 42;

        // A spec function with parameter list in parentheses
        fun spec_fun(arg1: u8, arg2: u8): u8 {
            arg1 + arg2
        }

        // Another spec function returning tuple
        fun spec_fun_tuple(x: u8): (u8, u8) {
            (x, x + 1)
        }
    }

    // Function testing that assigning new value to a local variable updates the variable correctly
    public fun test_local_var_update(x: u8): u8 {
        let y = x;
        let y = y + 10;
        let y = y * 2;
        y
    }
}

//# run 0xCAFE::TestSpec::test_local_var_update --args 5u8

// Featurres:
// cbbb2abb9b13eae9eec5a0699370e467: Test that assigning a new value to a local variable updates its value correctly before returning it.
// 4802739e395318325d8585930d38a715: Write Move specification blocks (spec blocks) containing multiple specification members.
// c97d16ca4d327179d64cbaa15d06c6b2: Declare functions in specifications with parameter lists enclosed in parentheses.
