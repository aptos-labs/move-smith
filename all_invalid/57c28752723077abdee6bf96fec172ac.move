
//# publish
module 0xCAFE::OperatorPrecedence {
    struct Phantom<T> has copy, drop, store, is_phantom {
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
        let comp = ((x < y) && (y > x)) || (x == 0);
        // true && true || false -> true || false -> true

        // bitwise operators mixed with comparison
        let bit_res = ((1u8 << 2) & 4u8) == 4u8;
        // (1 << 2) = 4; 4 & 4 == 4 -> true

        res && comp && bit_res
    }
}



//# run 0xCAFE::OperatorPrecedence::test_operator_precedence



//# run 0xCAFE::OperatorPrecedence::test_operator_precedence --print-bytecode
