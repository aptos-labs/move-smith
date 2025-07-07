
//# publish
module 0xCAFE::Module1 {
    struct Struct3 has copy, drop, store {
        a: u64,
        b: u64,
        c: u64,
    }

    public fun function6(): Struct3 {
        let x = 10u64;
        let y = 20u64;
        let z = 30u64;

        // Destructuring assignment with tuple on left side
        let (mut a, mut b, mut c) = (x, y, z);
        // Update fields with sum of variables and new values
        let sum = a + b + c;
        a = a + 1;
        b = b + 2;
        c = c + 3;
        let result = Struct3 {a, b, c};

        let _total = sum + a + b + c;

        result
    }
}


//# run 0xCAFE::Module1::function6


// Featurres:
// 8caca15c3b2214b4ef4a6f569aadbdba: Test that calling 0xCAFE::Module1::function6 successfully returns a Struct3 with the specified field values.
// 65956de78413f8034788b30e292edc4e: Declare and use variable bindings in destructuring assignments on the left-hand side of a Move assignment
// 465eefaa6e81bf15308d01b6a6fa82e8: Test that local variable declaration, initialization, and summation work correctly within a function.
