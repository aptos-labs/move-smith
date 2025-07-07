// # publish
module 0xCAFE::TestModule {
    // Struct with copy and store/ key abilities allowing it to be stored and copied
    struct S has copy, drop, store, key {
        a: u64,
        b: u64,
    }

    /// create a new instance of S
    public fun new(a: u64, b: u64): S {
        S { a, b }
    }

    /// This function tests unpacking structs into variables (LHS unpacking),
    /// sequential assignments and uses the updated value in an arithmetic op,
    /// and also tests optional type arguments usage for the generic option type.
    /// It returns a u64 result for verification (though no assertion needed).
    public fun runner(): u64 {
        // create struct
        let s = new(10, 20);

        // unpack struct into separate variables a and b
        let S { a, b } = s;

        // sequential assignment:
        // new_a = a + 1
        // new_b = b + new_a
        // then sum them to return
        let a = a + 1;
        let b = b + a;

        let sum = a + b;

        // using optional type args in an Option:
        // Create Some<u8> = 7u8
        let some_val = Option<u8>::some(7);

        // The Option module is native but using explicit type args here to test optional type arguments parsing.
        // We don't do anything with some_val, just create it to test feature #2.

        sum
    }
}
// # run 0xCAFE::TestModule::runner

// # run
script {
    use 0xCAFE::TestModule;

    fun main() {
        let res = TestModule::runner();
        // no assertion needed, just exercise the VM & compiler.
        // This will test all the requested features.
    }
}

// Featurres:
// 7d2f36c5f74800a3dae2a3d414aadf47: Unpack structs into fields on the left-hand side of an assignment.
// eb0c30d054b7bc67ebc619af804b2b17: Provide optional type arguments in generic type or function invocations using angle brackets (<...>)
// f5d85ae3cb5ae9c572071bd106e8a755: Test that the Move function correctly performs sequential assignments and uses the updated value in an arithmetic operation.
