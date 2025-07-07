
//# publish
module 0xCAFE::QuantifierTest {
    // To use exists/forall/choose, the struct must have `key` ability
    struct Counter has key, store {
        x: u8,
    }

    public fun new_counter(v: u8): Counter {
        Counter { x: v }
    }

    public fun increment(c: &mut Counter) {
        c.x = c.x + 1u8;
    }

    public inline fun increment_inline(c: &mut Counter) {
        c.x = c.x + 1u8;
    }

    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // Note: The quantifier functions exists, forall, choose are intrinsic keywords 
    // and must be called with address literals (e.g. 0xCAFE) as address literals, 
    // which requires 0xCAFE to be interpreted as an address (i.e., 0xCAFE must be 
    // written with the "0x" prefix and as an address literal, not a number).

    // Also, `forall` and `choose` are intrinsic Move keywords that work differently 
    // than normal functions; their usage is limited. We can generally compile code 
    // referencing them as intrinsic, so no user-defined function named forall, choose should be expected.

    public fun exists_example(counters: &vector<Counter>, target: u8): bool {
        // The literal address must be 0xCAFE as an address, use `@0xCAFE` 
        // or cast 0xCAFE to address: `@0xCAFE`
        // The quantifier expression is a single expression, not logical OR of two calls.
        exists<Counter>(@0xCAFE) || forall<Counter>(@0xCAFE, |c: &Counter| c.x < target)
    }

    public fun forall_example(counters: &vector<Counter>, max: u8): bool {
        forall<Counter>(@0xCAFE, |c: &Counter| c.x <= max)
    }

    public fun choose_example() {
        let _ = choose<Counter>(@0xCAFE);
    }

    public fun runner() {
        let c = Counter { x: 0 };
        increment(&mut c);
        increment_inline(&mut c);
        let _sum = add_then_return_sum(3u8, 4u8);
    }
}



//# run 0xCAFE::QuantifierTest::runner
