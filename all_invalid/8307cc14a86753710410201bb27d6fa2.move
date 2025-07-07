
//# publish
module 0xCAFE::OperatorPrecedence {
    struct Phantom<T> has copy, drop, store {
        phantom: T,
    }

    struct S<T> has copy, drop, store {
        value: u8,
        phantom_field: Phantom<T>,
    }

    public fun new_s<T>(): S<T> {
        let p = Phantom<T> { phantom: () };
        S { value: 0, phantom_field: p }
    }

    public fun test_operator_precedence(): bool {
        // logical NOT has higher precedence than AND
        let a = true;
        let b = false;
        let c = true;
        let res = (!a && b) || c;
        // (!true && false) || true -> (false && false) || true -> false || true -> true

        // comparison and logical operators combined
        let x = 5;
        let y = 10;
        let comp = (x < y) && (y > x) || (x == 0);
        // true && true || false -> true || false -> true

        // bitwise operators mixed with comparison
        let bit_res = (1u8 << 2) & 4u8 == 4u8;
        // (1 << 2) = 4; 4 & 4 == 4 -> true

        res && comp && bit_res
    }
}


//# run 0xCAFE::OperatorPrecedence::test_operator_precedence


//# run 0xCAFE::OperatorPrecedence --print-bytecode


//# run 0xCAFE::MyModule --print-bytecode


// Featurres:
// 14b7b51daf435f773736caa60cd1e4f0: Test the ability to print the bytecode of a simple script and a module using the provided commands.
// fa13ae8844f6999f4ee0d23e96185bbd: Test that operator precedence for logical, comparison, and bitwise operators behaves according to standard rules in Move scripts.
// 442e0dcdfd33d8af2b7856544d547ff0: Mark struct type parameters as phantom using is_phantom
