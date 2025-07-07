
//# publish
module 0xCAFE::ComputeAdd {
    // Test that the function correctly computes addition of two u8 values before returning a specific value

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun run_lambda_test(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 20u8)
    }

    fun pack_struct_example(): MyStruct {
        // Only allowed inside the defining module
        MyStruct { x: 1u8, y: 2u8 }
    }

    fun unpack_struct_example(s: &MyStruct): u8 {
        s.x + s.y
    }

    fun pack_enum_example(): MyEnum {
        MyEnum::VariantA {}
    }

    fun unpack_enum_example(e: &MyEnum): u8 {
        let val = match *e {
            MyEnum::VariantA {} => 100u8,
            MyEnum::VariantB(x) => x,
        };
        val
    }

    struct MyStruct has copy, drop, store {
        x: u8,
        y: u8
    }

    enum MyEnum has copy, drop {
        VariantA {},
        VariantB(u8)
    }

    // Public runner function to call pack_struct_example and unpack_struct_example
    public fun struct_runner(): u8 {
        let s = pack_struct_example();
        unpack_struct_example(&s)
    }

    // Public runner function to call pack_enum_example and unpack_enum_example
    public fun enum_runner(): u8 {
        let e = pack_enum_example();
        unpack_enum_example(&e)
    }

    // Public runner that calls add_and_return_sum via inline call from another module
    public fun nested_inline_call(): u8 {
        0xCAFE::InlineCaller::call_inline_add(30u8, 40u8)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::ComputeAdd;

    public inline fun call_inline_add(a: u8, b: u8): u8 {
        ComputeAdd::add_and_return_sum(a, b)
    }
}



//# publish
module 0xCAFE::StoreAbilityTest {
    // Define a struct with a field named STORE and with store ability
    struct Token has store {
        STORE: u64,
    }

    public fun create_token(value: u64): Token {
        Token { STORE: value }
    }

    public fun get_token_value(t: &Token): u64 {
        t.STORE
    }

    public fun use_store_ability(): u64 {
        let t = create_token(1234);
        let Token { STORE: _ } = t; // consume t to avoid drop error
        get_token_value(&t)
    }
}



//# run 0xCAFE::ComputeAdd::add_and_return_sum --args 15u8 27u8



//# run 0xCAFE::ComputeAdd::run_lambda_test



//# run 0xCAFE::ComputeAdd::struct_runner



//# run 0xCAFE::ComputeAdd::enum_runner



//# run 0xCAFE::ComputeAdd::nested_inline_call



//# run 0xCAFE::StoreAbilityTest::use_store_ability


// Controlling logging output is outside Move code capability
// Instead, add a comment instructing environment variable setup for logging:

// NOTE: To control logging output of the Move compiler:
// set environment variable MOVE_COMPILED_LOG_LEVEL=debug
// set environment variable MOVE_COMPILED_LOG_FILE=compile_log.txt
// before running move commands outside of this test.


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 86eed430ce650ec8aabb24a55574ea92: Recognize the 'Store' ability when the token is an identifier with content 'STORE'.
// 71dc097012aed9aeb3db6d1569553f33: Restrict packing (constructing) and unpacking (destructuring) of structs and enums to the module that defines them.
// bd1017e17faf5ea5b8da39f82b2b1350: Control logging output of the Move compiler by setting an environment variable to specify logging verbosity and output file.
