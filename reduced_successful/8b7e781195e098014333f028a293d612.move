
//# publish
module 0xCAFE::AddModule {
    /// A simple function that adds two u8 numbers and returns the sum plus 10.
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Function that defines and uses a lambda (anonymous function)
    public fun apply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * 2 + y
        };
        lambda(a, b)
    }

    /// Function with detailed specification
    spec add_with_offset_spec {
        ensures result >= 10;
        ensures result == a + b + 10;
    }
    public fun add_with_offset_spec(a: u8, b: u8): u8 {
        add_with_offset(a, b)
    }

    /// Struct with nested fields for dotted expression navigation
    struct Inner has copy, drop, store {
        val: u8
    }

    struct Outer has copy, drop, store {
        inner: Inner
    }

    /// Function returning Outer struct
    public fun make_outer(val: u8): Outer {
        Outer { inner: Inner { val } }
    }

    /// Function to read nested value from Outer using dotted expression
    public fun get_inner_val(o: &Outer): u8 {
        o.inner.val
    }
}


//# run 0xCAFE::AddModule::add_with_offset --args 5u8 6u8


//# run 0xCAFE::AddModule::apply_lambda --args 3u8 4u8


//# run 0xCAFE::AddModule::add_with_offset_spec --args 1u8 2u8


//# run 0xCAFE::AddModule::make_outer --args 42u8


//# run 0xCAFE::AddModule::get_inner_val --args 42u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 97f7d9164de5cd41f238dd6790868109: Create Move functions that include specifications for detailed behavior description.
// c51d3d63bcb2131b419ec38bcbdd6fd8: Navigate through dotted expression structures to reference deeper components or properties.
