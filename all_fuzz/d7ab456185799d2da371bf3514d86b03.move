
//# publish
module 0xCAFE::TestAdd {
    /// Adds two u8 numbers and then adds a constant 10 to test proper arithmetic and return
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }
}


//# run 0xCAFE::TestAdd::add_and_offset --args 5u8 6u8


//# publish
module 0xCAFE::TestLambda {
    /// Uses a lambda to multiply two u8 inputs and then adds 1
    public fun multiply_plus_one(x: u8, y: u8): u8 {
        let mul: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        let prod = mul(x, y);
        prod + 1u8
    }

    /// Uses a lambda that returns a tuple and returns the first element after adding 2
    public fun lambda_tuple(x: u8, y: u8): u8 {
        let f: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| { (a+b, a*b) };
        let (sum, _) = f(x, y);
        sum + 2u8
    }
}


//# run 0xCAFE::TestLambda::multiply_plus_one --args 3u8 4u8


//# run 0xCAFE::TestLambda::lambda_tuple --args 3u8 4u8


//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAdd;

    /// Calls TestAdd::add_and_offset twice with inline function call pattern
    public fun double_call(x: u8, y: u8): u8 {
        let first = TestAdd::add_and_offset(x, y);
        let second = TestAdd::add_and_offset(first, first);
        second
    }
}


//# run 0xCAFE::TestInlineCall::double_call --args 1u8 2u8


//# publish
module 0xCAFE::ModuleChecker {
    /// Queries the address and module name, and returns a boolean if address and module name match hardcoded ones
    public fun is_module_0xCAFE_TestAdd(addr: address, name: vector<u8>): bool {
        use std::vector;
        let expected_addr = @0xCAFE;
        let expected_name = b"TestAdd";
        if (addr == expected_addr && vector::length<u8>(&name) == vector::length<u8>(&expected_name)) {
            let i = 0;
            while (i < vector::length<u8>(&name)) {
                if (*vector::borrow(&name, i) != *vector::borrow(&expected_name, i)) {
                    return false;
                };
                i = i + 1;
            };
            true
        } else {
            false
        }
    }

    /// Runner function to verify module availability test with hardcoded args
    public fun runner(): bool {
        is_module_0xCAFE_TestAdd(@0xCAFE, b"TestAdd")
    }
}


//# run 0xCAFE::ModuleChecker::runner


//# publish
module 0xCAFE::RangeBindings {
    use std::vector;

    /// A binding struct that associates a value with a start and end u64 range
    struct Binding {
        value: u8,
        start: u64,
        end: u64,
    }

    /// Returns a vector of bindings for demonstration
    public fun create_bindings(): vector<Binding> {
        let b1 = Binding {value: 1u8, start: 0u64, end: 10u64};
        let b2 = Binding {value: 2u8, start: 11u64, end: 20u64};
        let b3 = Binding {value: 3u8, start: 21u64, end: 30u64};

        vector::push_back(&mut (vector::empty<Binding>()), b1)
    }

    /// Demonstrates creation and extension of binding vector properly
    public fun run_bindings(): u64 {
        let bindings = vector::empty<Binding>();
        let b1 = Binding {value: 5u8, start: 100u64, end: 200u64};
        let b2 = Binding {value: 6u8, start: 201u64, end: 300u64};
        let b3 = Binding {value: 7u8, start: 301u64, end: 400u64};

        let bs = bindings;
        vector::push_back(&mut bs, b1);
        vector::push_back(&mut bs, b2);
        vector::push_back(&mut bs, b3);

        let sum_ranges = 0u64;
        let i = 0;
        while (i < vector::length(&bs)) {
            let bind = vector::borrow(&bs, i);
            sum_ranges = sum_ranges + (bind.end - bind.start);
            i = i + 1;
        };
        sum_ranges
    }
}


//# run 0xCAFE::RangeBindings::run_bindings


//# publish
module 0xCAFE::TestConstSafety {
    /// Demonstrates division by zero that will abort at runtime
    public fun div_by_zero(x: u8): u8 {
        let y = 0u8;
        let _ = x / y;
        x
    }

    /// Demonstrates modulo by zero that will abort at runtime
    public fun mod_by_zero(x: u8): u8 {
        let y = 0u8;
        let _ = x % y;
        x
    }

    /// Demonstrates overflow in constant addition, must abort at runtime if triggers
    public fun const_overflow(): u8 {
        let max = 255u8;
        let _ = max + 1u8;
        max
    }

    /// Demonstrates out-of-range cast from u64 to u8, must abort if actual out of range value is used
    public fun cast_out_of_range(): u8 {
        let big: u64 = 300u64;
        let _val = big as u8;
        0u8
    }
}


//# run 0xCAFE::TestConstSafety::div_by_zero --args 1u8


//# run 0xCAFE::TestConstSafety::mod_by_zero --args 1u8


//# run 0xCAFE::TestConstSafety::const_overflow


//# run 0xCAFE::TestConstSafety::cast_out_of_range


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e87106f80712480056aeec2d1bc4337d: Determine if a module under a specific address and name is available in the current context.
// 45a545cd7fe6a24a5e87b8a59814aafb: Create lists of bindings where each binding can be annotated or connected to a range value
// 3791ac15e9d738e5bd320f39ae9a7a6b: Test that constant expressions which would cause overflows, division/modulo by zero, or out-of-range type casts are not silently simplified away and correctly abort at runtime.
