//# publish
module 0xCAFE::ModuleA {
    use std::debug;

    // An inline function that returns a u64 constant
    public inline fun inline_func(): u64 {
        42u64
    }

    spec module {
        // This invariant asserts that inline_func is always 42
        invariant inline_func() == 42u64;
    }
}

//# publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA;
    use std::debug;

    // A function that calls the inline function from ModuleA and adds 1
    public fun call_inline_func(): u64 {
        let v = ModuleA::inline_func();
        v + 1u64
    }

    // A runner function that exercises the nested call and returns the result
    public fun runner(): u64 {
        call_inline_func()
    }

    spec module {
        // Invariant: call_inline_func always returns 43 (42+1)
        invariant call_inline_func() == 43u64;
    }
}
//# run 0xCAFE::ModuleB::runner

// Featurres:
// 30cf24c5e166194fa65e2c2380510d3b: Import other modules using 'use' dependencies.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 08082b21b4090d159c6641a7a7311704: Include only `invariant` conditions inside `spec` blocks to ensure proper validation of loop invariants.
