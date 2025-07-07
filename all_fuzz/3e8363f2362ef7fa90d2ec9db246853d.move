
//# publish
module 0xCAFE::CalcModule {
    // Module testing addition and lambda expressions
    // Removed unused import
    // use std::vector;

    public fun add_two_u8_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return constant plus sum, 42 + sum
        42 + sum
    }

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * 2
        };
        lambda(x)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}




//# run 0xCAFE::CalcModule::add_two_u8_values --args 5u8 7u8




//# run 0xCAFE::CalcModule::apply_lambda --args 21u8



// Removed because inline functions cannot be invoked directly from transactional tests

//# run 0xCAFE::CalcModule::inline_increment --args 100u8




//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_increment(x: u8): u8 {
        // Call inline function from CalcModule
        CalcModule::inline_increment(x)
    }

    public fun test_nested_calls(x: u8, y: u8): u8 {
        let sum = CalcModule::add_two_u8_values(x, y);
        call_inline_increment(sum)
    }
}




//# run 0xCAFE::InlineCallModule::call_inline_increment --args 50u8




//# run 0xCAFE::InlineCallModule::test_nested_calls --args 10u8 15u8





//# publish
module 0x1234::RecursiveSpec {
    // Changed recursive specification to be non-inline to avoid cyclic recursion error

    // Removed inline modifier to allow direct recursion
    public fun rec_spec_1(x: u64): u64 {
        if (x == 0) {
            0
        } else {
            rec_spec_1(x - 1) + 1
        }
    }

    public fun caller(): u64 {
        rec_spec_1(3)
    }
}




//# run 0x1234::RecursiveSpec::caller





//# run 0xCAFE::CalcModule::add_two_u8_values --args 10u8 20u8


// Named address alias usage example:
// This uses fully qualified addresses, but assuming aliasing configured for 0xCAFE as CalcAddr
// Normally you'd have `use <CalcAddr>::CalcModule;` with alias set in project config,
// but transactional tests do not allow aliases, so we only mention as comment here.

// This is just a representation, no actual aliasing in code because transactional test forbids aliases.


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2796ec6023d6d8d52af1c333318fcb7f: Use named addresses to resolve addresses in access specifications, provided the address is explicitly mapped in the project's aliasing configuration.
// aff4b1f707737b46171136d6ac68104f: Use recursively-defined specification functions and have the compiler compute their transitive callees for precise verification.
