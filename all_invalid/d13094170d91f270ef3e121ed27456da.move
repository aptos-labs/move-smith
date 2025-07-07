
//# publish
module 0xCAFE::FeatureTests {
    use std::vector;
    use std::signer;

    struct NoCopyDrop has store {
        val: u64,
    }

    struct HasCopyDrop has copy, drop, store {
        val: u64,
    }

    struct NestedStruct has copy, drop, store {
        inner: HasCopyDrop,
        flag: bool,
    }

    public fun make_no_copy_drop(val: u64): NoCopyDrop {
        NoCopyDrop { val }
    }

    public fun make_has_copy_drop(val: u64): HasCopyDrop {
        HasCopyDrop { val }
    }

    public fun make_nested_struct(val: u64, flag: bool): NestedStruct {
        let inner = make_has_copy_drop(val);
        NestedStruct { inner, flag }
    }

    public fun test_control_flow(cond: bool): u64 {
        let res = 0u64;
        if (cond) {
            res = 1u64;
        } else {
            res = 2u64;
        };
        let i = 0u64;
        let end = 3u64;
        while (i < end) {
            res = res + i;
            i = i + 1;
        };
        for (j in 0..2) {
            res = res + j;
        };
        loop {
            if (res > 100) {
                break;
            };
            res = res + 10;
        };
        res
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        adder(x, y)
    }

    public fun use_lambda_with_capture(x: u8): u8 {
        let add_x: |u8| u8 has copy+drop = |b: u8| { b + x };
        add_x(10u8)
    }

    struct GenericStruct<T> has copy, drop {
        field: T,
    }

    public fun generic_struct_usage<T: copy + drop>(val: T): GenericStruct<T> {
        GenericStruct { field: val }
    }

    enum E has copy, drop {
        Empty,
        Single(u8),
        Pair(u8, u8),
        Named { flag: bool },
    }

    public fun match_enum(e: E): u8 {
        match e {
            E::Empty => 0,
            E::Single(val) => val,
            E::Pair(a, b) => a + b,
            E::Named { flag } => if (flag) { 1 } else { 2 },
        }
    }

    public fun vector_ops(): vector<u64> {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 10u64);
        vector::push_back(&mut v, 20u64);
        let _first = *vector::borrow(&v, 0);
        let _second = *vector::borrow(&v, 1);
        vector::pop_back(&mut v);
        v
    }

    public fun move_and_copy(signer: signer) {
        let obj = HasCopyDrop { val: 42u64 };
        move_to<HasCopyDrop>(&signer, obj);
        let copy_obj = copy borrow_global<HasCopyDrop>(signer::address_of(&signer));
        let mut_ref = borrow_global_mut<HasCopyDrop>(signer::address_of(&signer));
        mut_ref.val = mut_ref.val + 1;
        let moved_obj = move_from<HasCopyDrop>(signer::address_of(&signer));
        let _val = moved_obj.val;
    }

    // Runner function with no arguments
    public fun runner() {
        let _ = test_control_flow(true);
        let _ = use_lambda(3u8, 4u8);
        let _ = use_lambda_with_capture(5u8);
        let gs = generic_struct_usage<u8>(7u8);
        let enum_val = E::Pair(8u8, 9u8);
        let _res = match_enum(enum_val);
        let _vec = vector_ops();
    }
}



//# run 0xCAFE::FeatureTests::runner



//# run 0xCAFE::FeatureTests::make_no_copy_drop --args 123u64



//# run 0xCAFE::FeatureTests::make_has_copy_drop --args 456u64



//# run 0xCAFE::FeatureTests::make_nested_struct --args 789u64 true



//# run 0xCAFE::FeatureTests::match_enum --args 0u8



//# run 0xCAFE::FeatureTests::match_enum --args 1u8



//# run 0xCAFE::FeatureTests::match_enum --args 2u8



//# run 0xCAFE::FeatureTests::match_enum --args 3u8



//# run 0xCAFE::FeatureTests::move_and_copy --signers 0xDEAD
