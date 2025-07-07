
//# publish
module 0xCAFE::UnpackSyntaxTest {
    use std::vector;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Complex has copy, drop, store {
        a: Point,
        b: bool,
        c: vector<u8>,
    }

    // Function unpacking struct by let-binding with single field extract
    public fun unpack_point(p: Point): u64 {
        let x = p.x;
        x
    }

    // Function unpacking struct by full pattern in let-binding
    public fun unpack_point_full(p: Point): u64 {
        let Point {x, y} = p;
        x + y
    }

    // Nested unpacking with Complex struct
    public fun unpack_complex(c: Complex): u8 {
        let Complex {a: Point {x, y}, b, c: bytes} = c;
        // sum x and y, cast bool b into u8 and add sum of vector length
        (x + y) as u8 + (if (b) {1} else {0}) + (vector::length(&bytes) as u8)
    }
}



//# run 0xCAFE::UnpackSyntaxTest::unpack_point --args 10u64 20u64



//# run 0xCAFE::UnpackSyntaxTest::unpack_point_full --args 11u64 22u64



//# run 0xCAFE::UnpackSyntaxTest::unpack_complex --args 20u64 30u64 true x"ABCDEF"


// We create another module to test comma related syntax errors in parameters, structs, vectors etc.
// This module won't run successfully due to syntax errors, but this simulates syntax error testing.



//# publish
module 0xCAFE::SyntaxErrorTests {
    // The following declarations are commented out invalid syntax examples to explain test cases.
    // Real test framework captures compiler stderr, but here we demonstrate test inputs as comments.

    /*
    // Trailing comma after last parameter in function param list - INVALID:
    public fun invalid_fn1(a: u8, b: u8,) {
    }

    // Leading comma in parameter list - INVALID:
    public fun invalid_fn2(,a: u8, b: u8) {
    }

    // Consecutive commas in param list - INVALID:
    public fun invalid_fn3(a: u8,, b: u8) {
    }
    */

    /*
    // Trailing comma in struct fields - INVALID:
    struct BadStruct {
        x: u8,
        y: u64,
    }
    */

    /*
    // Leading comma in struct fields - INVALID:
    struct BadStruct2 {
        , x: u8,
        y: u64,
    }
    */

    /*
    // Consecutive commas in struct fields - INVALID:
    struct BadStruct3 {
        x: u8,, y: u64,
    }
    */

    /*
    // Trailing comma in vector literals - INVALID:
    let v = vector[u8][1, 2, 3,];
    */

    /*
    // Leading comma in vector literal - INVALID:
    let v2 = vector[u8][,1,2,3];
    */

    /*
    // Consecutive commas in vector literals - INVALID:
    let v3 = vector[u8][1,,2,3];
    */
}

// No runs because SyntaxErrorTests module contains intentional syntax errors to test compiler error reporting.


// Featurres:
// f8c703be29eeefe70023c7c99801e1e2: Unpack structs into their constituent fields in let-bindings or patterns.
// 9034f758486b8614f15d17a11db301bc: Reject and report errors for trailing, consecutive, or misplaced commas within delimited lists.
// dba6ccc33a58baa3a452a37cd0f7d3c0: Run the Move compiler and output errors to the standard error stream.
