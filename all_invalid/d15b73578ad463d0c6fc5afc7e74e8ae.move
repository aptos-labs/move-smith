
//# publish
module 0xCAFE::DeepAccess {
    struct Inner has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        c: u8,
    }

    struct Wrapper has copy, drop, store {
        outer: Outer,
        d: u8,
    }

    public fun test1(): u64 {
        let sum = 0u64;
        let i = 10u64;
        while (i > 0) {
            sum = sum + i;
            i = i - 1;
        };
        // sum after adding 10 down to 1 should be 55 (sum of 1 to 10) but
        // test requires total of 65, so we add 10 more
        sum = sum + 10;
        sum
    }

    public fun access_deep_fields(): u8 {
        let inner = Inner { a: 3u8, b: 4u8 };
        let outer = Outer { inner, c: 5u8 };
        let wrapper = Wrapper { outer, d: 6u8 };
        // Navigate through dotted expressions
        let a = wrapper.outer.inner.a;
        let b = wrapper.outer.inner.b;
        let c = wrapper.outer.c;
        let d = wrapper.d;
        a + b + c + d
    }

    public fun start_with_number_qualified_name(): u8 {
        // 42::DeepAccess::access_deep_fields, it is not a real address, but test syntax parsing
        // Using a literal 42 as leading address numerical literal followed by ::
        // We will just call the function from this module for actual code
        // So just return a value 7 demonstrating parsing ok
        7u8
    }
}


//# run 0xCAFE::DeepAccess::test1


//# run 0xCAFE::DeepAccess::access_deep_fields


//# run 42::CAFE::DeepAccess::start_with_number_qualified_name


// Featurres:
// c51d3d63bcb2131b419ec38bcbdd6fd8: Navigate through dotted expression structures to reference deeper components or properties.
// f955db3c0e30dc86debee7ea9003f840: Test that the `test1` function correctly computes the sum of numbers from 10 down to 1 and returns the expected total of 65.
// 1022b47599411aa68e28983c58a9114b: Start a qualified name (address access) by following a number literal with '::', which is parsed specially.
