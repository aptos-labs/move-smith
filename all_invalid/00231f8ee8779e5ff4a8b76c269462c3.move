//# publish
module 0xCAFE::TupleAndClosureTest {
    // Test that local variable assignment from argument after a function call works
    // Test tuple field access by positional index using .0, .1
    // Test inline functions that accept function-typed parameters and closures

    public fun one(): u8 {
        1u8
    }

    public fun test(p: u8): u8 {
        let _x = one();
        let _x = p; // assign p to _x local variable after the call
        _x
    }

    public inline fun call_with_closure(f: |u8|u8, x: u8): u8 {
        f(x)
    }

    public fun run_tuple_access(): u8 {
        let my_tuple = (123u8, 234u16, 345u32);
        let a: u8 = my_tuple.0;
        let b: u16 = my_tuple.1;
        let c: u32 = my_tuple.2;
        a + (b as u8) + (c as u8)
    }

    public fun run_call_with_closure(): u8 {
        let doubled = |x: u8| { x * 2 };
        call_with_closure(doubled, 7u8)
    }
}

//# run 0xCAFE::TupleAndClosureTest::test --args 77u8

//# run 0xCAFE::TupleAndClosureTest::run_tuple_access

//# run 0xCAFE::TupleAndClosureTest::run_call_with_closure

// Featurres:
// 82192e1c5121e4531b7cb24f03120b62: Test that the `test` function correctly assigns the input parameter `p` to the local variable `_x` after calling the `one` function and returns the value of `_x`.
// edadf2c9fb9845b59892db51edd0f496: Access tuple fields by positional index using dot notation, such as `my_tuple.0`.
// e962ae36f37285143dc6f6976c3acd76: Test that inline functions with function-typed parameters correctly accept and invoke closures as arguments.
