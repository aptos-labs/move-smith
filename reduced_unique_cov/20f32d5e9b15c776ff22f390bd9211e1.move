
//# publish
module 0xCAFE::AttributeTest {
    use std::vector;

    // // test]
    public fun test_simple() {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 42);
    }

    // // test]
    // // inline]
    public fun test_multiple_attributes() {
        let x = 5u8;
        let lambda: |u8|u8 has copy+drop = |a: u8| { a + x };
        let _res = lambda(10u8);
    }

    // // test]
    public fun test_empty_vec() {
        let v: vector<u8> = vector[];
        let v2: vector<vector<u8>> = vector[vector[], vector[]];
    }

    // Generic function taking a function as argument
    // // test]
    public fun generic_fun_type<F: copy+drop + store + |u8|u8>(f: F, x: u8): u8
        // Note: Constraints must be inline in the generic param list
    {
        f(x)
    }

    // Runner method to invoke the generic function with a lambda
    // // test]
    public fun runner() {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let _res = generic_fun_type(add_one, 10u8);
    }
}



//# run 0xCAFE::AttributeTest::test_simple


//# run 0xCAFE::AttributeTest::test_multiple_attributes


//# run 0xCAFE::AttributeTest::test_empty_vec


//# run 0xCAFE::AttributeTest::runner
