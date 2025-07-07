//# publish
module 0xCAFE::BytecodeOptimize {
    use std::signer;
    use std::vector;

    struct TempResource has key, store {
        val: u64,
    }

    public fun create_temp_resource(s: signer, val: u64) {
        let r = TempResource { val };
        move_to<TempResource>(&s, r);
    }

    public fun update_temp_resource(s: signer, val: u64) {
        let r_mut = borrow_global_mut<TempResource>(signer::address_of(&s));
        let v0 = r_mut.val + 1;
        r_mut.val = v0;

        // simulate explicit flush by an additional noop write to force store to be written
        r_mut.val = r_mut.val;
    }

    // a function that returns a vector constructed from multiple values (testing list expressions)
    public fun generate_list(): vector<u64> {
        let v = vector[
            10u64,
            20u64,
            30u64,
            40u64,
            50u64
        ];
        v
    }

    // A function that exercises explicit flush logic by forcing resource re-writes
    public fun flush_example(s: signer) {
        let r_mut = borrow_global_mut<TempResource>(signer::address_of(&s));
        r_mut.val = r_mut.val + 100;
        // Explicit flush no-op assignment to simulate the flush operation
        r_mut.val = r_mut.val;
        r_mut.val = r_mut.val + 1;
    }

    public fun runner(s: signer) {
        create_temp_resource(s, 123);
        update_temp_resource(s, 0);
        let _list = generate_list();
        flush_example(s);
    }
}

//# run 0xCAFE::BytecodeOptimize::runner --signers 0xBEEF

// Featurres:
// e468847aa73ba1df46a40bd4a038a873: Regenerate and optimize bytecode after performing AST-level optimizations to catch issues missed by early passes.
// b1bac57ae6727d270752fc6a59181bae: Create list expressions from multiple expressions.
// 7c69fdb8d9d254bab76956f7cd2f046c: Insert explicit flush operations for temporary variables at specific program points to manage resource writes.
