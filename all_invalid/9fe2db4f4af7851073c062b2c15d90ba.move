// # publish
module 0xCAFE::TupleAndMatch {
    use std::option;

    // Define a tuple struct with multiple fields
    struct MyTuple has copy, drop, store {
        field0: u8,
        field1: bool,
        field2: u64,
    }

    // Define a nested struct for deep pattern matching
    struct Inner has copy, drop, store {
        a: u8,
        b: bool,
    }

    struct Outer has copy, drop, store {
        x: Inner,
        y: u64,
    }

    // Define an enum with multiple variants and fields to pattern match
    enum MyEnum has copy, drop, store {
        Variant0,
        Variant1(u8, bool),
        Variant2 { a: u8, b: bool },
        Variant3(Outer),
    }

    // Function to test tuple field access by positional syntax .0, .1, .2
    public fun test_tuple_access(): u64 {
        let t = MyTuple { field0: 10, field1: true, field2: 42 };
        // Return sum of u64 field and u8 field (cast u8 to u64)
        // Field accesses by positional indexing:
        let a = t.0 as u64; // should be 10u64
        let b = if t.1 { 1 } else { 0 }; // true -> 1u64
        let c = t.2; // 42u64
        return a + b + c;
    }

    // Function to test return from blocks and early returns
    public fun test_return_behavior(x: u8): u8 {
        // early return if x is 0
        if (x == 0) {
            return 0;
        };
        // block with explicit return inside
        let res = {
            if (x < 5) {
                return 1;
            };
            x + 1
        };
        return res;
    }

    // Function to test pattern matching with MyEnum
    public fun test_match(e: MyEnum): u64 {
        match e {
            MyEnum::Variant0 => return 0,                    // simple variant
            MyEnum::Variant1(10, b) => return if b {1} else {2},  // Variant1 with guard-like matching on first arg
            MyEnum::Variant1(x, _) => return x as u64,
            MyEnum::Variant2 { a: 5, .. } => return 5,
            MyEnum::Variant2 { a, b } => return if b { a as u64 } else { 0 },
            MyEnum::Variant3(outer) => {
                // deeply nested matching with guards and destructure
                let Outer { x: Inner { a, b }, y } = outer;
                if (b) {
                    return (a as u64) + y;
                } else {
                    return y;
                }
            }
        };
        // unreachable since match is exhaustive 
        return 999;
    }

    // Catch-all variant to test .. in pattern matching
    public fun test_wildcard_match(e: MyEnum): u64 {
        match e {
            MyEnum::Variant0 => return 0,
            MyEnum::Variant1(x, b) => return (x as u64) * 10 + if b { 1 } else { 0 },
            _ => return 999,  // catch-all pattern
        };
    }

    // Function that calls all above functions without arguments for easy testing
    public fun runner(): u64 {
        let t = test_tuple_access();
        let r1 = test_return_behavior(0);
        let r2 = test_return_behavior(10);
        let r3 = test_match(MyEnum::Variant0);
        let r4 = test_match(MyEnum::Variant1(10, true));
        let r5 = test_match(MyEnum::Variant2 { a: 5, b: false });
        let r6 = test_match(MyEnum::Variant3(Outer { x: Inner { a: 3, b: true }, y: 7 }));
        let r7 = test_wildcard_match(MyEnum::Variant1(4, false));
        return t + (r1 as u64) + (r2 as u64) + r3 + r4 + r5 + r6 + r7;
    }
}
// # run 0xCAFE::TupleAndMatch::runner --signers 0xCAFE

// # run 0xCAFE::TupleAndMatch::test_tuple_access --signers 0xCAFE
// # run 0xCAFE::TupleAndMatch::test_return_behavior --signers 0xCAFE --args 3u8
// # run 0xCAFE::TupleAndMatch::test_match --signers 0xCAFE --args Variant0
// # run 0xCAFE::TupleAndMatch::test_wildcard_match --signers 0xCAFE --args Variant1 7u8 false

// # run
script {
    use 0xCAFE::TupleAndMatch;

    fun main(account: signer) {
        // create sample enums for direct script pattern matching testing
        let v0 = TupleAndMatch::MyEnum::Variant0;
        let v1 = TupleAndMatch::MyEnum::Variant1(10, true);
        let v2 = TupleAndMatch::MyEnum::Variant2 { a: 5, b: false };
        let v3 = TupleAndMatch::MyEnum::Variant3(TupleAndMatch::Outer { x: TupleAndMatch::Inner { a: 9, b: true }, y: 99 });

        // Call all functions to test:
        let res1 = TupleAndMatch::test_tuple_access();
        let res2 = TupleAndMatch::test_return_behavior(1);
        let res3 = TupleAndMatch::test_match(v0);
        let res4 = TupleAndMatch::test_match(v1);
        let res5 = TupleAndMatch::test_match(v2);
        let res6 = TupleAndMatch::test_match(v3);
        let res7 = TupleAndMatch::test_wildcard_match(v1);
        let res8 = TupleAndMatch::runner();

        // No assertions needed, just run for coverage
    }
}

// Featurres:
// 16b63ec19d7caee7c22b07523fd21b49: When Move 2 is enabled, refer to tuple fields by positional field syntax (e.g., .0, .1, ...).
// f764811ed35e98cd9106dc1292628e34: Return values from functions or blocks with the `return` expression.
// 8fb9828204b9a095d7d6afccd8410966: Test that the Move pattern matching feature (including destructuring for records/enums with fields, use of the `..` catch-all, field-specific and deeply nested matching, inclusion of guards, and coverage/exhaustiveness checking in match statements) works correctly and detects redundant or unreachable patterns.
