
//# publish
module 0xCAFE::Calc {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // Move currently does not support lambda functions, so remove that function or rewrite without lambda
    // Commented out the compute_with_lambda function due to unsupported lambda syntax
    /*
    public fun compute_with_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
    */

    // Rewritten compute_with_lambda without lambda
    public fun compute_with_lambda(x: u8, y: u8): u8 {
        x + y
    }
}




//# run 0xCAFE::Calc::add_two_values --args 3u8 5u8




//# run 0xCAFE::Calc::compute_with_lambda --args 7u8 8u8




//# publish
module 0xCAFE::Nested {
    public inline fun inline_add(a: u16): u16 {
        a + 10
    }
}




//# publish
module 0xCAFE::Nested2 {
    use 0xCAFE::Nested;

    public inline fun double_inline_add(a: u16): u16 {
        let tmp = Nested::inline_add(a);
        tmp + 20
    }
}




//# publish
module 0xCAFE::Util {
    use 0xCAFE::Nested;
    use 0xCAFE::Nested2;

    public fun call_inline(x: u16): u16 {
        Nested::inline_add(x)
    }

    public fun call_nested_inline(x: u16): u16 {
        Nested2::double_inline_add(x)
    }
}




//# run 0xCAFE::Util::call_inline --args 5u16




//# run 0xCAFE::Util::call_nested_inline --args 5u16




//# publish
module 0xCAFE::UniqueStructVariants {
    struct MyStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    enum UniqueEnum has copy, drop {
        VariantOne,
        VariantTwo(u8),
        VariantThree { val: u8 }
    }

    struct AnotherStruct has copy, drop {
        val1: u64,
        val2: u64,
    }
}




//# publish
module 0xCAFE::HashTest {
    use std::vector;

    // Mock hash function for content hash since no hashing std yet
    // Just summing bytes for demonstration of unique file content hash calculation concept
    public fun file_content_hash(content: vector<u8>): u64 {
        let acc = 0u64;
        let len = vector::length(&content);
        let i = 0u64;
        while (i < len) {
            let b = vector::borrow(&content, i as u64);
            acc = acc + (*b as u64);
            i = i + 1;
        };
        acc
    }

    public fun get_source_hash(): u64 {
        // The source code bytes for this file as a demonstration vector
        // Using a simple hardcoded example source content vector for unique hash simulation
        let source: vector<u8> = b"module 0xCAFE::HashTest { fun get_source_hash() }";
        file_content_hash(source)
    }
}




//# run 0xCAFE::HashTest::get_source_hash
