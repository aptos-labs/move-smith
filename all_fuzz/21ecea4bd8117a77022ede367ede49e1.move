
//# publish
module 0xCAFE::AdditionModule {
    // Simple function to add two u8 values and then return a fixed u8 value 42
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignore = sum; // We compute sum but ignore the value for return
        42u8
    }

    // Function containing lambda that captures and returns a sum
    public fun lambda_sum(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // Function with a local mutable lambda variable, mutated inside an inner closure
    public fun mutate_lambda_inner_closure(x: u8): u8 {
        // A local lambda that holds a mutable state (u8)
        let mut_state = |state: &mut u8, val: u8| {
            *state = *state + val;
        };
        let val = x;

        // Inner closure that modifies val through mutable reference
        let inner = |f: &(|&mut u8, u8|), v: u8| {
            f(&mut val, v);
        };
        inner(&mut_state, 5u8);
        val
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    // Call the inline function from another module and return the nested call results
    public fun call_add_then_lambda(x: u8, y: u8): (u8, u8) {
        let const_val = AdditionModule::add_and_return_constant(x, y);
        let lambda_val = AdditionModule::lambda_sum(x, y);
        (const_val, lambda_val)
    }
}


//# publish
module 0xCAFE::VectorMapTest {
    use std::vector;

    // Test vector::map with a vector literal and inline lambda to double each value
    public fun double_values(): vector<u8> {
        let input_vec = vector[1u8, 2u8, 3u8, 4u8];
        let doubled = vector::map(&input_vec, |x: &u8| {
            let val = *x * 2u8;
            val
        });
        doubled
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_constant --args 12u8 30u8


//# run 0xCAFE::AdditionModule::lambda_sum --args 7u8 8u8


//# run 0xCAFE::AdditionModule::mutate_lambda_inner_closure --args 10u8


//# run 0xCAFE::InlineCaller::call_add_then_lambda --args 3u8 4u8


//# run 0xCAFE::VectorMapTest::double_values


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 98642471f36cc004b2d2422c8a6d99a0: Test that vector::map correctly handles non-trivial vector constants and inlined lambda functions using closure syntax in a module entry function.
// 03412175cc0855f5fd887d96177fbc94: Test that local lambda variables with the 'drop' ability can be mutated through a mutable reference within an inner closure.
