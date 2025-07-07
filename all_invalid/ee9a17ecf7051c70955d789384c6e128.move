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
        let S { a, _b } = s;
        // a and b can be used separately
        a
    }

    public inline fun runner(account: &signer) {
        let s = Self::make_s();
        let _a_val = Self::unpack_and_return_a(s);
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
        let MultiAbilityStruct { x, _y } = mas;
        // Use both fields
        x
    }

    public inline fun runner(account: &signer) {
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
        SpecIdTest::runner(&account);
        MultipleAbilitiesTest::runner(&account);
    }
}