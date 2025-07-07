
//# publish
module 0xCAFE::EncapsulationTest {
    use std::vector;

    // Protected struct with no public fields, only accessible via functions here
    struct ProtectedS has key, store {
        a: u8,
        b: bool,
    }

    // Protected enum with variants
    enum ProtectedE has copy, drop {
        A,
        B(u8),
        C { flag: bool }
    }

    // Struct with function pointer field (closure)
    struct FnHolder has store, key {
        f: |u8| u8,
    }

    // Struct embedding closure inside protected struct
    struct NestedClosure has store, key {
        inner: ProtectedS,
        callback: |u8| u8,
    }

    // Constants and registry
    struct ConstRegistry has key, store {
        registered: vector<u64>,
    }

    const MAX_CONSTS: u64 = 10;
    const DUPLICATE_ERROR_CODE: u64 = 404;

    // PUBLIC FUNCTION to create ProtectedS
    public fun create_protected_s(a: u8, b: bool): ProtectedS {
        ProtectedS { a, b }
    }

    // PUBLIC FUNCTION to create ProtectedE variant B
    public fun create_protected_e_b(x: u8): ProtectedE {
        ProtectedE::B(x)
    }

    // PUBLIC FUNCTION to create FnHolder with identity lambda
    public fun create_fn_holder(): FnHolder {
        let id = |x: u8| x;
        FnHolder { f: id }
    }

    // PUBLIC FUNCTION to create NestedClosure with inner ProtectedS and a lambda that adds 1
    public fun create_nested_closure(a: u8, b: bool): NestedClosure {
        let inner = ProtectedS { a, b };
        let lambda = |x: u8| x + 1;
        NestedClosure { inner, callback: lambda }
    }

    // PUBLIC FUNCTION to call FnHolder.f on input
    public fun call_fn_holder(fh: &FnHolder, x: u8): u8 {
        (fh.f)(x)
    }

    // PUBLIC FUNCTION to call NestedClosure.callback on input
    public fun call_nested_callback(nc: &NestedClosure, x: u8): u8 {
        (nc.callback)(x)
    }

    // Create a new ConstRegistry with empty vector
    public fun new_registry(): ConstRegistry {
        ConstRegistry { registered: vector::empty<u64>() }
    }

    // PUBLIC FUNCTION to add constant to registry; aborts on duplicate
    public fun add_constant(reg: &mut ConstRegistry, c: u64) {
        let len = vector::length(&reg.registered);
        assert!(len < MAX_CONSTS, 1001);
        let i = 0;
        while (i < len) {
            let val = *vector::borrow(&reg.registered, i);
            assert!(val != c, DUPLICATE_ERROR_CODE);
            i = i + 1;
        };
        vector::push_back(&mut reg.registered, c);
    }

    // PUBLIC FUNCTION to return registered vector length
    public fun registry_length(reg: &ConstRegistry): u64 {
        vector::length(&reg.registered) as u64
    }

    // EXAMPLES THAT MUST FAIL TO COMPILE (described as comments because we cannot run them)
    /*
      External module cannot:
      - directly access fields of ProtectedS or ProtectedE variants by pattern unpacking
      - unpack FnHolder.f field directly
      - unpack NestedClosure.* fields directly
    */
}



//# run
script {
    use 0xCAFE::EncapsulationTest;

    fun main() {
        // 1. Create ProtectedS and ProtectedE instances via public functions
        let ps = EncapsulationTest::create_protected_s(10u8, true);
        let pe = EncapsulationTest::create_protected_e_b(7u8);

        // 2. Create FnHolder with identity lambda and call it
        let fh = EncapsulationTest::create_fn_holder();
        let r1 = EncapsulationTest::call_fn_holder(&fh, 42u8);

        // 3. Create NestedClosure and call callback
        let nc = EncapsulationTest::create_nested_closure(5u8, false);
        let r2 = EncapsulationTest::call_nested_callback(&nc, 10u8);

        // 4. Create constant registry and add constants
        let reg = EncapsulationTest::new_registry();
        EncapsulationTest::add_constant(&mut reg, 100u64);
        EncapsulationTest::add_constant(&mut reg, 200u64);

        // 5. Attempt to add duplicate constant - expect abort with code 404
        // Uncommenting below line would abort:
        // EncapsulationTest::add_constant(&mut reg, 100u64);

        // 6. Length of registry
        let len = EncapsulationTest::registry_length(&reg);

        // Use results to avoid warnings
        let _ = (ps, pe, r1, r2, len);
    }
}
