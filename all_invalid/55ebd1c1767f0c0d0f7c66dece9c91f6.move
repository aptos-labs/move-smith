//# publish
module 0x1::InlineClosureTest {
    /// This function tests an inline function calling a closure that modifies a local variable
    public fun test_inline_closure(): u64 {
        let mut base = 10;
        let inline modify_and_return = || {
            base = base + 32;
            base
        };
        let result = modify_and_return();
        // result should be 42 (10 + 32) and local base modified
        result
    }

    /// Runner function without args
    public fun runner(): u64 {
        test_inline_closure()
    }
}
//# run 0x1::InlineClosureTest::runner

//# publish
module 0x1::AbilitiesDecl {
    // Declares a resource with multiple abilities using 'has' keyword
    struct MyResource has key, store, drop {
        val: u8,
    }

    public fun create_resource(v: u8): MyResource {
        MyResource { val: v }
    }

    /// Runner function creates a resource and returns its val
    public fun runner(): u8 {
        let r = create_resource(7);
        r.val
    }
}
//# run 0x1::AbilitiesDecl::runner

//# publish
module 0x1::CallerModule {
    use 0x1::InlineClosureTest;

    /// Inline function that calls InlineClosureTest::test_inline_closure and adds 8
    public inline fun nested_call(): u64 {
        let x = InlineClosureTest::test_inline_closure();
        x + 8
    }

    // Runner that calls nested_call
    public fun runner(): u64 {
        nested_call()
    }
}
//# run 0x1::CallerModule::runner