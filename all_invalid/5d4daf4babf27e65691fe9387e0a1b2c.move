//# publish
module 0xCAFE::NestedAccess {
    struct Outer has copy, drop, store {
        inner: Inner,
    }

    struct Inner has copy, drop, store {
        container: Container,
    }

    struct Container has copy, drop, store {
        values: vector<u64>,
    }

    public fun new(): Outer {
        Outer {
            inner: Inner {
                container: Container {
                    values: vector::empty<u64>(),
                }
            }
        }
    }

    public fun add_value(outer: &mut Outer, val: u64) {
        vector::push_back(&mut outer.inner.container.values, val);
    }

    public fun get_four_level_value(outer: &Outer, idx: u64): u64 acquires Outer {
        // Access nested member: 0xCAFE::NestedAccess::Outer::inner::container::values
        // Actually Outer::Inner::Container::values
        // returns the vector element at idx
        *vector::borrow(&outer.inner.container.values, idx)
    }

    public fun runner() {
        let mut outer = new();
        let mut i = 0;
        while (i < 5) {
            add_value(&mut outer, i * 10);
            i = i + 1;
        };

        // Just touch all elements to test access in a loop, no asserts needed
        let mut j = 0;
        while (j < 5) {
            let _ = get_four_level_value(&outer, j);
            j = j + 1;
        };
    }
}
//# run 0xCAFE::NestedAccess::runner


//# publish
module 0xCAFE::InlineExample {
    // We want to test inlining of a simple function to benefit performance/abstraction

    // `inline` attribute is supported in Aptos Move to hint compiler to inline
    #[inline]
    fun multiply_by_two(x: u64): u64 {
        x * 2
    }

    #[inline]
    fun add_three(x: u64): u64 {
        x + 3
    }

    public fun runner() {
        let mut sum: u64 = 0;
        let mut i = 0;
        while (i < 10) {
            // Using two inline functions chained to benefit from inlining
            sum = sum + multiply_by_two(add_three(i));
            i = i + 1;
        };
    }
}
//# run 0xCAFE::InlineExample::runner


//# publish
module 0xCAFE::VectorMutRef {
    public fun modify_all_inplace(vec: &mut vector<u64>, val: u64) {
        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            let elem = vector::borrow_mut(vec, i);
            *elem = *elem + val;
            i = i + 1;
        };
    }

    public fun runner() {
        let mut v = vector::empty<u64>();
        let mut i = 0;
        while (i < 5) {
            vector::push_back(&mut v, i);
            i = i + 1;
        };

        modify_all_inplace(&mut v, 100);

        let mut j = 0;
        while (j < 5) {
            let _val = *vector::borrow(&v, j);
            j = j + 1;
        };
    }
}
//# run 0xCAFE::VectorMutRef::runner


//# run 0xCAFE::NestedAccess::runner

//# run 0xCAFE::InlineExample::runner

//# run 0xCAFE::VectorMutRef::runner

// Featurres:
// de3429d18a9e28c8c289d73fba98caf9: Access nested members or variants with four-level name chains like '0x1::Module::Type::Variant'.
// 7b96b033e8f7cf7d716d13afcbe4a504: Write Move code that benefits from inlining of functions during compilation for better performance or abstraction.
// 6ae80c6049abeab29ee31a974a75470b: Test that mutable references obtained from a vector can be used to modify all its elements in place within a loop.
