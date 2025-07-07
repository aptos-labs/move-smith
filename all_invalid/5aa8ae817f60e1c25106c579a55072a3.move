
//# publish
module 0xCAFE::SpecAndEnumLambda {
    use std::vector;

    /// Native specification function example
    native fun native_spec_fun(x: u64): u64;

    spec fun spec_fun(x: u64): u64 {
        x + 10
    }

    /// Define an enum with multiple named variants, each with own fields and positional variant
    enum ComplexEnum has copy, drop {
        VariantOne { a: u8, b: u16 },
        VariantTwo(u64, bool),
        VariantThree { x: bool },
        VariantFour,
    }

    /// Return a value based on matching on the ComplexEnum
    public fun match_enum(e: ComplexEnum): u64 {
        let res = match e {
            ComplexEnum::VariantOne { a, b } => (a as u64) + (b as u64),
            ComplexEnum::VariantTwo(x, flag) => if (flag) { x } else { 0 },
            ComplexEnum::VariantThree { x } => if (x) { 1u64 } else { 2u64 },
            ComplexEnum::VariantFour => 42u64,
        };
        res
    }

    /// Lambda without explicit capture
    public fun lambda_no_capture(x: u8, y: u8): u8 {
        let lam: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b + x
        };
        lam(x, y)
    }

    /// Lambda with explicit copy capture
    public fun lambda_with_capture(x: u8, y: u8): u8 {
        let lam: |u8, u8| u8 has copy+drop = copy |a: u8, b: u8| {
            a * b + x
        };
        lam(x, y)
    }

    /// Runner function to exercise all above features
    public fun runner() {
        // Use native spec function in a spec block (which is detached from runtime)
        spec {
            let _ = native_spec_fun(100);
            let _ = spec_fun(100);
        };

        // Create enum variants and match on them
        let v1 = ComplexEnum::VariantOne { a: 5, b: 10 };
        let v2 = ComplexEnum::VariantTwo(20u64, true);
        let v3 = ComplexEnum::VariantThree { x: false };
        let v4 = ComplexEnum::VariantFour;

        let _ = match_enum(v1);
        let _ = match_enum(v2);
        let _ = match_enum(v3);
        let _ = match_enum(v4);

        // Use lambdas
        let _ = lambda_no_capture(2, 3);
        let _ = lambda_with_capture(4, 5);
    }
}



//# run 0xCAFE::SpecAndEnumLambda::runner


// Features:
// f3a04639cbf00572c112bac1cda633ed: Define specification functions or native specification functions using the 'fun' or 'native' keywords in spec blocks.
// 8248d516eaee8c132040c2cb556f60a2: Define structs as enums with multiple named variants, each with their own fields and position style.
// 457c1642c34ca57f9ecfa3ded7123046: Define lambda expressions with or without explicit capture kind.
