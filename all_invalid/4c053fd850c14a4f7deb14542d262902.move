//# publish
module 0xCAFE::InlineControl {
    use std::signer;

    // Test function inlining: keep inline for small functions, no inline for bigger functions

    // Small inline function to add two u64 numbers
    public inline fun add_inline(x: u64, y: u64): u64 {
        x + y
    }

    // Bigger function, no inline, that calls inline function multiple times
    public fun sum_three(a: u64, b: u64, c: u64): u64 {
        let ab = add_inline(a, b);
        let abc = add_inline(ab, c);
        abc
    }

    // Runner function to test
    public fun runner(): u64 {
        sum_three(10, 20, 30)
    }
}
//# run 0xCAFE::InlineControl::runner

//# publish
module 0xCAFE::NestedAndHigherOrder {
    use std::signer;

    // Nested functions
    public inline fun nested_inner(x: u64): u64 {
        x * 2
    }

    public fun nested_outer(x: u64): u64 {
        nested_inner(x) + 1
    }

    // Higher order function: take function & call it twice on x
    public inline fun higher_order<F: copy + drop>(f: &F, x: u64): u64
        where F: Fn(u64): u64
    {
        let res1 = (*f)(x);
        let res2 = (*f)(res1);
        res2
    }

    // Define a struct wrapping a function to simulate closure (Move doesn't have closures, so we'll use a struct)
    struct DoubleFn has copy, drop {
    }

    public inline fun DoubleFn_call(x: u64): u64 {
        x * 2
    }

    // Runner function to test nested and higher-order invocation
    public fun runner(): u64 {
        let a = nested_outer(3); // (3 * 2) + 1 = 7

        // Because Move doesn't support direct function pointer as first-class, simulate closure as DoubleFn struct,
        // and pass DoubleFn_call directly (inline) - but Move lacks real closures, so this only partially exercises.
        let res = higher_order<&DoubleFn_call>(DoubleFn_call, a); // call DoubleFn_call twice: a * 2 * 2 = a * 4

        res // expecting 7 * 4 = 28
    }
}
//# run 0xCAFE::NestedAndHigherOrder::runner

//# publish
module 0xCAFE::LValueLists {
    use std::signer;

    // Define a simple struct with Copy to destructure
    struct Pair has copy, drop {
        x: u64,
        y: u64,
    }

    public fun get_pair(): Pair {
        Pair { x: 1, y: 2 }
    }

    public fun get_tuple(): (u64, u64, u64) {
        (3, 4, 5)
    }

    public fun run_lvalue_list(): u64 {
        // Destructure return value to multiple variables
        let Pair { x: a, y: b } = get_pair();

        // Destructure tuple to multiple variables
        let (c, d, e) = get_tuple();

        // Assign new values to multiple variables from lvalue lists
        let (a2, b2) = (a + c, b + d);

        // Overwrite with lvalue list again
        let (c2, d2, e2) = (a2 + b2, e, c);

        // Compute some result to make sure values are correct
        a2 + b2 + c2 + d2 + e2
    }
}
//# run 0xCAFE::LValueLists::run_lvalue_list

//# run
script {
    use 0xCAFE::InlineControl;
    use 0xCAFE::NestedAndHigherOrder;
    use 0xCAFE::LValueLists;

    fun main() {
        let res_inline = InlineControl::runner();
        let res_nested = NestedAndHigherOrder::runner();
        let res_lvalue = LValueLists::run_lvalue_list();

        // Just call them to exercise compiler and VM.
        // No assertions required.
    }
}

// Featurres:
// 296137f73b01ca107f2e516f6e55c58b: Use function inlining and control whether to keep or lift inline functions
// 3224d011a28f0ad20e984f997330cc6c: Test that nested and higher-order function definitions with various function types, captures, and composite closures correctly produce expected results when invoked.
// 2cac4ddb6698c907333aae862083d68d: Use left-value lists (lvalue lists) to assign variables or destructure values in assignment statements.
