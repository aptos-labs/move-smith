//# publish
module 0xCAFE::LambdaTest {
    // Struct with explicit field signatures and names
    struct Data {
        a: u64,
        b: bool,
        v: vector<u8>,
    }

    // Struct with only copy/drop, not store/key, to test abilities
    struct Small copy, drop {
        x: u8,
    }

    // Returns a vector literal without specifying the type argument (should be inferred to vector<u8>)
    public fun get_vec1(): vector<u8> {
        // Vector literal without type argument
        let v = b"test";
        v
    }

    // Returns a vector literal with explicit type argument
    public fun get_vec2(): vector<u64> {
        let v = vector<u64>[1, 2, 3, 4];
        v
    }

    // Helper function to apply a vector of functions to a value and sum
    public fun eval(fs: vector<fn(u64): u64>, input: u64): u64 {
        let acc = 0u64;
        let n = Vector::length(&fs);
        let i = 0;
        let sum = loop {
            if (i == n) break acc;
            let fun = *Vector::borrow(&fs, i);
            let res = fun(input);
            acc = acc + res;
            i = i + 1;
        };
        sum
    }

    // Functions to use as elements of vector<fn(u64): u64>
    public fun add1(x: u64): u64 { x + 1 }
    public fun mul2(x: u64): u64 { 2 * x }
    public fun sub3(x: u64): u64 { x - 3 }

    // Test runner: constructs data, checks struct with designated field names, and exercises everything
    public fun runner() {
        // Explicit struct field assignments
        let d = Data { a: 42, b: true, v: b"bytes" };

        // Use vector literal without explicit type argument
        let v1 = get_vec1();

        // Use vector literal with explicit type argument
        let v2 = get_vec2();

        // Compose a vector of function pointers and pass to eval
        let funs = vector [Self::add1, Self::mul2, Self::sub3];
        // Evaluate: result should be add1(10) + mul2(10) + sub3(10) = 11 + 20 + 7 = 38
        let s = eval(funs, 10);

        // Use dummy to avoid lint
        let _ = (copy d.a, copy d.b, &d.v, &v1, &v2, s);

        // Small struct test with designated field signature
        let sx = Small { x: 9 };
        let _ = sx.x;
    }
}

//# run 0xCAFE::LambdaTest::runner --signers 0xCAFE

//# run
script {
    fun main() {
        // At least run a basic test of vector/array literals in a script context too

        let v1 = b"hello";
        let v2 = vector<u16>[100, 200, 300];
        let v3 = vector[1u8, 2u8, 3u8]; // type argument inferred

        let _ = (v1, v2, v3);
    }
}

// Featurres:
// d139b53871f4a67fd9722cb7af8e5085: Use vector/array literals with or without type arguments.
// 1f8caf0229b4f4e45239ffff6f3cba57: Test that the `eval` function correctly computes the sum of applying the generated vector of functions to the input argument.
// 242e7882aa1263866d1af91f1f1e6e5a: Specify struct fields with designated signatures and names.
