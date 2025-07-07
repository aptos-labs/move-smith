// --------------- Module 0: Variable assignment, loops, tuple unpacking --------------
//# publish
module 0xCAFE::VarLoopTest {
    public fun sum_loop(n: u64): u64 {
        let i = 0;
        let acc = 0;
        while (i < n) {
            acc = acc + i;
            i = i + 1;
        };
        acc
    }

    public fun tuple_unpack_swap(x: u8, y: u8): (u8, u8) {
        let (a, b) = (x, y);
        let (x1, y1) = (b, a);
        (x1, y1)
    }

    public fun loop_with_break(n: u64): u64 {
        let i = 0;
        let acc = 0;
        while (i < 10) {
            if (i == n) {
                return acc;
            };
            acc = acc + i;
            i = i + 1;
        };
        acc
    }

    public fun runner(): u64 {
        let sum = Self::sum_loop(5);
        let (a, b) = Self::tuple_unpack_swap(7, 42);
        let sum2 = Self::loop_with_break(3);
        sum + (a as u64) + (b as u64) + sum2
    }
}
//# run 0xCAFE::VarLoopTest::runner

// ---------------- Module 1: Spec functions call Move functions  ----------------------
//# publish
module 0xCAFE::SpecFunTest {
    public fun double(x: u64): u64 {
        x * 2
    }

    public fun triple(x: u64): u64 {
        x * 3
    }

    public fun runner(): u64 {
        Self::double(10) + Self::triple(5)
    }

    spec fun spec_double(x: u64): u64 {
        // Call Move function, will auto-convert (as pure) for spec run
        Self::double(x)
    }
    spec fun spec_sum(x: u64): u64 {
        // Use two pure move fns in spec context
        Self::double(x) + Self::triple(x)
    }

    spec module {
        // Prove an invariant using function calls inside spec
        include "assert";
        invariant [forall x: u64 where x < 1000] Self::spec_sum(x) == x * 5;
    }
}
//# run 0xCAFE::SpecFunTest::runner

// ------------ Module 2: Parsing expression end, trailing semicolon corner cases ----------
//# publish
module 0xCAFE::ExprParsing {
    public fun ends_with_semicolon(): u64 {
        let x = 10;
        // Statement ends, last expr returns value
        x + 2
    }

    public fun trailing_semicolon(): u64 {
        let x = 42;
        x;     // This is a valid statement. Has to return explicitly
        7      // return value
    }

    public fun inside_if_semicolon(x: u64): u64 {
        if (x > 0) {
            100
        } else {
            let y = 99;
            y;   // This is statement, need to return after
            2
        }
    }

    public fun tuple_unpack_semicolon(x: u8, y: u8): u8 {
        let (a, b) = (x, y);
        (a + b)
    }

    public fun runner(): u64 {
        let a1 = Self::ends_with_semicolon();
        let a2 = Self::trailing_semicolon();
        let a3 = Self::inside_if_semicolon(1);
        let a4 = Self::inside_if_semicolon(0);
        let a5 = Self::tuple_unpack_semicolon(3, 4) as u64;
        a1 + a2 + a3 + a4 + a5
    }
}
//# run 0xCAFE::ExprParsing::runner

// --------------- Script 0: call variable assignment and loops --------------------
//# run
script {
    fun main() {
        let sum = 0xCAFE::VarLoopTest::sum_loop(4);
        let (x, y) = 0xCAFE::VarLoopTest::tuple_unpack_swap(1, 2);
        let r = 0xCAFE::VarLoopTest::loop_with_break(5);
        let total = sum + (x as u64) + (y as u64) + r;
    }
}

// --------------- Script 1: test spec call as regular fn, edge --------------
//# run
script {
    fun main() {
        let s = 0xCAFE::SpecFunTest::double(21);
        let t = 0xCAFE::SpecFunTest::triple(8);
        let st = s + t;
    }
}

// --------------- Script 2: test parsing, trailing semi --------------
//# run
script {
    fun main() {
        let a = 0xCAFE::ExprParsing::ends_with_semicolon();
        let b = 0xCAFE::ExprParsing::trailing_semicolon();
        let c = 0xCAFE::ExprParsing::tuple_unpack_semicolon(8, 1);
        // test with isolated statement ending
        a; b; c;
    }
}

// Featurres:
// 148f8f11525d7f5ee481989ede53ac5a: Test that variable assignments and loops in Move functions correctly preserve and return expected values.
// 9ef46790f73a4b2d6cabd8cc8f268480: Call Move functions from within specifications, and have them automatically converted to specification functions for use in proofs and verification.
// fad8d730f13fe5f9440eb11c1b5cce8f: Determine when an expression has reached its end during parsing
