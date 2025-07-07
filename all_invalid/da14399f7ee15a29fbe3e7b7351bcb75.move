
//# publish
module 0xCAFE::EntryFunctionTest {
    use std::vector;
    use std::signer;

    // Internal function, should be accessible only within this module
    fun internal_increment(x: u64): u64 {
        x + 1
    }

    // Public entry point to invoke internal function and test execution flow
    public fun run_internal_increment(x: u64): u64 {
        internal_increment(x)
    }

    // Function testing local variable assignments inside a while loop
    public fun test_local_vars_in_loop(start: u64): u64 {
        let mut_count = start;
        let total = 0;
        while (mut_count < start + 5) {
            let local_var = mut_count;
            total = total + local_var;
            mut_count = mut_count + 1;
        };
        total
    }

    // Function testing variable shadowing
    public fun test_shadowing(x: u8): u8 {
        let x = x + 10; // shadow outer x
        let x = x * 2;  // shadow again
        x
    }

    // Internal function for vector::map test
    fun double_element(e: u8): u8 {
        e * 2
    }

    // Entry point to test vector map operation
    public fun test_vector_map(): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);
        let mapped = vector::map(&v, double_element);
        mapped
    }

    // Struct with type parameter, testing template instantiation
    struct GenericStruct<T> has copy, drop, store {
        val: T
    }

    // Instantiate with u64
    public fun create_u64_struct(val: u64): GenericStruct<u64> {
        let s = GenericStruct { val };
        s
    }

    // Instantiate with bool
    public fun create_bool_struct(val: bool): GenericStruct<bool> {
        let s = GenericStruct { val };
        s
    }

    // Function to verify that side effects occur; calling void function
    public fun side_effects(): () {
        // Assign to unit expression
        let _ = log_side_effect();
    }

    fun log_side_effect(): () {
        // Dummy side effect: no-op, but could be a print or dummy log
    }
}


//# run 0xCAFE::EntryFunctionTest::run_internal_increment --args 42u64


//# run 0xCAFE::EntryFunctionTest::test_local_vars_in_loop --args 10u64


//# run 0xCAFE::EntryFunctionTest::test_shadowing --args 5u8


//# run 0xCAFE::EntryFunctionTest::test_vector_map


//# run 0xCAFE::EntryFunctionTest::create_u64_struct --args 100u64


//# run 0xCAFE::EntryFunctionTest::create_bool_struct --args true


//# run 0xCAFE::EntryFunctionTest::side_effects


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// afcd1189a468c5f995c62e3ed503c280: Test that the std::vector::map function correctly maps over constant vectors with lambda functions in an entry function.
// 7bed143cecaa4a44ba2a9ddc13d7c0a5: Define structs with type parameters in your modules.
// 64d7361646fc89108c2c632e2bc5ac2f: Assign to unit expressions for side effects without value.
