//# publish
module 0xCAFE::InlineTransform {
    use std::vector;

    /// A simple struct with resource and copy + drop abilities specified
    struct MyStruct has key + store + copy + drop {
        val: u64,
    }

    /// A generic struct with ability constraints:
    /// T must have 'copy + drop' abilities
    struct Wrapper<T: copy + drop> has store {
        inner: T,
    }

    // Inline function that doubles the input
    #[inline]
    fun double(x: u64): u64 {
        x * 2
    }

    // Inline function that creates a MyStruct from u64
    #[inline]
    fun make_struct(x: u64): MyStruct {
        MyStruct { val: x }
    }

    // Run function without arguments to test inlining and struct creation
    public fun runner(): vector<MyStruct> {
        // Create vector of u64 from 0 to 4 (5 elements)
        let nums = vector::range<u64>(0, 5);
        // Transform each element by doubling it and wrapping into MyStruct
        let mut out = vector::empty<MyStruct>();
        let len = vector::length(&nums);
        let mut i = 0;
        while (i < len) {
            let doubled = double(*vector::borrow(&nums, i));
            // Using make_struct (inline)
            let s = make_struct(doubled);
            vector::push_back(&mut out, s);
            i = i + 1;
        };
        out
    }
}
//# run 0xCAFE::InlineTransform::runner

//# publish
module 0xCAFE::AbilityConstraints {
    /// Resource struct with abilities specified explicitly: only resource
    struct Res has key {}

    /// Struct that has copy + drop
    struct Val has copy + drop {
        v: u64,
    }

    /// Generic struct with ability constraint: T must be resource
    struct ResourceWrapper<T: resource> has store {
        inner: T,
    }

    /// Generic struct with ability constraints: T must be copy + drop
    struct ValueWrapper<T: copy + drop> has store {
        inner: T,
    }

    /// A function to test constructing structs with abilities
    public fun runner(): (bool, bool) {
        let res = Res {};
        let wrapped_res = ResourceWrapper<Res> { inner: res };

        let val = Val { v: 42 };
        let wrapped_val = ValueWrapper<Val> { inner: val };

        // Just return true flags for having created them without error
        (true, true)
    }
}
//# run 0xCAFE::AbilityConstraints::runner

//# publish
module 0xCAFE::RangeTransform {
    use std::vector;

    /// Value-range pair structure with copy + drop abilities
    struct ValueRangePair<T: copy + drop> has copy + drop {
        value: T,
        range_start: u64,
        range_end: u64,
    }

    /// Create a list of ValueRangePairs by transforming the input vector of values
    /// Associates each element with a range [i, i+10)
    /// T must be copy + drop
    public fun create_pairs<T: copy + drop>(values: vector<T>): vector<ValueRangePair<T>> {
        let mut out = vector::empty<ValueRangePair<T>>();
        let len = vector::length(&values);
        let mut i = 0;
        while (i < len) {
            let v = *vector::borrow(&values, i);
            let pair = ValueRangePair {
                value: v,
                range_start: i as u64,
                range_end: i as u64 + 10,
            };
            vector::push_back(&mut out, pair);
            i = i + 1;
        };
        out
    }

    /// Runner that creates a vector of u8s and transforms into value-range pairs
    public fun runner(): vector<ValueRangePair<u8>> {
        let vals = vector::from_elem<u8>(5, 3u8); // vector of five 3u8s
        create_pairs<u8>(vals)
    }
}
//# run 0xCAFE::RangeTransform::runner

//# run
script {
    use 0xCAFE::InlineTransform;
    use 0xCAFE::AbilityConstraints;
    use 0xCAFE::RangeTransform;
    use std::debug;

    fun main() {
        // Run InlineTransform runner
        let inline_results = InlineTransform::runner();
        // Run AbilityConstraints runner
        let (a, b) = AbilityConstraints::runner();
        // Run RangeTransform runner
        let range_results = RangeTransform::runner();

        // Just do some no-op prints to exercise VM print instruction (not asserting)
        debug::print(&vector::length(&inline_results));
        debug::print(&(if a && b { 1u8 } else { 0u8 }));
        debug::print(&vector::length(&range_results));
    }
}

// Featurres:
// 486641ce13d925db96596942de5c1006: Perform inlining transformations.
// db8b195118ba70bfebbbde9e236bc299: Create a list of value-range pairs by transforming each element in a range list.
// d51a366e7d162768d352933eb1c5a4a7: Specify ability constraints on structs, resources, and generic parameters using the ':' syntax followed by a list of abilities separated by '+'.
