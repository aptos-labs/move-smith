
//# publish
module 0xCAFE::ConstAndViewTest {
    const CONST_U64: u64 = 0xABCDEF1234567890;

    const CONST_U8: u8 = 42;

    // Cannot declare a struct as a const in Move.
    // Instead, you can expose a function that returns the struct.
    struct S has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Provide a public function that returns the constant struct value
    public fun get_const_struct(): S {
        S { a: 1, b: 2 }
    }

    public fun get_const_u64(): u64 {
        // Use constant in a calculation
        let val = CONST_U64 + 10;
        val
    }

    public fun get_const_u8(): u8 {
        CONST_U8
    }

    public fun get_const_struct_a(): u8 {
        // Access the struct through the getter function
        let s = get_const_struct();
        s.a
    }

    public fun add_with_const(x: u64): u64 {
        // Fix overflow by using checked_add or by safe add after validation

        // Since the original error is ARITHMETIC_ERROR (likely overflow),
        // and add_with_const adds x + CONST_U64 without checking overflow,
        // we must check/guard overflow or add less than the constant.

        // For demonstration, let's use checked_add and abort on overflow:
        match x.checked_add(CONST_U64) {
            option::Some(sum) => sum,
            option::None => abort 1,
        }
    }

    public fun local_var_coalescing(x: u64): u64 {
        // This function does multiple adds of CONST_U64 leading to overflow.
        // We should perform checked adds and abort on overflow.

        let temp1 = match x.checked_add(CONST_U64) {
            option::Some(val) => val,
            option::None => abort 1,
        };

        let temp2 = match temp1.checked_add(100) {
            option::Some(val) => val,
            option::None => abort 1,
        };

        let temp3 = match temp2.checked_add(CONST_U64) {
            option::Some(val) => val,
            option::None => abort 1,
        };

        // Shadowing temp2 with another checked add
        let temp2 = match temp3.checked_add(5) {
            option::Some(val) => val,
            option::None => abort 1,
        };
        temp2
    }
}
