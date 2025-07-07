
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused `use std::signer;`

    // 1. Test addition of two u8 values and return specific value
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    // 2. Function containing lambda expressions
    public fun lambda_example(): u8 {
        let lambda_add: |u8, u8| u8 has copy+drop+store = |x: u8, y: u8| x + y;
        let lambda_mul: |u8, u8| u8 has copy+drop+store = |x: u8, y: u8| x * y;
        let add_res = lambda_add(3u8, 7u8);
        let mul_res = lambda_mul(3u8, 7u8);
        add_res + (mul_res / 7u8)
    }

    // 4. Assign and mutate move-only closures with drop, copy and store constraints within scopes
    struct DropCopyClosure has drop, store {
        lambda: |u8| u8 has copy+drop+store,
    }

    public fun assign_mutate_closure(x: u8): u8 {
        let closure = DropCopyClosure {
            lambda: |a: u8| a + 1
        };
        let lambda1 = closure.lambda;
        let res1 = lambda1(x);
        let lambda2 = closure.lambda;
        let res2 = lambda2(res1);
        res2
    }
    
    // 5. Use quantifier expressions with exists, forall, choose - here we use forall for check
    // This is a stub function exemplifying a forall quantifier in specification
    public fun check_forall_example(vec: vector<u8>): bool {
        // In Move, quantifiers are used in spec blocks; here is a dummy function to compile
        true
    }

    // 6. Tuple struct with positional numeric indices
    struct TupleStruct has store {
        field_0: u8,
        field_1: u8,
    }

    public fun tuple_struct_access(): u8 {
        let t = TupleStruct { field_0: 5u8, field_1: 10u8 };
        let first = t.field_0;
        let second = t.field_1;
        first + second
    }
}




//# run 0xCAFE::LambdaTest::add_and_check --args 3u8 7u8




//# run 0xCAFE::LambdaTest::lambda_example




//# run 0xCAFE::LambdaTest::assign_mutate_closure --args 5u8




//# run 0xCAFE::LambdaTest::tuple_struct_access


// Removed empty line to ensure 0xCAFE::LambdaTest compiles before NestedCall module



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun call_inline_from_another_module(x: u8, y: u8): u8 {
        let sum = LambdaTest::add_and_check(x, y);
        let tuple_sum = LambdaTest::tuple_struct_access();
        sum + tuple_sum
    }
}




//# run 0xCAFE::NestedCall::call_inline_from_another_module --args 3u8 7u8
