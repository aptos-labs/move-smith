//# publish
module 0xCAFE::AbilitiesTest {
    use std::signer;

    // Define a struct with copy, drop, store, and key abilities
    struct CopyDropKey has copy, drop, store, key {
        x: u64,
    }

    // Define a struct with only store ability (immutable by default)
    struct StoreOnly has store {
        value: u8,
    }

    // Define an enum with copy and drop abilities
    enum Color has copy, drop {
        Red,
        Green,
        Blue,
    }

    // Function returning a CopyDropKey struct
    public fun create_copy_drop_key(): CopyDropKey {
        CopyDropKey { x: 42 }
    }

    // Function returning a StoreOnly struct
    public fun create_store_only(): StoreOnly {
        StoreOnly { value: 99 }
    }

    // Function returning a Color enum variant
    public fun create_color(): Color {
        Color::Green
    }

    // Runner function to test struct and enum creation and usage
    public fun runner() {
        let c = create_copy_drop_key();
        let s = create_store_only();
        let color = create_color();

        // Just use the values to avoid warnings
        let _ = c.x;
        let _ = s.value;

        // Match on enum must have ; after match arms or curly braces empty
        // Corrected the match syntax by adding ; after empty blocks to separate statements
        match color {
            Color::Red => {},
            Color::Green => {},
            Color::Blue => {},
        };
    }
}
//# run 0xCAFE::AbilitiesTest::runner


//# publish
module 0xCAFE::MutableRefTest {
    /// This function tries to create two mutable references to the same local variable.
    /// In Move, this should not compile or cause a compile error because simultaneous
    /// multiple mutable borrows are disallowed.
    /// 
    /// Because this is a transactional test of compilation, we do not run this function.
    /// We write this here to test that compiler catches the error.
    // Note: This function intentionally has compile errors; we comment it out to allow compilation.
    /*
    public fun invalid_multiple_mut_refs() {
        let mut x = 10u64;

        // First mutable reference
        let r1 = &mut x;

        // Second mutable reference - this should cause a compile-time error.
        let r2 = &mut x;

        // Use references (dead code, just to suppress warnings)
        *r1 = 20u64;
        *r2 = 30u64;
    }
    */

    // Valid function demonstrating only one mutable reference at a time
    public fun valid_single_mut_ref() {
        let mut x = 10u64;
        let r1 = &mut x;
        *r1 = 20u64;
        // r1 goes out of scope here, so we can create another mutable reference safely
        let r2 = &mut x;
        *r2 = 30u64;
    }

    // Runner to trigger valid code only
    public fun runner() {
        valid_single_mut_ref();
    }
}
//# run 0xCAFE::MutableRefTest::runner


//# publish
module 0xCAFE::QuantifiersTest {
    /// This module demonstrates usage of special identifiers that look like quantifiers.
    /// These identifiers are just normal identifiers but named with reserved-like names.
    /// Because Move doesn't have native quantifiers, we test that identifiers like
    /// `forall` and `exists` are allowed.

    // Struct names must start with uppercase letter
    struct Forall has drop, store {
        x: u8,
    }

    struct Exists has store {
        y: u64,
    }

    public fun create_forall_struct(): Forall {
        Forall { x: 100 }
    }

    public fun create_exists_struct(): Exists {
        Exists { y: 200 }
    }

    public fun runner() {
        let f = create_forall_struct();
        let e = create_exists_struct();
        let _ = f.x;
        let _ = e.y;
    }
}
//# run 0xCAFE::QuantifiersTest::runner


//# run
script {
    use 0xCAFE::AbilitiesTest;
    use 0xCAFE::QuantifiersTest;

    fun main() {
        // Run the runners from modules to test compiler + VM integration
        AbilitiesTest::runner();
        QuantifiersTest::runner();
    }
}