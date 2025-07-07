
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
        // Calls 0xCAFE::NestedInline::inline_add from this module
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

    public fun compute_source_hash(): vector<u8> {
        let src_bytes = b"module 0xCAFE::ComputeAdd { public fun add_two_values(x: u8, y: u8): u8 { let sum = x + y; sum + 10u8 } public fun lambda_example(x: u8): u8 { let f: |u8|u8 has copy+drop = |a: u8| { a * 2 }; f(x) } public inline fun caller_inline(a: u16): u32 { let (x, y) = 0xCAFE::NestedInline::inline_add(a); (x + y) as u32 } struct GenStruct<T> has copy, drop { field: T } public fun instantiate_gen_struct_u8(x: u8): GenStruct<u8> { GenStruct<u8> { field: x } } public fun instantiate_gen_struct_call_inline_param(a: u16): GenStruct<u32> { let result = caller_inline(a); GenStruct<u32> { field: result } } public fun use_block_scope_import(a: u8, b: u8): u8 { { use 0xCAFE::ComputeAdd; ComputeAdd::add_two_values(a, b) } } } module 0xCAFE::NestedInline { public inline fun inline_add(a: u16): (u16, u16) { (a + 10, a + 20) } }";
        hash::sha3_256(src_bytes)
    }
}



//# run 0xCAFE::HashUtil::compute_source_hash
