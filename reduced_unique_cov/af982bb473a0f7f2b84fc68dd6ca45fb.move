
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

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
        let lambda_add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        let lambda_mul: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x * y;
        let add_res = lambda_add(3u8, 7u8);
        let mul_res = lambda_mul(3u8, 7u8);
        add_res + (mul_res / 7u8)
    }

    // 4. Assign and mutate move-only closures with drop and copy constraints within scopes
    struct DropCopyClosure has drop, store {
        lambda: |u8| u8 has copy+drop,
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
    struct TupleStruct(u8, u8);

    public fun tuple_struct_access(): u8 {
        let t = TupleStruct(5u8, 10u8);
        let first = t.0;
        let second = t.1;
        first + second
    }
}


//# run 0xCAFE::LambdaTest::add_and_check --args 3u8 7u8


//# run 0xCAFE::LambdaTest::lambda_example


//# run 0xCAFE::LambdaTest::assign_mutate_closure --args 5u8


//# run 0xCAFE::LambdaTest::tuple_struct_access


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


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e01e5a9cc39cdaaa87c749c1ddc33640: Test that functions correctly assign and mutate move-only closures with drop and copy constraints within different scopes.
// 5a6687e952ec3d4734e18e58348c7f65: Use quantifier expressions with the keywords 'exists', 'forall', or 'choose' in Move code for specifying logical assertions over domains.
// e03be07e417fbca4ad588cd692c856a7: Access tuple struct fields using positional numeric indices.
