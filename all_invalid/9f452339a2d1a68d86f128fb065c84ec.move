//# publish
module 0xCAFE::SpecIdTest {
    struct S has copy, drop, store, key {
        a: u8,
        b: u16
    }

    public fun make_s(): S {
        let s = S { a: 42u8, b: 1000u16 };
        s
    }

    public fun unpack_and_return_a(s: S): u8 {
        let S { a, b } = s;
        // a and b can be used separately
        a
    }

    public inline fun runner() {
        let s = Self::make_s();
        let a_val = Self::unpack_and_return_a(s);
        // no assert needed
    }
}
//# run 0xCAFE::SpecIdTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::MultipleAbilitiesTest {
    // Struct with multiple abilities declared as comma-separated list
    struct MultiAbilityStruct has store, copy, drop, key {
        x: u64,
        y: bool,
    }

    public fun new_struct(): MultiAbilityStruct {
        MultiAbilityStruct { x: 123u64, y: true }
    }

    public fun unpack_example(mas: MultiAbilityStruct): u64 {
        let MultiAbilityStruct { x, y } = mas;
        // Use both fields
        x
    }

    public inline fun runner() {
        let mas = Self::new_struct();
        let _ = Self::unpack_example(mas);
    }
}
//# run 0xCAFE::MultipleAbilitiesTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::SpecIdTest;
    use 0xCAFE::MultipleAbilitiesTest;

    fun main(account: signer) {
        // Call runner functions from both modules to thoroughly exercise compiler and VM
        SpecIdTest::runner();
        MultipleAbilitiesTest::runner();
    }
}

// Featurres:
// c50322efa66d5a827bf3371f8bffc792: Define and use specific identifiers (such as variable or function names) in Move code.
// 7d2f36c5f74800a3dae2a3d414aadf47: Unpack structs into fields on the left-hand side of an assignment.
// 949da64cd2f6ac426e454f9d89ed0665: Declare multiple abilities sequentially after the 'has' keyword, allowing for a comma-separated list.
