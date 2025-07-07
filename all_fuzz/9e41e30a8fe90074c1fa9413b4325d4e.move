
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let _sum = a + b;
        // ignore sum, just return 42 to test basic computation before return
        42u8
    }
}



//# run 0xCAFE::TestAddition::add_and_return_42 --args 10u8 32u8



//# publish
module 0xCAFE::TestLambda {
    public fun call_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        lambda(a, b)
    }

    public fun call_lambda_inline_once() {
        let f: |u8| u8 has copy+drop = |c: u8| {
            c + 1
        };
        let _r = f(5u8);
    }
}



//# run 0xCAFE::TestLambda::call_lambda --args 3u8 4u8



//# run 0xCAFE::TestLambda::call_lambda_inline_once



//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestLambda;

    public inline fun inline_identity(u: u16): u16 {
        u
    }

    public fun nested_call(u: u16): u16 {
        let v = inline_identity(u);
        let (sum, _) = TestLambda::call_lambda(1u8, 2u8);
        // fixed incorrect cast sequence by adding parentheses
        ((v as u8) + sum) as u16
    }
}



//# run 0xCAFE::TestInlineCall::nested_call --args 10u16



//# publish
module 0xCAFE::TestVectorMut {
    use std::vector;

    public fun init_vec(len: u8): vector<u8> {
        let v = vector::empty<u8>();
        let i = 0u8;
        while (i < len) {
            vector::push_back(&mut v, i);
            i = i + 1;
        };
        v
    }

    public fun set_all_to(v: &mut vector<u8>, val: u8) {
        let i = 0u64;
        while (i < (vector::length(v) as u64)) {
            // replace `usize` with `u64` and then cast to `u64` then to `u64` (index should be usize, so cast to u64 then to u64)
            // actually `vector::borrow_mut` takes usize as index, so we must cast i (u64) to u64, then to usize properly.
            // But Aptos Move doesn't have a `usize` type, index is usize which is an alias. We must use `u64` or `u8` depending on platform
            // The right fix is to cast to `u64` then to `u64` (index type is usize, which is an alias for `u64` in Aptos Move?).
            // Simplify: cast `i` from u64 to `u64` and then to `u64` is redundant. Instead cast `i` from u64 to u64 usize by `i as u64`
            *vector::borrow_mut(v, (i as u64) as u64) = val;
            i = i + 1;
        };
    }
}


//# run 0xCAFE::TestVectorMut::init_vec --args 5u8



//# run --signers 0x1
script {
    use 0xCAFE::TestVectorMut;

    fun main() {
        let v = TestVectorMut::init_vec(5u8);
        TestVectorMut::set_all_to(&mut v, 99u8);
    }
}



//# publish
module 0xCAFE::TestMutateFields {
    struct Data has store {
        a: u8,
        b: u8,
    }

    public fun make_data(a: u8, b: u8): Data {
        Data {a, b}
    }

    public fun mutate_fields(d: &mut Data, new_a: u8, new_b: u8) {
        d.a = new_a;
        d.b = new_b;
    }

    public fun mutate_with_shadow(mut_a: u8, mut_b: u8): Data {
        let mutated = make_data(mut_a, mut_b);
        mutated.a = mut_a + 1;
        mutated.b = mut_b + 1;
        mutated
    }
}



//# run 0xCAFE::TestMutateFields::mutate_fields --args 11u8 22u8



//# run 0xCAFE::TestMutateFields::mutate_with_shadow --args 11u8 22u8
