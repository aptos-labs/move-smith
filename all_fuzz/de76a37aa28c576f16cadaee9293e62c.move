
//# publish
module 0xCAFE::LambdaModule {
    // Test writing functions containing lambda (anonymous function) expressions

    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        let add_and_mul: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        add_and_mul(x, y)
    }

    public fun call_lambda_multiple_times(x: u8): u8 {
        let incr: |u8|u8 has copy+drop = |v: u8| v + 1;
        let x1 = incr(x);
        let x2 = incr(x1);
        let x3 = incr(x2);
        x3
    }
}


//# publish
module 0xCAFE::InlineFunCaller {
    use 0xCAFE::LambdaModule;

    public inline fun identity(x: u8): u8 {
        x
    }

    public fun call_identity_and_add(y: u8): u8 {
        let id1 = identity(y);
        let id2 = identity(id1);
        let id3 = identity(id2);
        id3 + y
    }

    public fun call_lambda_module_apply(x: u8, y: u8): (u8, u8) {
        LambdaModule::apply_lambda(x, y)
    }
}


//# publish
module 0xCAFE::GraphA {
    // No dependencies
    public fun f(): u8 {
        1
    }
}


//# publish
module 0xCAFE::GraphB {
    use 0xCAFE::GraphA;

    public fun f(): u8 {
        GraphA::f() + 1
    }
}


//# publish
module 0xCAFE::GraphC {
    use 0xCAFE::GraphB;

    public fun f(): u8 {
        GraphB::f() + 1
    }
}


//# publish
module 0xCAFE::LintSkippingModule {
    // skip(lint::unreachable_code, lint::unused_variable)]
    public fun test_skips(x: u8): u8 {
        if (x > 10) {
            return 42;
            let _unused = 5; // unreachable code, usually an error
        } else {
            let unused_var = 10; // unused variable, usually lint warning
        };
        x
    }
}


//# run 0xCAFE::LambdaModule::apply_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaModule::call_lambda_multiple_times --args 5u8


//# run 0xCAFE::InlineFunCaller::call_identity_and_add --args 7u8


//# run 0xCAFE::InlineFunCaller::call_lambda_module_apply --args 2u8 3u8


//# run 0xCAFE::GraphC::f


//# run 0xCAFE::LintSkippingModule::test_skips --args 5u8


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 1fa9545d47ec92a7acf7cd4f5fce8ee8: Test that a Move module can define and invoke a simple identity function multiple times, then perform an arithmetic operation on its result.
// 94edb5e14905208dab6e3d3dc730616e: Construct a directed dependency graph of modules based on their dependencies.
// 84c8cd1da70fe50076541bf9c4b58477: Annotate attributes with `#[skip(...)]` to specify lint checks to be skipped.
