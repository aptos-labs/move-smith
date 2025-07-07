
//# publish
module 0xCAFE::LambdaAdd {
    // This module illustrates addition using lambdas and tests u8 addition returning specific values.

    public fun add_two_u8(a: u8, b: u8): u8 {
        let add = |x: u8, y: u8| {
            x + y
        };
        let sum = add(a, b);

        if (sum == 42) {
            100u8
        } else {
            sum
        }
    }

    public fun lambda_identity(x: u8): u8 {
        let id = |v: u8| v;
        id(x)
    }

    public fun add_lambda_and_identity(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| a + b;
        let id = |v: u8| v;

        let s = add(x, y);
        id(s)
    }
}


//# run 0xCAFE::LambdaAdd::add_two_u8 --args 21u8 21u8


//# run 0xCAFE::LambdaAdd::add_two_u8 --args 20u8 20u8


//# run 0xCAFE::LambdaAdd::lambda_identity --args 55u8


//# run 0xCAFE::LambdaAdd::add_lambda_and_identity --args 30u8 40u8



//# publish
module 0xCAFE::InlineCaller {
    // Since 0xCAFE::MyModule doesn't exist, we implement the needed parts inline here.

    // Define the struct S used in previous code
    struct S has copy, drop, store {
        x: u32,
        y: u32,
    }

    // Define function f2 returning values via out params, since tuples are not allowed
    public fun f2(a: u16, out_b: &mut u16, out_c: &mut u16) {
        // For demonstration, return (a, a + 1)
        *out_b = a;
        *out_c = a + 1;
    }

    public fun call_inline_f2(a: u16): (u16, u16) {
        let b: u16 = 0;
        let c: u16 = 0;
        Self::f2(a, &mut b, &mut c);

        (b, c)
    }

    public fun call_nested_inline(a: u16): u32 {
        let b: u16 = 0;
        let c: u16 = 0;
        Self::f2(a, &mut b, &mut c);

        let s = Self::S {x: b as u32, y: c as u32};
        s.x + s.y
    }

    public fun test_references(a: u16): (u16, u16) {
        let b: u16 = 0;
        let c: u16 = 0;
        Self::f2(a, &mut b, &mut c);

        (b, c)
    }

    public fun test_mut_references(): u8 {
        let val = 10u8; // val must be mutable to take mutable references
        let r: &mut u8 = &mut val;
        *r = *r + 5;

        val
    }
}


//# run 0xCAFE::InlineCaller::call_inline_f2 --args 10u16


//# run 0xCAFE::InlineCaller::call_nested_inline --args 20u16


//# run 0xCAFE::InlineCaller::test_references --args 15u16


//# run 0xCAFE::InlineCaller::test_mut_references



//# publish
module 0xCAFE::AstSimplifyTest {
    // This module is a stub to demonstrate partial AST simplification without code elimination
    // when the 'AST_SIMPLIFY' experiment is active.

    public fun conditional_no_elimination(x: u8): u8 {
        if (x > 5) {
            let _a = x + 1;
            x
        } else {
            let _b = x + 2;
            x
        }
    }
}


//# run 0xCAFE::AstSimplifyTest::conditional_no_elimination --args 4u8


//# run 0xCAFE::AstSimplifyTest::conditional_no_elimination --args 10u8
