
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        f(x)
    }

    public inline fun caller_inline(a: u16): u32 {
        // Calls 0xCAFE::NestedInline::inline_add_and_cast from this module
        let (x, y) = 0xCAFE::NestedInline::inline_add(a);
        (x + y) as u32
    }

    struct GenStruct<T> has copy, drop {
        field: T
    }

    public fun instantiate_gen_struct_u8(x: u8): GenStruct<u8> {
        GenStruct<u8> { field: x }
    }

    public fun instantiate_gen_struct_call_inline_param(a: u16): GenStruct<u32> {
        let result = caller_inline(a);
        GenStruct<u32> { field: result }
    }

    public fun use_block_scope_import(a: u8, b: u8): u8 {
        {
            use 0xCAFE::ComputeAdd;
            ComputeAdd::add_two_values(a, b)
        }
    }
}


//# run 0xCAFE::ComputeAdd::add_two_values --args 12u8 5u8


//# run 0xCAFE::ComputeAdd::lambda_example --args 7u8


//# run 0xCAFE::ComputeAdd::caller_inline --args 20u16


//# run 0xCAFE::ComputeAdd::instantiate_gen_struct_u8 --args 123u8


//# run 0xCAFE::ComputeAdd::instantiate_gen_struct_call_inline_param --args 15u16


//# run 0xCAFE::ComputeAdd::use_block_scope_import --args 8u8 9u8


//# publish
module 0xCAFE::NestedInline {
    public inline fun inline_add(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }
}


//# run 0xCAFE::NestedInline::inline_add --args 50u16


//# publish
module 0xCAFE::HashUtil {
    use std::hash;
    use std::vector;

    public fun compute_source_hash(): vector<u8> {
        let src_bytes = b"module 0xCAFE::ComputeAdd { public fun add_two_values(x: u8, y: u8): u8 { let sum = x + y; sum + 10u8 } public fun lambda_example(x: u8): u8 { let f: |u8|u8 has copy+drop = |a: u8| { a * 2 }; f(x) } public inline fun caller_inline(a: u16): u32 { let (x, y) = 0xCAFE::NestedInline::inline_add(a); (x + y) as u32 } struct GenStruct<T> has copy, drop { field: T } public fun instantiate_gen_struct_u8(x: u8): GenStruct<u8> { GenStruct<u8> { field: x } } public fun instantiate_gen_struct_call_inline_param(a: u16): GenStruct<u32> { let result = caller_inline(a); GenStruct<u32> { field: result } } public fun use_block_scope_import(a: u8, b: u8): u8 { { use 0xCAFE::ComputeAdd; ComputeAdd::add_two_values(a, b) } } } module 0xCAFE::NestedInline { public inline fun inline_add(a: u16): (u16, u16) { (a + 10, a + 20) } }";
        hash::sha3_256(&src_bytes)
    }
}


//# run 0xCAFE::HashUtil::compute_source_hash


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// fa09991c70ad2489dd408fee816518bc: Use type parameters in the types of struct fields.
// e8bfbbe8f9b7e36b69b5ae1aabb4fdf3: Import names into block scope using 'use' statements at the beginning of a block.
// 49158e3d64e894f5a04cd6118227de39: Calculate and generate a unique hash of the Move source file content.
