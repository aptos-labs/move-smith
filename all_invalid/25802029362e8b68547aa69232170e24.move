
//# publish
module 0xCAFE::ExprTransform {
    use std::vector;

    // A dummy compiler context struct
    struct CompilerCtx has copy, drop {
        id: u8,
    }

    // Expression representation
    struct Exp has copy, drop {
        val: u8,
    }

    // Function to transform a single expression in a context
    public fun exp_(ctx: &CompilerCtx, e: Exp): Exp {
        // Artificially create a new Exp by adding ctx.id and e.val
        Exp { val: ctx.id + e.val }
    }

    // Transform a vector of expressions by applying exp_ to each
    public fun exps(ctx: &CompilerCtx, exprs: vector<Exp>): vector<Exp> {
        let result = vector::empty<Exp>();
        let n = vector::length(&exprs);
        let i = 0;
        loop {
            if (i == n) {
                break;
            };
            let e = *vector::borrow(&exprs, i);
            let e2 = exp_(ctx, e);
            vector::push_back(&mut result, e2);
            i = i + 1;
        };
        result
    }

    // Runner function to test exps function with hardcoded data
    public fun run_exp_transform(): u8 {
        let ctx = CompilerCtx { id: 10 };
        let exprs = vector[
            Exp { val: 1 },
            Exp { val: 2 },
            Exp { val: 3 }
        ];
        let res = exps(&ctx, exprs);
        // Sum results and return as u8
        let sum = 0;
        let len = vector::length(&res);
        let idx = 0;
        loop {
            if (idx == len) {
                break;
            };
            let e = *vector::borrow(&res, idx);
            sum = sum + e.val;
            idx = idx + 1;
        };
        sum
    }
}


//# run 0xCAFE::ExprTransform::run_exp_transform


//# run
script {
    // Testing nested control flow: loop, break, if-else

    let x: u8 = 0;

    loop {
        if (x >= 5) {
            break;
        };
        if (x % 2 == 0) {
            x = x + 3;
        } else {
            let y = 0;
            loop {
                if (y >= 2) {
                    break;
                };
                x = x + 1;
                y = y + 1;
            };
        };
    };

    // Check final value of x just to have a last expression
    x
}


//# publish
module 0xCAFE::ScriptVerifier {
    // Verify a simple script by returning true
    // Dummy placeholder for verify_script behavior
    public fun verify_script(script_bytes: vector<u8>): bool {
        // Pretend verification returns true always
        true
    }
}


//# run 0xCAFE::ScriptVerifier::verify_script --args vector<u8>[1u8, 2u8, 3u8, 4u8]


// Featurres:
// e4f4fb756ae16b178004ed92b279c472: Use the 'exps' function to transform a list of Move expressions into another form, applying the 'exp_' function to each expression within a compiler context.
// 8d2eefbd9d86473714359d04d5e3ff42: Use the verify_script function to automatically verify scripts for correctness before deployment.
// 23fb466a672110aec25bfb13409d64ed: Test that nested loop and conditional control flow statements (loop, break, loop break, if-else) execute without error in a Move script.
