//# publish
module 0xCAFE::ShadowChain {

    /// Test variable shadowing and chained function calls preserving values.
    public fun triple_add(x: u64): u64 {
        let x = x + 1;
        let x = x + 2;
        let x = add_three(x);
        x
    }

    public inline fun add_three(x: u64): u64 {
        add_one(add_two(x))
    }

    public inline fun add_one(x: u64): u64 {
        x + 1
    }

    public inline fun add_two(x: u64): u64 {
        x + 2
    }

    // Runner function to call triple_add with a constant and return the result.
    public fun runner(): u64 {
        triple_add(10)
    }
}

//# run 0xCAFE::ShadowChain::runner

//# publish
module 0xCAFE::LvalueReverse {

    // A struct to hold an integer value by reference (simulate lvalue)
    struct Holder has copy, drop, store {
        val: u64,
    }

    /// Process a vector of mutable references (lvalues) in reverse order and
    /// set their values to the loop index.
    public fun process_reverse_order(v: &mut vector<&mut Holder>) {
        let len = Vector::length(v);
        let mut i = len;
        while (i > 0) {
            i = i - 1;
            let lvalue_ref = Vector::borrow_mut(v, i);
            ((*lvalue_ref).val) = i as u64;
        }
    }

    /// Prepare a vector of lvalue references and call process_reverse_order
    public fun runner(): vector<u64> {
        let mut holders = vector::empty<Holder>();
        let mut refs = vector::empty<&mut Holder>();

        // create 5 Holder structs with val=0
        let mut i = 0;
        while (i < 5) {
            Vector::push_back(&mut holders, Holder { val: 0 });
            i = i + 1;
        }

        // create refs to each Holder (mutable borrow)
        let mut j = 0;
        while (j < 5) {
            let r = &mut Vector::borrow_mut(&mut holders, j);
            Vector::push_back(&mut refs, r);
            j = j + 1;
        }

        process_reverse_order(&mut refs);

        // collect updated values from holders
        let mut results = vector::empty<u64>();
        let mut k = 0;
        while (k < 5) {
            let h = Vector::borrow(&holders, k);
            Vector::push_back(&mut results, h.val);
            k = k + 1;
        }
        results
    }
}

//# run 0xCAFE::LvalueReverse::runner

//# publish
module 0xCAFE::InlineFuncArgs {

    /// Accepts two inline functions f, g and an integer x.
    /// Returns f(x) + g(x).
    public inline fun foo(
        f: &fun(u64): u64,
        g: &fun(u64): u64,
        x: u64
    ): u64 {
        (*f)(x) + (*g)(x)
    }

    public inline fun f(x: u64): u64 {
        x + 10
    }

    public inline fun g(x: u64): u64 {
        x * 2
    }

    /// Runner function calls foo with f and g on a constant value and returns the sum.
    public fun runner(): u64 {
        foo(&f, &g, 5)
    }
}

//# run 0xCAFE::InlineFuncArgs::runner


//# run
script {
    use 0xCAFE::ShadowChain;
    use 0xCAFE::LvalueReverse;
    use 0xCAFE::InlineFuncArgs;

    fun main() {
        let res_shadow = ShadowChain::runner();
        // no assertions, but ensures no compilation/runtime error

        let res_lvalue = LvalueReverse::runner();
        // no assertions, but ensures no compilation/runtime error

        let res_inline = InlineFuncArgs::runner();
        // no assertions, but ensures no compilation/runtime error

        // Dummy no-op to "use" these variables to avoid warnings
        let _ = res_shadow + (Vector::length(&res_lvalue) as u64) + res_inline;
    }
}

// Featurres:
// 1831182f0c0ed93b503610c381492704: Test that variable shadowing and chained function calls correctly preserve values and compile without error.
// 1cb7ff95c25727bf553a0da3ff49409d: Define lists of left-hand side expressions (lvalues) and process each element in reverse order to bind unbound names appropriately.
// 57120d60653d63ffad42fd713f9f8db8: Test that the inline functions `f` and `g` can be passed as arguments to the `foo` function and correctly compute the sum of their applied results.
