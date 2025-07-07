// This transactional test file is aimed at thoroughly testing the Move compiler and VM for:
// 1. Handling cycles in the call graph (via mutually recursive functions).
// 2. Strong type-checking on modules.
// 3. Binary operations including binop_exp and spec-only operators in spec blocks.

//# publish
module 0xCAFE::CyclicA {
    use 0xCAFE::CyclicB;

    /// Start of mutual recursion; calls into CyclicB.
    public fun a(n: u8): u8 {
        if (n == 0u8) {
            42u8
        } else {
            CyclicB::b(n - 1)
        }
    }

    /// "Runner" for testing the cycle.
    public fun run_cyclic(): u8 {
        a(3u8)
    }
}

//# publish
module 0xCAFE::CyclicB {
    use 0xCAFE::CyclicA;

    /// Other end of mutual recursion; calls into CyclicA.
    public fun b(n: u8): u8 {
        if (n == 0u8) {
            99u8
        } else {
            CyclicA::a(n - 1)
        }
    }
}

//# run 0xCAFE::CyclicA::run_cyclic --signers 0xCAFE

//# publish
module 0xCAFE::TypeCheckBinop {
    /// Used to exercise the type checker via type errors.
    public fun add_u8_u64(x: u8, y: u64): u128 {
        (x as u128) + (y as u128)
    }

    /// Binary operation exp: factorial implemented with binop_exp (`*=`).
    public fun factorial(mut n: u64): u64 {
        let mut res = 1u64;
        while (n > 1) {
            res *= n;
            n -= 1;
        };
        res
    }

    /// "Runner" to test factorial
    public fun run_fact(): u64 {
        factorial(5)
    }

    /// In spec, use spec-only binop (==>) and |==> (syntactic sugar).
    spec module {
        // spec-only binop_exp: ==> is implication; <==> is biimplication.
        fun test_spec_ops(a: bool, b: bool) {
            let implication = a ==> b;
            let biimplication = a <==> b;
            let conjunction = a && b;
            let disjunction = a || b;
            let exclusive_or = a ^^ b;
            let not_a = !a;
            // Just to touch them, no runtime code needed
            // This will type check spec-only expressions
        }
        // Test quantifiers with binop_exp
        fun test_quantified() {
            assert (forall i in 0..3: (i == 0) || (i == 1) || (i == 2));
        }
    }
}

//# run 0xCAFE::TypeCheckBinop::run_fact --signers 0xCAFE

//# run 0xCAFE::TypeCheckBinop::add_u8_u64 --signers 0xCAFE --args 10u8 20u64

//# run
script {
    use 0xCAFE::TypeCheckBinop;
    fun main() {
        let f = TypeCheckBinop::factorial(6);
        let a = TypeCheckBinop::add_u8_u64(7u8, 8u64);
    }
}