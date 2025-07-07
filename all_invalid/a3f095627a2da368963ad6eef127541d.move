
//# publish
module 0xDEAD::NestedStructAccess {
    use std::vector;

    struct Inner has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        value: u32,
    }

    public fun create_outer(): Outer {
        let inner_struct = Inner {a: 10u8, b: 300u16};
        let outer_struct = Outer {inner: inner_struct, value: 1234u32};
        outer_struct
    }

    public fun get_nested_fields(o: &Outer): (u8, u16, u32) {
        let a = o.inner.a;
        let b = o.inner.b;
        let v = o.value;
        (a, b, v)
    }

    public fun set_nested_fields(o: &mut Outer, new_a: u8, new_b: u16, new_v: u32) {
        o.inner.a = new_a;
        o.inner.b = new_b;
        o.value = new_v;
    }
}



//# run 0xDEAD::NestedStructAccess::create_outer



//# run 0xDEAD::NestedStructAccess::get_nested_fields --args  --signers 0xOriginalOuterRef



//# run 0xDEAD::NestedStructAccess::set_nested_fields --args 20u8 400u16 5678u32 --signers 0xMutableOuterRef




//# publish
module 0xBADD::LoopVariableTests {
    use std::vector;

    // Function to test local variable shadowing in nested loops
    public fun shadowing_test(): u64 {
        let outer_var = 100u64;
        let res = 0u64;

        let i = 0u64;
        while (i < 3) {
            let outer_var = i; // shadowing outer_var locally
            let j = 0u64;
            while (j < 2) {
                let inner_var = outer_var + j; // inner scope
                res = res + inner_var;
                j = j + 1;
            };
            i = i + 1;
        };
        // after loops, outer_var refers to outer scope variable, unchanged
        outer_var + res
    }

    // Function to test variable assignment inside and outside while loop
    public fun assign_in_loop(): u64 {
        let sum = 0u64;
        let count = 0u64;
        let limit = 4u64;
        let temp_var = 0u64;

        while (count < limit) {
            let temp_var = count * 2; // local shadow
            sum = sum + temp_var;
            count = count + 1;
        };
        // temp_var outside the loop is the outer variable, unchanged
        sum + temp_var
    }
}



//# run 0xBADD::LoopVariableTests::shadowing_test



//# run 0xBADD::LoopVariableTests::assign_in_loop




//# publish
module 0xFACE::InternalFunctionAccess {
    use std::vector;

    // Internal function that should not be callable from outside
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Public function that calls internal function within the module
    public fun public_call(x: u8): u8 {
        internal_helper(x)
    }
    // No attempt to call internal_helper from outside is made, to confirm compile-time enforcement
}



//# run 0xFACE::InternalFunctionAccess::public_call --args 5u8




//# publish
module 0xFACE::MembersWithExplicitKinds {
    // Members with explicit kinds
    // Functions are public, constants are public, structs are public
    public const MAX_NUMBER: u16 = 65535;

    struct Data has copy, drop, store {
        id: u64,
        flag: bool,
    }

    public fun get_max_number(): u16 {
        Self::MAX_NUMBER
    }

    public fun create_data(id: u64, flag: bool): Data {
        Data {id, flag}
    }
}
