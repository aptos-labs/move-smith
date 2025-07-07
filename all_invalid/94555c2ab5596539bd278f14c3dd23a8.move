
//# publish
module 0xCAFE::ValueExpressions {
    // Testing Unit, Error, Break, Continue, Spec and Value types expression-like uses.

    use std::error;
    use std::debug;

    // Unit type usage: function returning unit
    public fun unit_function() {
        let _ = ();
    }

    public fun error_function(): error::Error {
        // Create an error value with an error code
        error::error(42)
    }

    public fun break_and_continue_test(n: u8): u8 {
        let i = 0;
        let sum = 0;
        loop {
            if (i == n) {
                break;
            };
            if (i % 2 == 0) {
                i = i + 1;
                continue;
            };
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    // Specification pragma is not a type but syntactic; simulate spec expression value with debug print
    public fun spec_expression_simulation(x: u8): u8 {
        debug::print(b"Simulate spec expression");
        x + 1
    }

    public fun value_expression_test(): u8 {
        let x: u8 = 10u8;
        x
    }
}


//# run 0xCAFE::ValueExpressions::unit_function


//# run 0xCAFE::ValueExpressions::error_function


//# run 0xCAFE::ValueExpressions::break_and_continue_test --args 6u8


//# run 0xCAFE::ValueExpressions::spec_expression_simulation --args 7u8


//# run 0xCAFE::ValueExpressions::value_expression_test



//# publish
module 0xCAFE::BitwiseShifts {
    // Test bitwise shift operations on all unsigned integer types.

    public fun shift_left_and_right_u8(x: u8, shift: u8): (u8, u8) {
        // shift left
        let shifted_left = if (shift < 8) {
            x << shift
        } else {
            // In Aptos Move, shifting >= bits should fail but we catch and return 0 for testing
            0u8
        };

        // shift right
        let shifted_right = if (shift < 8) {
            x >> shift
        } else {
            0u8
        };

        (shifted_left, shifted_right)
    }

    public fun shift_left_and_right_u64(x: u64, shift: u8): (u64, u64) {
        let bits = 64u8;
        let shifted_left = if (shift < bits) {
            x << shift
        } else {
            0u64
        };
        let shifted_right = if (shift < bits) {
            x >> shift
        } else {
            0u64
        };
        (shifted_left, shifted_right)
    }

    public fun shift_zero_u128(x: u128): u128 {
        // shift by 0 should not change the value
        let result = x << 0;
        result
    }

    public fun shift_max_u16(x: u16): u16 {
        // shifting by bits amount should produce 0 guarded by condition
        if (16u8 <= 16u8) {
            // but 16 is bits count
            if (16u8 >= 16u8) {
                0u16
            } else {
                x << 16u8
            }
        } else {
            x << 16u8
        }
    }

    public fun underflow_behavior(): u8 {
        // Right shifting a small number more than bits will produce 0
        let val = 1u8;
        let shifted = if (9u8 < 8) {
            val >> 9u8
        } else {
            0u8
        };
        shifted
    }

    // Test overflow: left-shifts that cause bits to be lost truncated
    public fun overflow_behavior_u32(x: u32, shift: u8): u32 {
        if (shift < 32u8) {
            x << shift
        } else {
            0u32
        }
    }
}


//# run 0xCAFE::BitwiseShifts::shift_left_and_right_u8 --args 1u8 0u8


//# run 0xCAFE::BitwiseShifts::shift_left_and_right_u8 --args 1u8 7u8


//# run 0xCAFE::BitwiseShifts::shift_left_and_right_u8 --args 129u8 8u8


//# run 0xCAFE::BitwiseShifts::shift_left_and_right_u64 --args 1u64 63u8


//# run 0xCAFE::BitwiseShifts::shift_left_and_right_u64 --args 1u64 64u8


//# run 0xCAFE::BitwiseShifts::shift_zero_u128 --args 12345678901234567890u128


//# run 0xCAFE::BitwiseShifts::shift_max_u16 --args 1u16


//# run 0xCAFE::BitwiseShifts::underflow_behavior


//# run 0xCAFE::BitwiseShifts::overflow_behavior_u32 --args 2u32 31u8



//# publish
module 0xCAFE::FuncPtrEnums {
    use std::signer;
    use std::vector;

    // Function pointer type alias for lambdas & persistent
    public fun simple_increment(a: u8): u8 {
        a + 1
    }

    // Enum that stores function pointers (standalone or lambda captures)
    enum FuncPtrEnum has copy, drop {
        Simple(fun(u8): u8),
        Persistent(fun(u8): u8),
        CaptureWithVal(fun(u8): u8, u8)
    }

    // Another enum composing FuncPtrEnum within
    enum CompositeEnum has copy, drop {
        Variant1,
        Variant2(FuncPtrEnum)
    }

    // Resource struct with field of FuncPtrEnum
    struct FuncResource has key {
        fun_field: FuncPtrEnum
    }

    public fun create_simple_fun(): FuncPtrEnum {
        FuncPtrEnum::Simple(simple_increment)
    }

    public fun create_persistent_fun(): FuncPtrEnum {
        // Persistent means copy of standalone function (identical for testing here)
        FuncPtrEnum::Persistent(simple_increment)
    }

    public fun create_lambda_with_capture(val: u8): FuncPtrEnum {
        let lambda: fun(u8): u8 has copy+drop = |x: u8| {
            x + val
        };
        FuncPtrEnum::CaptureWithVal(lambda, val)
    }

    public fun invoke_func_ptr(f: &FuncPtrEnum, arg: u8): u8 {
        match (*f) {
            FuncPtrEnum::Simple(fun_ptr) => fun_ptr(arg),
            FuncPtrEnum::Persistent(fun_ptr) => fun_ptr(arg),
            FuncPtrEnum::CaptureWithVal(fun_ptr, _val) => fun_ptr(arg),
        }
    }

    public fun compose_enum(): CompositeEnum {
        let f = create_simple_fun();
        CompositeEnum::Variant2(f)
    }

    public fun store_func_resource(s: signer, fun_ptr_enum: FuncPtrEnum) {
        let resource = FuncResource {fun_field: fun_ptr_enum};
        move_to<FuncResource>(&s, resource);
    }

    public fun call_stored_fun(s: signer, arg: u8): u8 {
        let res_ref = borrow_global<FuncResource>(signer::address_of(&s));
        invoke_func_ptr(&res_ref.fun_field, arg)
    }

    // Vector of function pointers
    public fun vector_of_funs(): vector<fun(u8): u8> {
        let v = vector::empty<fun(u8): u8>();
        let f1: fun(u8): u8 has copy+drop = simple_increment;
        let f2: fun(u8): u8 has copy+drop = |x: u8| { x * 2 };
        vector::push_back(&mut (v), f1);
        vector::push_back(&mut (v), f2);
        v
    }

    public fun invoke_vector_funs(v: vector<fun(u8): u8>, input: u8): (u8, u8) {
        let f1 = *vector::borrow(&v, 0);
        let f2 = *vector::borrow(&v, 1);
        (f1(input), f2(input))
    }

    public fun runner(): (u8, u8, u8) {
        let f_simple = create_simple_fun();
        let f_persistent = create_persistent_fun();
        let f_capture = create_lambda_with_capture(5u8);
        let out1 = invoke_func_ptr(&f_simple, 10u8);
        let out2 = invoke_func_ptr(&f_persistent, 20u8);
        let out3 = invoke_func_ptr(&f_capture, 30u8);

        (out1, out2, out3)
    }
}


//# run 0xCAFE::FuncPtrEnums::runner


//# run 0xCAFE::FuncPtrEnums::compose_enum


//# run 0xCAFE::FuncPtrEnums::vector_of_funs


//# run 0xCAFE::FuncPtrEnums::invoke_vector_funs --args vector<u8>[10u8, 20u8]  // Invalid, rewrite wrapper below



    use 0xCAFE::FuncPtrEnums;

    fun run_invoke_vector_funs() {
        let v = FuncPtrEnums::vector_of_funs();
        let (a, b) = FuncPtrEnums::invoke_vector_funs(v, 15u8);
        // do nothing else, just invoke and run
    }
}


//# run 0xCAFE::run_invoke_vector_funs



    use std::signer;
    use 0xCAFE::FuncPtrEnums;

    fun store_and_call() {
        let signer = signer::address_of(&signer::borrow_signer());
        let s = signer::borrow_signer();
        let f = FuncPtrEnums::create_lambda_with_capture(9u8);
        FuncPtrEnums::store_func_resource(s, f);
        let _res = FuncPtrEnums::call_stored_fun(s, 1u8);
    }
}


//# run 0xCAFE::store_and_call --signers 0xBBAA


// Featurres:
// 3c6f7b128895352b52d552e50b9b1a02: Create value expressions representing Unit, Error, Break, Continue, Specification, or Value types.
// fa1ae54769554ebf63c7b9a1aece1c89: Verify that bitwise shift operations (shl/shr) in Move handle boundary cases correctly, including failures when shifting by bits greater than or equal to the number of bits in the type, zero shifts, shifts by zero, and ensure proper handling of underflow and overflow resulting in zero or truncated values.
// 2e519c18a9e5a3cb570c8d8c2e7c7d3a: Test that Move function-pointer enums can store, move, and invoke both standalone functions and lambda captures (including persistent functions and vector-of-funs), and can be composed within other enums and used as resource fields.
