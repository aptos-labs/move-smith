// #publish
module 0xCAFE::ModuleA {
    public fun test(): u64 {
        // local variables to sum
        let x: u64 = 1;
        let y: u64 = 3;
        x + y
    }

    public fun main() {
        let val = test();
        // no assert needed per instructions, just for test coverage
        let _ = val;
    }
}
// #run 0xCAFE::ModuleA::test
// #run 0xCAFE::ModuleA::main

// #publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA;

    public fun runner(): u64 {
        // Access ModuleA::test through the full module path (module access chain)
        ModuleA::test()
    }
}
// #run 0xCAFE::ModuleB::runner

// #publish
module 0xCAFE::ModuleDestroy {
    resource struct R has store { val: u64 }

    public fun create_resource(): R {
        R { val: 42 }
    }

    public fun test_destroy() {
        let r1 = create_resource();
        // copy chain creation
        let r2 = r1;
        let mut r3 = r2;

        // re-assign r3 with a new resource, should drop old copy chain info
        r3 = create_resource();

        // now destroy one of the old values, must handle copy chain correctly
        destroy r1;
        // destroy r3 so no leaks
        destroy r3;
    }
}
// #run 0xCAFE::ModuleDestroy::test_destroy

// #run
script {
    use 0xCAFE::ModuleA;
    use 0xCAFE::ModuleB;
    use 0xCAFE::ModuleDestroy;

    fun main() {
        let _ = ModuleA::test();
        ModuleA::main();
        let _ = ModuleB::runner();
        ModuleDestroy::test_destroy();
    }
}

// Featurres:
// a13f6a11ca9c03e08adf80b5b5c43003: Resolve module access chains that can be interpreted as module references, considering possible aliasing and nested paths.
// 8ade2d7a9e777956f2a9047379ef8e10: Test that the `test` function correctly sums assigned local variables and the `main` function asserts the expected value of 4.
// 5f2ba91b946acfaef5bc1b41c3366d82: Test that destroying a variable in a copy chain with a re-assignment correctly removes all related copy information, ensuring equality comparisons use the correct values.
