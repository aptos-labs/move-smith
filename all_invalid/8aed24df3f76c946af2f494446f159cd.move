
//# publish
module 0xCAFE::LambdaTest {
    /// Public function that sums two u8 values and returns the sum plus one.
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// Function containing a lambda that multiplies a u8 input by 2.
    public fun multiply_by_two_lambda(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |val: u8| {
            val * 2
        };
        doubler(x)
    }

    /// Combines lambda and closure capturing a local variable.
    public fun combine_lambda(a: u8, b: u8): u8 {
        let offset = 5u8;
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y + offset
        };
        adder(a, b)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    /// Calls the inline function add_and_increment from LambdaTest module.
    public fun call_add_and_increment(a: u8, b: u8): u8 {
        LambdaTest::add_and_increment(a, b)
    }
}



//# publish
module 0xCAFE::ShadowTest {
    /// A struct shadowing std::vector for testing shadowing feature.
    struct vector<T> has copy, drop, store {
        val: T,
    }

    /// Creates an instance of the shadowed vector struct.
    public fun create_vector_struct<T>(val: T): vector<T> {
        vector<T>[val]
    }

    /// Retrieves the stored value from the shadow vector struct.
    public fun get_val<T>(v: &vector<T>): &T {
        &v.val
    }
}



//# publish
module 0xCAFE::BindingList {
    /// A struct representing a value bound to an annotation with a range.
    struct BindingWithRange has copy, drop, store {
        annotation: vector<u8>,
        from: u8,
        to: u8,
        value: u8,
    }

    /// Creates a list of bindings with annotation and range values.
    public fun create_binding_list(): vector<BindingWithRange> {
        let binding1 = BindingWithRange {
            annotation: b"first",
            from: 1u8,
            to: 10u8,
            value: 100u8,
        };
        let binding2 = BindingWithRange {
            annotation: b"second",
            from: 11u8,
            to: 20u8,
            value: 200u8,
        };
        vector<BindingWithRange>[binding1, binding2]
    }
}



//# publish
module 0xCAFE::SpecModule {
    spec module {
        fun spec_addition(a: u8, b: u8): bool {
            let result = a + b;
            result > a
        }
    }

    /// A harmless function to bind spec presence.
    public fun dummy_fun(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::LambdaTest::add_and_increment --args 3u8 4u8



//# run 0xCAFE::LambdaTest::multiply_by_two_lambda --args 7u8



//# run 0xCAFE::LambdaTest::combine_lambda --args 2u8 8u8



//# run 0xCAFE::InlineCaller::call_add_and_increment --args 10u8 20u8



//# run 0xCAFE::ShadowTest::create_vector_struct --args 42u8



//# run 0xCAFE::BindingList::create_binding_list



//# run 0xCAFE::SpecModule::dummy_fun --args 5u8 6u8
