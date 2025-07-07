//# publish
module 0xCAFE::ReturnTest {
    public fun returns_u64(): u64 {
        return 42;
    }

    public fun returns_bool(): bool {
        return true;
    }

    public fun returns_string(): vector<u8> {
        let s: vector<u8> = b"hello";
        return s;
    }

    /// Runner function to exercise the returners
    public fun runner(): bool {
        let a: u64 = returns_u64();
        let b: bool = returns_bool();
        let c: vector<u8> = returns_string();
        // Returning b here; just to return something of bool type
        return b;
    }
}
//# run 0xCAFE::ReturnTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::ReturnTest;

    fun main() {
        let x: u64 = ReturnTest::returns_u64();
        let y: bool = ReturnTest::returns_bool();
        let z: vector<u8> = ReturnTest::returns_string();
        // no asserts needed
        return;
    }
}

// Featurres:
// e9b82231f5622596a9761b21cb5fbf98: Verify that a compiled Move module passes bytecode verification successfully.
// 4583f06af25db807e45322b7f49143fc: Set the return type of a function using a colon and type annotation.
// afb0a1624dc5f2c0b230db31bd6c92a1: Return values from functions using the 'return' keyword, optionally with an expression to return a value.
