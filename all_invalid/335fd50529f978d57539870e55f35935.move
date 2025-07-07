
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

    // Fixed: 
    // - The exists/forall/choose are keywords, not functions. No parentheses with arguments.
    // - They take type parameter and an address literal only.
    // - The quantifiers work on the resource instances under the given address.
    // - The closure is passed with `|x| expr` syntax
    // - Removed `counters: &vector<Counter>` because these quantifiers do NOT take vectors,
    //   instead they search the global store at that address for resources of the specified type.

    public fun exists_example(target: u8): bool {
        exists<Counter>(@0xCAFE) || forall<Counter>(@0xCAFE, |c| c.x < target)
    }

    public fun forall_example(max: u8): bool {
        forall<Counter>(@0xCAFE, |c| c.x <= max)
    }

    public fun choose_example() {
        let _ = choose<Counter>(@0xCAFE);
    }

    public fun runner() {
        // Publish a Counter resource under 0xCAFE for quantifiers to work correctly
        move_to(&signer, Counter { x: 0 });

        let c_ref = borrow_global_mut<Counter>(@0xCAFE);
        increment(c_ref);
        increment_inline(c_ref);
        let _sum = add_then_return_sum(3u8, 4u8);

        // Call quantifier examples to ensure they compile and run
        let _ = exists_example(10);
        let _ = forall_example(10);
        choose_example();
    }
}
