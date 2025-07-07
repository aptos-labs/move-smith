
//# publish
module 0xCAFE::AttributeTest {
    use std::vector;

    // test]
    public fun test_simple() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 42);
    }

    // test]
    // inline]
    public fun test_multiple_attributes() {
        let x = 5u8;
        let lambda: |u8|u8 has copy+drop = |a: u8| { a + x };
        let _res = lambda(10u8);
    }

    // test]
    public fun test_empty_vec() {
        let v: vector<u8> = vector[];
        let v2: vector<vector<u8>> = vector[vector[], vector[]];
    }

    // Generic function taking a function as argument
    // test]
    public fun generic_fun_type<F: copy+drop>(f: F, x: u8): u8
        where F: |u8|u8
    {
        f(x)
    }

    // Runner method to invoke the generic function with a lambda
    // test]
    public fun runner() {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let _res = generic_fun_type(add_one, 10u8);
    }
}


//# run 0xCAFE::AttributeTest::test_simple


//# run 0xCAFE::AttributeTest::test_multiple_attributes


//# run 0xCAFE::AttributeTest::test_empty_vec


//# run 0xCAFE::AttributeTest::runner


// Featurres:
// a9d2adcb1f17b70532c07980a4451c57: Annotate Move items (modules, functions, etc.) with single or multiple attributes.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// f0b018110a66295be45449caa5ffcaac: Permit empty item lists between supported delimiters by omitting elements entirely.
// e003a7dfb459df4e1f343a32890d3391: Define generic function types that accept functions as arguments.
// 9813d01e7c0cc1c0e64383ab4f725517: Use test attributes with the syntax `#[test]` in Move code to mark test functions or modules.
