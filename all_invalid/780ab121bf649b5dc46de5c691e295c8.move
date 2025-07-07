//# publish
module 0xCAFE::TypeParamFormatting {
    // Test automatic type parameter syntax generation with proper formatting and numbering.

    struct Container<T1, T2> has copy, store, drop {
        first: T1,
        second: T2,
    }

    public fun create_container<T1, T2>(a: T1, b: T2): Container<T1, T2> {
        Container { first: a, second: b }
    }

    public fun use_container() {
        let c = create_container<u8, u64>(5u8, 10u64);
        let _f = c.first;
        let _s = c.second;
    }
}
//# run 0xCAFE::TypeParamFormatting::use_container


//# publish
module 0xCAFE::ExitProcessAfterDiag {
    use std::debug;
    use std::option;

    struct Context has store {
        has_error: bool,
        should_exit: bool,
    }

    public fun new_context(exit: bool): Context {
        Context { has_error: true, should_exit: exit }
    }

    public fun run_with_diagnostics(ctx: &mut Context) {
        if (ctx.has_error) {
            debug::print(b"Error: Diagnostics found\n");
            if (ctx.should_exit) {
                // This abort simulates exit with code 1 on diagnostics.
                abort 1;
            };
        };
        // if no error or no exit, just return normally
    }

    public fun runner_exit() {
        let ctx = new_context(true);
        run_with_diagnostics(&mut ctx);
    }

    public fun runner_continue() {
        let ctx = new_context(false);
        run_with_diagnostics(&mut ctx);
    }
}
//# run 0xCAFE::ExitProcessAfterDiag::runner_continue

//# run 0xCAFE::ExitProcessAfterDiag::runner_exit


//# publish
module 0xCAFE::NestedEndDelimiter {
    // Use '<' token as an end delimiter in parsing contexts where nested '>>' tokens appear.
    // We test nested generics and ensure no parse ambiguity.

    struct Inner has copy, drop {
        val: u8,
    }

    struct Outer<T> has store {
        inner_vec: vector<T>,
    }

    public fun create_nested_vec(): Outer<vector<Inner>> {
        let inner1 = Inner { val: 42 };
        let inner2 = Inner { val: 7 };
        let mut v = vector::empty<Inner>();
        vector::push_back(&mut v, inner1);
        vector::push_back(&mut v, inner2);
        Outer { inner_vec: v }
    }

    public fun use_nested() {
        let outer = create_nested_vec();
        let len = vector::length(&outer.inner_vec);
        // just read the length to avoid unused warnings
        let _ = len;
    }
}
//# run 0xCAFE::NestedEndDelimiter::use_nested

// Featurres:
// 747b4002faaa7e337217152de6e1ffb0: Automatically generate type parameter syntax with proper formatting and numbering.
// 2d436c6091fcd5bac792d6332a0dc20a: Exit the process with code 1 after displaying diagnostics if 'should_exit' is true.
// 5d06b27b54b8c9fe107c4b6c915e1ac6: Use the '<' token as an end delimiter in parsing contexts where nested '>>' tokens are involved.
