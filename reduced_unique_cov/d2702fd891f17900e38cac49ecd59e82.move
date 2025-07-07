
//# publish
module 0xCAFE::Computation {
    // A constant to verify use of const keyword
    const ADD_CONST: u8 = 42;

    // Struct to test 'acquires' keyword in function declaration
    struct Value has store, key {
        v: u8
    }

    // Public function that adds two u8 numbers and returns u8,
    // to test simple arithmetic, return values, and if-else
    public fun add_and_check(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > ADD_CONST) {
            sum
        } else {
            ADD_CONST
        };
    }

    // Function using a lambda expression to multiply two u8
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(a, b)
    }

    // Inline function that adds one to input u8
    public inline fun increment(x: u8): u8 {
        x + 1
    }

    // Function calling inline function multiple times for nested calls
    public fun nested_increment(x: u8): u8 {
        let y = increment(increment(x));
        y
    }

    // Function with loop, break, continue
    public fun loop_example(limit: u8): u8 {
        let counter = 0;
        let sum = 0;
        loop {
            if (counter >= limit) {
                break;
            };
            counter = counter + 1;

            if (counter % 2 == 0) {
                continue;
            };
            sum = sum + counter;
        };
        sum
    }

    // Function demonstrating copy, move, as casting, else, false etc.
    public fun complex_flow(x: u8): u8 {
        let val = x;
        let val_copy = copy val;
        if (val_copy == 0) {
            val = val + 10;
        } else {
            val = (val as u8) + 1;
        };
        val
    }

    // Function that aborts if condition not met
    public fun abort_if_zero(x: u8) {
        if (x == 0) {
            abort 100;
        };
    }

    // Function acquiring resource for demonstration (acquires needed for move_from)
    public fun acquire_resource(addr: address) acquires Value {
        // To compile, this needs a resource at addr; assume exists
        let _val = move_from<Value>(addr);
    }
}

// Module level specification block as example
spec module 0xCAFE::Computation {
    spec fun add_and_check(x: u8, y: u8): u8;
    spec fun multiply_lambda(a: u8, b: u8): u8;
}


//# publish
module 0xCAFE::TestRunner {
    use 0xCAFE::Computation;

    public fun call_add_and_check(): u8 {
        Computation::add_and_check(10u8, 15u8)
    }

    public fun call_multiply_lambda(): u8 {
        Computation::multiply_lambda(3u8, 7u8)
    }

    public fun call_nested_increment(): u8 {
        Computation::nested_increment(5u8)
    }

    public fun call_loop_example(): u8 {
        Computation::loop_example(6u8)
    }

    public fun call_complex_flow(): u8 {
        Computation::complex_flow(0u8)
    }

    public fun call_abort(x: u8) {
        Computation::abort_if_zero(x)
    }
}


//# run 0xCAFE::TestRunner::call_add_and_check


//# run 0xCAFE::TestRunner::call_multiply_lambda


//# run 0xCAFE::TestRunner::call_nested_increment


//# run 0xCAFE::TestRunner::call_loop_example


//# run 0xCAFE::TestRunner::call_complex_flow


//# run 0xCAFE::TestRunner::call_abort --args 1u8


//# run 0xCAFE::TestRunner::call_abort --args 0u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9913fee717d4d1dd0dd2683b4bd7e734: Write Move code using keywords such as abort, acquires, as, break, const, continue, copy, else, false, fun, friend, if, invariant, let, loop, inline, module, move, native, public, return, script, spec, struct, true, use, and while.
// 6fc375cc07405a18b00028440c7ab966: Attach specification blocks to entire modules to specify module-level properties.
