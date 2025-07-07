
//# publish
module 0xCAFE::Adder {
    // Simple addition module to test computing sum of two u8 values

    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = add_two(a, b);
        sum + 10u8
    }

    public fun runner(): u8 {
        add_with_offset(5u8, 7u8)
    }
}



//# run 0xCAFE::Adder::runner




//# publish
module 0xCAFE::LambdaExamples {
    // Module showcasing lambda (anonymous functions) usage.

    // Move does not support closures or lambdas in this style.
    // We'll rewrite these functions without lambdas.

    public fun lambda_identity(x: u8): u8 {
        // Identity function can just return x
        x
    }

    public fun lambda_sum_product(a: u8, b: u8): (u8, u8) {
        // Direct implementation instead of using a lambda
        (a + b, a * b)
    }

    public fun lambda_copied_call(a: u8, b: u8): u8 {
        // simulate call by directly computing sum
        let sum = a + b;
        sum
    }

    public fun runner(): (u8, u8, u8) {
        let id_result = lambda_identity(42u8);
        let (sum, product) = lambda_sum_product(3u8, 4u8);
        let sum_from_copy = lambda_copied_call(5u8, 6u8);
        (id_result, product, sum_from_copy)
    }
}



//# run 0xCAFE::LambdaExamples::runner




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Adder;

    // Calls inline function in adder module and unwraps tuple returned by inline function.

    public inline fun inline_addition_wrapper(a: u16): u16 {
        let (x, y) = add_one_and_two(a);
        x + y
    }

    // Inline function returning a tuple
    public inline fun add_one_and_two(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Call the Adder module add_two u8 function and add 1u8
    public fun call_adder_add_two(a: u8, b: u8): u8 {
        let sum = Adder::add_two(a, b);
        sum + 1u8
    }

    public fun runner1(): u16 {
        inline_addition_wrapper(10u16)
    }

    public fun runner2(): u8 {
        call_adder_add_two(4u8, 5u8)
    }
}



//# run 0xCAFE::InlineCaller::runner1



//# run 0xCAFE::InlineCaller::runner2




//# publish
module 0xCAFE::MoveCopyTest {
    // Tests move and copy semantics by moving and copying structs and values.

    struct MyStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun create_struct(a: u8, b: u8): MyStruct {
        MyStruct { a, b }
    }

    public fun move_struct(s: MyStruct): MyStruct {
        s
    }

    public fun copy_struct(s: &MyStruct): MyStruct {
        *s
    }

    public fun copy_then_move(): (MyStruct, MyStruct) {
        let s = create_struct(10u8, 20u8);
        let s_ref = &s;
        let s_copy = copy_struct(s_ref);
        let s_moved = move_struct(s);
        (s_copy, s_moved)
    }
    
    public fun runner(): u8 {
        let (s1, s2) = copy_then_move();
        s1.a + s2.b
    }
}



//# run 0xCAFE::MoveCopyTest::runner




//# publish
module 0xCAFE::TupleMultiValue {
    // Tests multi-value expression lists with tuples and unpacking

    public fun multi_value_tuple(): (u8, bool, u16) {
        (7u8, true, 300u16)
    }

    public fun use_tuple(): u16 {
        let (x, y, z) = multi_value_tuple();
        if (y) { (z + (x as u16)) } else { 0u16 };
        z
    }

    public fun runner(): (u8, u16) {
        let (a, _, b) = multi_value_tuple();
        (a, b)
    }
}



//# run 0xCAFE::TupleMultiValue::runner




//# run 0xCAFE::Adder::add_two --args 100u8 55u8



//# run 0xCAFE::LambdaExamples::lambda_sum_product --args 9u8 8u8



//# run 0xCAFE::InlineCaller::call_adder_add_two --args 23u8 34u8



//# run 0xCAFE::MoveCopyTest::copy_then_move



//# run 0xCAFE::TupleMultiValue::use_tuple
