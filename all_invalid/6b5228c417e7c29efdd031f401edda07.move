
//# publish
module 0xCAFE::OperatorPrecedence {

    // Testing operator precedence in Move code and specifications

    public fun complex_expression(x: u64, y: u64, z: u64): u64 {
        // Expression using all operators with proper precedence:
        // operators: ==, !=, <, >, <=, >=, ||, &&, |, ^, &, <<, >>, +, -, *, /, %
        let a = (x + y * 2) << 3;       // +, *, <<
        let b = (z / 2) % 3 - 1;         // /, %, -
        let c = a | b;                   // |
        let d = c & 7;                   // &
        let e = d ^ 5;                   // ^
        let f = (e > 10) && (b <= 5);   // >, <=, &&
        let g = (x != y) || (z == 0);   // !=, ==, ||
        if (f || g) {
            a + b + c + d + e
        } else {
            0
        };
        // last expression is return
        (x + y) * z / 2 - 10 % 3
    }

    spec module {
        // Typed axioms with optional type parameters

        // Axiom with no type parameters
        axiom no_type_param (1 + 1 == 2);

        // Axiom with explicit generic type (u8)
        axiom typed_param_u8 (exists<u8>(0 as u8) == false);

        // Axiom with explicit generic type (bool)
        axiom typed_param_bool (forall<bool>((b: bool) => b == b));

        // Axiom with multiple type parameters
        axiom multi_typed_params (forall<(u64, bool)>((pair: (u64, bool)) => (fst(pair) >= 0 && (snd(pair) || true))));

        // Axiom using operators with precedence
        axiom complex_op (
            ((1 + 2 * 3 << 1) | 4 & 1 ^ 5) > 10
            && ((7 >> 2) % 3 != 0 || true)
        );
    }

    // Types that start with (T), &T, &mut T and nested

    struct Container<T> has copy, drop, store {
        val: T,
    }

    public fun types_with_parens_and_refs(x: u64): u64 {
        // using parentheses as cast/syntax grouped expression
        let a: (u64) = (x);
        let b_ref: &u64 = &a;
        let mut_val = 5;
        let mut_ref: &mut u64 = &mut (mut_val);

        let container_imm: Container<&u64> = Container { val: b_ref };
        let container_mut: Container<&mut u64> = Container { val: mut_ref };

        // Using references and parentheses in arithmetic
        let res = (*container_imm.val + *container_mut.val) << 1;

        res
    }

    spec module {
        // Typed axioms referring to references and mut refs

        axiom immutable_ref (forall<&u64>((r: &u64) => *r >= 0));

        axiom mutable_ref_modification (forall<&mut u64>((r: &mut u64) => { *r = *r + 1; true }));

        axiom nested_containers (forall<Container<&u64>>((c: Container<&u64>) => (*c.val != 0)));
    }
}


//# run 0xCAFE::OperatorPrecedence::complex_expression --args 5u64 10u64 15u64


//# run 0xCAFE::OperatorPrecedence::types_with_parens_and_refs --args 7u64
