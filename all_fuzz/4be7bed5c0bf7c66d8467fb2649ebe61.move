
//# publish
module 0xCAFE::TestAddLambda {
    // Function that adds two u8 values and returns a static value 42
    public fun add_and_return_static(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum; // just testing addition
        42u8
    }

    // Function that takes a lambda and applies it
    public fun apply_lambda(x: u8, y: u8, f: |u8, u8|u8): u8 {
        f(x, y)
    }

    // Runner function to test lambda: doubles sum of x+y
    public fun runner_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            s * 2
        };
        apply_lambda(x, y, lambda)
    }
}



//# run 0xCAFE::TestAddLambda::add_and_return_static --args 10u8 32u8



//# run 0xCAFE::TestAddLambda::runner_lambda --args 3u8 4u8



//# publish
module 0xCAFE::TestInlineCall {
    // Since 0xCAFE::MyModule is not defined, we define f2 here as an example
    // Inline function returning a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    // Calls the inline function f2 and returns sum of tuple
    public fun call_inline_and_sum(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }
}



//# run 0xCAFE::TestInlineCall::call_inline_and_sum --args 5u16



//# publish
module 0xCAFE::TestBlockLocalUpdate {
    // Computes 1 + (p + {p = p + 1; p}) with local p updated inside the block
    public fun compute_and_update_local(p: u8): u8 {
        let inner = {
            let local_p = p;
            local_p = local_p + 1;
            local_p
        };
        1 + (p + inner)
    }
}



//# run 0xCAFE::TestBlockLocalUpdate::compute_and_update_local --args 3u8



//# publish
module 0xCAFE::UniqueStructs {
    // Struct A with a single field
    struct StructA has copy, drop, store {
        val: u64,
    }

    // Struct B with different field types
    struct StructB has store {
        a: u8,
        b: bool,
        c: vector<u8>,
    }

    public fun create_a(val: u64): StructA {
        StructA { val }
    }

    public fun create_b(a: u8, b: bool, c: vector<u8>): StructB {
        StructB { a, b, c }
    }
}



//# run 0xCAFE::UniqueStructs::create_a --args 42u64



//# run 0xCAFE::UniqueStructs::create_b --args 7u8 true b"abc"
