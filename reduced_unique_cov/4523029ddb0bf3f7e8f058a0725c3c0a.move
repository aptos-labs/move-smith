
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let constant_result = 42u8;
        sum + 0u8; // use sum to test variable assignment
        constant_result
    }

    public fun lambda_examples(): u8 {
        let lambda_add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let lambda_double: |u8|u8 has copy+drop = |x: u8| { x * 2u8 };
        let res1 = lambda_add(10u8, 11u8);
        let res2 = lambda_double(res1);
        res2
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::AddModule::add_and_return_constant --args 20u8 22u8



//# run 0xCAFE::AddModule::lambda_examples



//# run 0xCAFE::AddModule::inline_add --args 5u8 10u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddModule;

    public fun call_inline_add_twice(x: u8, y: u8, z: u8): u8 {
        let first = AddModule::inline_add(x, y);
        let second = AddModule::inline_add(first, z);
        second
    }
}



//# run 0xCAFE::NestedCalls::call_inline_add_twice --args 1u8 2u8 3u8



//# publish
module 0xCAFE::BindingRanges {
    use std::vector;

    struct Binding has copy, drop, store {
        name: vector<u8>,
        location: u64,
    }

    struct Range has copy, drop, store {
        start: u64,
        end_: u64,
    }

    struct BindingRange has copy, drop, store {
        binding: Binding,
        range: Range,
    }

    public fun make_binding(name: vector<u8>, loc_start: u64): Binding {
        Binding { name, location: loc_start }
    }

    public fun make_range(start: u64, end_: u64): Range {
        Range { start, end_ }
    }

    public fun make_binding_range(name: vector<u8>, start: u64, end_: u64): BindingRange {
        BindingRange {
            binding: make_binding(name, start),
            range: make_range(start, end_),
        }
    }

    public fun example_list(): vector<BindingRange> {
        let br1 = make_binding_range(b"x1", 0, 10);
        let br2 = make_binding_range(b"x2", 11, 20);
        let list = vector[];
        let list = vector::push_back(&mut list, br1);
        let list = vector::push_back(&mut list, br2);
        list
    }
}



//# run 0xCAFE::BindingRanges::example_list



//# publish
module 0xCAFE::CopyPropagationTest {
    public fun test_copy_propagation(mut_x: u8): u8 {
        let x = mut_x;
        while (x < 5) {
            x = x + 1;
        };
        let z = x + 1;
        z
    }
}



//# run 0xCAFE::CopyPropagationTest::test_copy_propagation --args 0u8
