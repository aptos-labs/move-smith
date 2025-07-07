module 0x1::TestCompilerVM {

    // 1. Define a public function within a module
    public fun add_u64(a: u64, b: u64): u64 {
        a + b
    }

    // 1. Define a module-private function
    fun mul_u64(a: u64, b: u64): u64 {
        a * b
    }

    // 2. Spec function with a return type specified after colon
    spec fun sum_spec(a: u64, b: u64): u64 {
        a + b
    }

    // 3. Function definition with uninterpreted flag, signature, and body
    #[uninterpreted]
    public fun uninterpreted_add(a: u64, b: u64): u64 {
        a + b
    }

    #[uninterpreted]
    fun uninterpreted_mul(a: u64, b: u64): u64 {
        a * b
    }

    #[test_only]
    public fun test_compiler_vm_features() {
        let x = 10;
        let y = 20;

        // Test public function `add_u64`
        let sum = add_u64(x, y);
        assert!(sum == 30, 1);

        // Test module-private function `mul_u64`
        let product = mul_u64(x, y);
        assert!(product == 200, 2);

        // Test spec function by checking that it computes the sum correctly:
        // Since spec functions can't be called at runtime, we use `assert` on equivalent expressions
        assert!(sum == sum_spec(x, y), 3);

        // Test public uninterpreted function
        let un_sum = uninterpreted_add(x, y);
        assert!(un_sum == 30, 4);

        // Test module-private uninterpreted function
        let un_product = uninterpreted_mul(x, y);
        assert!(un_product == 200, 5);
    }
}

// Featurres:
// a4b807ac0a99854fe42c1614ea55c58a: Define public or module functions within a module.
// ba65b0a21cd5b5515b25dcf742939b68: Specify the return type of a spec function after a colon.
// 280bad96f6189f5aefbd80defb4ac1a8: Create function definitions with names, uninterpreted flags, signatures, and bodies.
