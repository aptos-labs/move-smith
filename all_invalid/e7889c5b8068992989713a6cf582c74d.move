//# publish
module 0xCAFE::CastAndFreeze {
    use std::signer;
    use std::vector;

    struct Container has store {
        value: u64,
    }

    public fun test_cast_exprs(): u64 {
        let a = 10u8;
        let b = 20u16;
        let c = 30u32;

        // cast u8 to u64 and add
        let sum1: u64 = a as u64 + 100u64;

        // cast u16 to u64 then add
        let sum2: u64 = b as u64 + sum1;

        // cast u32 to u64 then add
        let sum3: u64 = c as u64 + sum2;

        sum3
    }

    public fun several_entries_override(): u64 {
        // Let x is assigned multiple times; last value used
        let x: u64 = 1u64;
        let x = 2u64;
        let x = 3u64;
        let x = 4u64;
        x
    }

    public fun test_freezing_in_var(): u64 {
        let mut x = 42u64;
        let mut_ref: &mut u64 = &mut x;
        // freeze mutable reference to immutable reference
        let immut_ref: &u64 = mut_ref;
        *immut_ref
    }

    public fun test_freezing_in_call(x: &mut u64): u64 {
        // freezing mutable ref as immutable ref in param
        helper_freeze(x)
    }

    fun helper_freeze(r: &u64): u64 {
        *r
    }

    public fun test_freezing_in_assignment(): u64 {
        let mut x = 10u64;
        let mut_ref: &mut u64 = &mut x;

        let immut_ref: &u64 = mut_ref;
        *immut_ref
    }

    public fun test_freezing_in_conditional(cond: bool): u64 {
        let mut x = 0u64;
        let mut_ref: &mut u64 = &mut x;

        let immut_ref: &u64;
        if cond {
            immut_ref = mut_ref;
        } else {
            immut_ref = mut_ref;
        }
        *immut_ref
    }

    public fun test_freezing_in_borrow(s: &signer): u64 {
        let obj = Container { value: 123u64 };
        move_to<Container>(s, obj);

        let mut_ref: &mut Container = borrow_global_mut<Container>(signer::address_of(s));
        let immut_ref: &Container = mut_ref;
        let val = immut_ref.value;

        // Clean up
        let _moved_obj = move_from<Container>(signer::address_of(s));
        val
    }
}

//# run 0xCAFE::CastAndFreeze::test_cast_exprs

//# run 0xCAFE::CastAndFreeze::several_entries_override

//# run 0xCAFE::CastAndFreeze::test_freezing_in_var

//# run 0xCAFE::CastAndFreeze::test_freezing_in_call --args 42u64

//# run 0xCAFE::CastAndFreeze::test_freezing_in_assignment

//# run 0xCAFE::CastAndFreeze::test_freezing_in_conditional --args true

//# run 0xCAFE::CastAndFreeze::test_freezing_in_conditional --args false

//# run 0xCAFE::CastAndFreeze::test_freezing_in_borrow --signers 0xBEEF