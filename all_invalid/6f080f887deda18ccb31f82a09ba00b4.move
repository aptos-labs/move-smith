
//# publish
module 0xCAFE::QuantifierTest {
    struct Counter has store {
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

    public fun exists_example(counters: &vector<Counter>, target: u8): bool {
        exists<Counter>(0xCAFE) || forall<Counter>(0xCAFE, |c: &Counter| c.x < target)
        // Note: The above expression is just to exercise exists and forall keywords
        // in a simplified manner. Real quantifier expressions require proper usage.
    }

    public fun forall_example(counters: &vector<Counter>, max: u8): bool {
        forall<Counter>(0xCAFE, |c: &Counter| c.x <= max)
    }

    public fun choose_example() {
        let _ = choose<Counter>(0xCAFE);
    }

    public fun runner() {
        let c = Counter { x: 0 };
        increment(&mut c);
        increment_inline(&mut c);
        let _sum = add_then_return_sum(3u8, 4u8);
    }
}


//# run 0xCAFE::QuantifierTest::runner


// Featurres:
// c6c57adbbba444a9942b6d969f1f9e12: Use the 'exists', 'forall', or 'choose' keywords for quantifier expressions in Move code.
// bb79ff144625fad5c5d963d83afd4255: Test that calling increment functions on a mutable struct updates its `x` field correctly and that the inline function behaves identically to the regular function.
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
