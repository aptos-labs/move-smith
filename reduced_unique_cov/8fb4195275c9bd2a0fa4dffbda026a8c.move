
//# publish
module 0xCAFE::AddModule {
    /// Adds two u8 values and returns their sum plus a constant offset.
    public fun add_values_with_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        let offset = 5u8;
        sum + offset
    }

    /// Returns a lambda that adds two u8 values and returns the result multiplied by 2.
    public fun get_double_sum_lambda(): |u8, u8| u8 {
        |a: u8, b: u8| {
            let s = a + b;
            s * 2u8
        }
    }

    /// Invokes the lambda returned by get_double_sum_lambda on given inputs.
    public fun run_double_sum_lambda(x: u8, y: u8): u8 {
        let lambda = get_double_sum_lambda();
        lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_values_with_offset --args 3u8 7u8


//# run 0xCAFE::AddModule::run_double_sum_lambda --args 2u8 4u8


//# publish
module 0xCAFE::LambdaTest {
    /// Returns a lambda that captures outer variable `outer` and shadows it with parameter `outer`.
    public fun shadow_variable_lambda(): |u8| u8 {
        let outer = 10u8;
        |outer: u8| {
            // Here `outer` parameter shadows outer variable.
            // This lambda returns sum of the parameter and outer variable declared outside, by renaming parameter.
            let ret = (outer) + (inner_outer());
            ret
        }
    }

    /// Helper inline function to return outer variable value - simulates capture of outer variable.
    public inline fun inner_outer(): u8 {
        10u8
    }

    /// Runs the lambda with shadowed variable.
    public fun run_shadow_lambda(x: u8): u8 {
        let l = shadow_variable_lambda();
        l(x)
    }
}


//# run 0xCAFE::LambdaTest::run_shadow_lambda --args 5u8


//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AddModule;

    /// Calls inline two-level nested functions and returns the sum of two u16 numbers plus a u32 checksum.
    public inline fun inline_sum(a: u16, b: u16): u16 {
        let add_inline = |x: u16, y: u16| (x + y);
        let temp = add_inline(a, b);
        temp
    }

    /// Calls AddModule::add_values_with_offset but adds additional computation from inline_sum.
    public fun combined_call(x: u8, y: u8, a: u16, b: u16): u16 {
        let base = AddModule::add_values_with_offset(x, y); // u8
        let inline_result = inline_sum(a, b); // u16
        let combined = (base as u16) + inline_result;
        combined
    }
}


//# run 0xCAFE::InlineCallModule::combined_call --args 4u8 6u8 10u16 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0a56f083963dc467bc4b9bdc1981a01a: Test that a variable declared outside a lambda can be assigned within the lambda even if the parameter name shadows the outer variable.
