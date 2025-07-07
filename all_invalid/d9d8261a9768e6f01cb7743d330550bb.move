//# publish
module 0xCAFE::AbortTest {
    // A function that aborts with a given code.
    public fun abort_with_code(code: u64) {
        abort code;
    }

    // Simple runner to call abort_with_code with a fixed code.
    public fun run_abort() {
        abort_with_code(42);
    }
}
//# run 0xCAFE::AbortTest::run_abort --signers 0xCAFE

//# publish
module 0xCAFE::ComplexStructs {
    // A struct with attributes, abilities, and layout annotation.
    #[derive(copy, drop, store)]
    struct MyStruct has store, drop, copy {
        a: u8,
        b: u64,
        c: u8, // Use concrete u8 to avoid generic param which was unsupported
    }

    #[derive(copy, drop, store)]
    struct AnotherStruct has store, drop, copy {
        inner: MyStruct,  // nested struct with concrete param
        flag: bool,
    }

    // Runner function to instantiate and use the structs.
    public fun run_structs() {
        let s: MyStruct = MyStruct { a: 1, b: 100, c: 255 };
        let as_ = AnotherStruct { inner: s, flag: true };
        // Just a no-op use to keep compiler happy.
        let _x = as_.flag;
    }
}
//# run 0xCAFE::ComplexStructs::run_structs --signers 0xCAFE

//# publish
module 0xCAFE::MultiArgFunctions {
    // Function that takes multiple arguments of different types and returns a u64.
    public fun mix_args(x: u8, y: u64, z: bool): u64 {
        let base = (x as u64) + y;
        if (z) {
            base * 2
        } else {
            base / 2
        }
    }

    // Runner function that calls mix_args with some arguments.
    public fun run_mix_args() {
        let res_true = mix_args(10, 1000, true);
        let res_false = mix_args(10, 1000, false);
        // Use res_true and res_false to avoid warnings.
        let _sum = res_true + res_false;
    }
}
//# run 0xCAFE::MultiArgFunctions::run_mix_args --signers 0xCAFE

//# run
script {
    use 0xCAFE::AbortTest;
    use 0xCAFE::ComplexStructs;
    use 0xCAFE::MultiArgFunctions;

    fun main() {
        // Call abort_with_code directly with a small code to test abort in script.
        AbortTest::abort_with_code(1);

        // Construct structs manually here (to test inline usage with type parameters)
        let s: ComplexStructs::MyStruct = ComplexStructs::MyStruct { a: 5, b: 15, c: 42 };
        let as_ = ComplexStructs::AnotherStruct { inner: s, flag: false };
        let _ = as_.flag;

        // Call mix_args function
        let _ = MultiArgFunctions::mix_args(7, 14, true);
    }
}