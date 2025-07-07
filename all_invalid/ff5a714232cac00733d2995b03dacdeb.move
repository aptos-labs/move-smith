
//# publish
module 0xDEAD::TestOperators {
    use std::vector;

    // Function to test various operators in Move
    public fun test_all_operators(a: u64, b: u64, c: bool): bool {
        // Arithmetic operators
        let sum = a + b;
        let diff = a - b;
        let prod = a * b;
        let quot = a / b;
        let rem = a % b;

        // Relational operators
        let eq = a == b;
        let neq = a != b;
        let lt = a < b;
        let le = a <= b;
        let gt = a > b;
        let ge = a >= b;

        // Bitwise operators
        let and = a & b;
        let or = a | b;
        let xor = a ^ b;
        let shift_left = a << 2;
        let shift_right = a >> 2;

        // Logical operators
        let and_logical = c && (a > 0);
        let or_logical = c || (b > 0);

        // Set operators
        let set1: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut set1, a);
        vector::push_back(&mut set1, b);
        let contains_a = vector::contains(&set1, a);

        // Collection and flow control
        let result = false;
        if (contains_a) {
            return true;
        };
        result
    }

    // Function to test '=>', '==', '!=', '<==>', '<<=', '<=', '<<', '>>=', '>=', '>>' in various contexts
    public fun test_operators(a: u64, b: u64): bool {
        let c = if (a ==> b) { true } else { false }; // '==>' as custom comparison
        // Emulate '==>' with 'if' for illustration purposes
        c
    }

    // Function to test nested modules, enums, and various operators usage
    public fun use_complex_operators(x: u8): u8 {
        let y = 0u8;
        y <<= 2; // <<= operator
        y += 1;  // += operator
        y -= 1;  // -= operator
        y *= 2;  // *= operator
        y /= 2;  // /= operator
        y %= 3;  // %= operator
        y ^= 0xFF; // ^= operator
        y <<= 1; // << operator
        y >>= 1; // >> operator

        // Use enum with operators
        let e = 0xDEAD::TestOperators::E::V2(10, 20);
        match e {
            0xDEAD::TestOperators::E::V2(a, b) => a + b as u8,
            _ => 0,
        }
    }

    // Function that tests early termination guard with return inside an if branch
    public fun early_return_test(flag: bool): bool {
        if (flag) {
            return true;
        };
        // This code should not execute if flag is true
        false
    }

    // Function to test 'init' function in module '0x42::m'
    public fun test_init(key_vals: vector<(u8, u8)>): (vector<u8>, vector<u8>) acquires 0x42::m {
        // Call init with some vectors
        let (keys, values) = 0x42::m::init(key_vals);
        (keys, values)
    }
}


//# run 0xDEAD::TestOperators::test_all_operators --args 10 20 true


//# run 0xDEAD::TestOperators::early_return_test --args true


//# run 0xDEAD::TestOperators::early_return_test --args false


//# run 0xDEAD::TestOperators::test_init --args [(1,2), (3,4), (5,6)]

//# (Note: the above args need to be passed as vector of tuples, depending on test environment, may need adjustments)

// Featurres:
// 2a6cb6f49f542b75785477273a804a43: Test that the script correctly terminates early with a return statement inside an if branch, preventing subsequent code from executing and ensuring that assertions after the return are not triggered.
// 5eafbee2719a80f9329f738c4cdd18bb: Test that the `init` function in module `0x42::m` correctly maps over the nested `KEYS` and `VALUES` vectors, producing new vectors with each element transformed as specified.
// 3d648fea915f2390d347b5bf73e7a34b: Use various operators such as '==>', '=>', '==', '!=', '<==>', '<<=', '<=', '<<', '>>=', '>=', '>>', '::', '%=', '%', '*=', '*', '+=', '+', '-=', '-', '..', '.', '/=', '/', ';', '^=', '^', '{', '}', '#', '@' in Move code.
