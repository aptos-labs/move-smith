//# publish
module 0xA11::FunctionApply {
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    public fun apply_twice(): u64 {
        // Compose nested function calls to test different operations
        apply(|a, b| a + b, 10, apply(|a, b| a * b, 3, 4))
    }

    public fun run_apply_twice(): u64 {
        apply_twice()
    }
}

//# run 0xA11::FunctionApply::run_apply_twice

//# publish
module 0xA11::GlobalResourceTest {
    use 0x1::signer;

    struct BoolRes has key, drop {
        value: bool
    }

    // Initialize by storing a boolean value at the caller's address
    public fun init(s: &signer, val: bool) {
        move_to(s, BoolRes { value: val });
    }

    // Retrieve the stored boolean value for a specific address
    public fun get_bool(addr: address): bool reads BoolRes {
        borrow_global<BoolRes>(addr).value
    }

    // Try to borrow a boolean from an uninitialized address (should fail)
    public fun get_uninitialized(addr: address): bool {
        borrow_global<BoolRes>(addr).value
    }
}

//# run --verbose --signers 0x1 -- 0xA11::GlobalResourceTest::init --args true

//# run --verbose --args @0x1 -- 0xA11::GlobalResourceTest::get_bool

//# run --verbose --args @0x2 -- 0xA11::GlobalResourceTest::get_uninitialized

//# publish
module 0xA11::TypeMismatchTest {
    use 0x1::signer;

    struct BoolRes has key, drop {
        value: bool
    }

    struct U64Res has key, drop {
        value: u64
    }

    // Store a boolean resource at an address
    public fun store_bool(s: &signer) {
        move_to(s, BoolRes { value: true });
    }

    // Store a u64 resource at an address
    public fun store_u64(s: &signer, v: u64) {
        move_to(s, U64Res { value: v });
    }

    // Borrow global with matching type (should succeed)
    public fun borrow_bool(addr: address): bool {
        borrow_global<BoolRes>(addr).value
    }

    // Borrow global with mismatched type (should fail)
    public fun borrow_u64_as_bool(addr: address): bool {
        borrow_global<U64Res>(addr).value
    }
}

//# run --verbose --signers 0x1 -- 0xA11::TypeMismatchTest::store_bool

//# run --verbose --signers 0x1 -- 0xA11::TypeMismatchTest::borrow_bool

//# run --verbose --signers 0x1 -- 0xA11::TypeMismatchTest::store_u64 --args 1234

//# run --verbose --args @0x1 -- 0xA11::TypeMismatchTest::borrow_u64_as_bool