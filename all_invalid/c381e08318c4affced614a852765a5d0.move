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

    public inline fun call_with_closure(f: &fun(u8): u8, x: u8): u8 {
        f(x)
    }

    public struct MyTuple has copy, drop, store {
        a: u8,
        b: u16,
        c: u32,
    }

    public fun run_tuple_access(): u8 {
        let my_tuple = MyTuple { a: 123u8, b: 234u16, c: 345u32 };
        let a: u8 = my_tuple.a;
        let b: u16 = my_tuple.b;
        let c: u32 = my_tuple.c;
        a + (b as u8) + (c as u8)
    }

    public fun run_call_with_closure(): u8 {
        let doubled = fun(x: u8): u8 { x * 2 };
        call_with_closure(&doubled, 7u8)
    }
}

//# run 0xCAFE::TupleAndClosureTest::test --args 77u8

//# run 0xCAFE::TupleAndClosureTest::run_tuple_access

//# run 0xCAFE::TupleAndClosureTest::run_call_with_closure