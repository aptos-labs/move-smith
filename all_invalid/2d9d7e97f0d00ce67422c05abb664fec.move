
//# publish
module 0xCAFE::AddModule {
    use std::vector;

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 just to have some computation
        sum + 10
    }

    public fun lambda_example(x: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| { a + b };
        adder(x, 5u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun move_variable_example() {
        let v = vector::from_array<u8>(vector::empty<u8>() /* workaround empty vec */);
        // The original vector::from_array([1u8, 2u8, 3u8]) is invalid syntax.
        // Workaround: vector::from_array expects an array expression without brackets in Move,
        // but currently Move stdlib does not support from_array from literals, so create vector manually:

        // reuse vector from the literals directly by vector::empty and vector::push_back instead:
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 1u8);
        vector::push_back(&mut v, 2u8);
        vector::push_back(&mut v, 3u8);

        let moved_v = move v;
        // prevent unused variable warning by dummy access
        let _ = vector::length(&moved_v);
    }

    public fun trim_leading_spaces(s: vector<u8>): vector<u8> {
        let len = vector::length(&s);
        let start = 0u64;
        while (start < len && *vector::borrow(&s, start) == b' ') {
            start = start + 1;
        };
        vector::subvector(&s, start, len)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;
    use std::vector;

    public fun call_inline_and_lambda(a: u8, b: u8): (u8, u8) {
        let inline_res = AddModule::inline_add(a, b);
        let lambda_res = AddModule::lambda_example(inline_res);
        (inline_res, lambda_res)
    }

    public fun test_add_and_move(a: u8, b: u8) {
        let _ = AddModule::add_and_return_sum(a, b);
        AddModule::move_variable_example();
    }

    public fun test_trim_string() {
        let s = vector::from_bytes(b"    MoveLang Test");
        let trimmed = AddModule::trim_leading_spaces(s);
        // ignore assertion
    }
}



//# run 0xCAFE::AddModule::add_and_return_sum --args 3u8 4u8



//# run 0xCAFE::AddModule::lambda_example --args 6u8



//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 2u8 3u8



//# run 0xCAFE::CallerModule::test_add_and_move --args 7u8 8u8



//# run 0xCAFE::CallerModule::test_trim_string
