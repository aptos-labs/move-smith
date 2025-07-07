
//# publish
module 0xCAFE::LambdaModule {
    // This module tests lambda expressions and reserved words as identifiers

    // A lambda that adds two u8 numbers and returns u8
    public fun use_lambda_add(): u8 {
        // Use u16 for intermediate calculation to avoid overflow, then cast to u8
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            // Use u16 addition to prevent overflow and then cast to u8 (safe here since 10+20=30 < 255)
            let sum = (a as u16) + (b as u16);
            sum as u8
        };
        add_lambda(10u8, 20u8)
    }

    // A lambda inside a lambda, demonstrating nested lambdas
    public fun nested_lambda(): u8 {
        // This previously caused ARITHMETIC_ERROR due to overflow: inner_lambda(y) * 2u8 = (5 + 1) * 2 = 12 fits in u8 fine,
        // but we should ensure safe calculation with casts.

        let inner_lambda: |u8| u8 has copy+drop = |x: u8| { x + 1u8 };
        let outer_lambda: |u8| u8 has copy+drop = |y: u8| {
            let val = inner_lambda(y);

            // Cast to u16 to multiply safely
            let mult = (val as u16) * 2u16;

            // Cast back to u8 because 12 fits in u8
            mult as u8
        };
        outer_lambda(5u8)
    }

    // Using reserved words as identifiers (variable names)
    public fun reserved_words() {
        let abort_ = 1u8;
        let acquires_ = 2u8;
        let as_ = 3u8;
        let break_ = 4u8;
        let const_ = 5u8;
        let continue_ = 6u8;
        let copy_ = 7u8;
        let else_ = 8u8;
        let false_ = 9u8;
        let fun_ = 10u8;
        let friend_ = 11u8;
        let if_ = 12u8;
        let invariant_ = 13u8;
        let let_ = 14u8;
        let loop_ = 15u8;
        let inline_ = 16u8;
        let module_ = 17u8;
        let move_ = 18u8;
        let native_ = 19u8;
        let public_ = 20u8;
        let return_ = 21u8;
        let script_ = 22u8;
        let spec_ = 23u8;
        let struct_ = 24u8;
        let true_ = 25u8;
        let use_ = 26u8;
        let while_ = 27u8;

        // Create sum to enforce usage
        let sum = abort_ + acquires_ + as_ + break_ + const_ + continue_ + copy_ + else_ + false_ +
                  fun_ + friend_ + if_ + invariant_ + let_ + loop_ + inline_ + module_ + move_ +
                  native_ + public_ + return_ + script_ + spec_ + struct_ + true_ + use_ + while_;

        // No return needed, just use semicolon
        let _ = sum;
    }

    // Runner function for all above in one call
    public fun runner(): (u8, u8) {
        let a = use_lambda_add();
        let b = nested_lambda();
        (a, b)
    }
}




//# run 0xCAFE::LambdaModule::use_lambda_add




//# run 0xCAFE::LambdaModule::nested_lambda




//# run 0xCAFE::LambdaModule::reserved_words




//# run 0xCAFE::LambdaModule::runner





//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::LambdaModule;

    // Call LambdaModule's inline lambdas via its public functions.

    public inline fun call_inline_add(): u8 {
        LambdaModule::use_lambda_add()
    }

    public fun runner(): u8 {
        let x = call_inline_add();

        // perform arithmetic on result to check value correctness
        let y = x * 2u8;

        y
    }
}




//# run 0xCAFE::CallInline::call_inline_add




//# run 0xCAFE::CallInline::runner
