//# publish
module 0xTEST::token_module {
    // This module defines a list with start and end tokens, nested enums with various patterns,
    // and functions to test pattern matching and nested function calls.

    use std::option;

    // Start and end tokens
    struct StartToken has copy, drop, store {
        value: u8,
    }

    struct EndToken has copy, drop, store {
        value: u8,
    }

    // Enum representing different list patterns with start/end tokens
    enum ListPattern {
        Empty,
        Single( /* contains one item */ u8),
        Cons( /* head, tail of list */ u8, Box<ListPattern>),
        // List with start and end tokens
        WithTokens(StartToken, Box<ListPattern>, EndToken),
    }

    // Nested enum with variants, including named fields
    enum NestedEnum {
        VariantA,
        VariantB { data: u64 },
        VariantC(Box<NestedEnum>),
        VariantD { x: u8, y: u16 },
    }

    // A complex enum with guards (simulated with functions)
    enum ComplexEnum {
        VariantX,
        VariantY(u8),
        VariantZ { flag: bool },
    }

    // Function to create a list with start/end tokens
    public fun create_list_with_tokens(list: ListPattern): ListPattern {
        let start = StartToken { value: 1 };
        let end = EndToken { value: 2 };
        ListPattern::WithTokens(start, Box::new(list), end)
    }

    // Function to perform pattern matching over nested enums
    public fun match_nested_enum(e: NestedEnum): u8 {
        match e {
            NestedEnum::VariantA => 10,
            NestedEnum::VariantB { data } => {
                if data > 100 {
                    20
                } else {
                    30
                }
            },
            NestedEnum::VariantC(inner) => match *inner {
                NestedEnum::VariantA => 40,
                NestedEnum::VariantB { data: d } => if d < 50 { 50 } else { 60 },
                _ => 70, // wildcard for other nested variants
            },
            NestedEnum::VariantD { x, y } => {
                if x == y as u8 {
                    80
                } else {
                    90
                }
            }
        }
    }

    // Function to test nested function calls and return nested result
    public fun nested_function_call(x: u8): u8 {
        // A chain of function calls to produce expected output
        helper_function1(x)
    }

    fun helper_function1(x: u8): u8 {
        if x > 50 {
            helper_function2(x - 50)
        } else {
            helper_function3(x)
        }
    }

    fun helper_function2(y: u8): u8 {
        y + 1
    }

    fun helper_function3(z: u8): u8 {
        z + 2
    }
}

//# run
script {
    // Create a list with tokens
    let list = 0xDEADBEEF::token_module::create_list_with_tokens(
        0xDEADBEEF::token_module::ListPattern::Single(42u8)
    );
    // The above should exercise list creation with tokens
}

//# run 0xDEADC0DE::token_module::match_nested_enum
script {
    // Testing pattern match on various nested enums
    let a = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantA);
    let b = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantB { data: 150 });
    let c = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantB { data: 30 });
    let d = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantC(Box::new(NestedEnum::VariantA)));
    let e = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantC(Box::new(NestedEnum::VariantB { data: 25 })));
    let f = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantD { x: 10, y: 10 });
    let g = 0xDEADC0DE::token_module::match_nested_enum(NestedEnum::VariantD { x: 10, y: 20 });

    // Values should be: 10, 20, 30, 40, 50, 80, 90 respectively
}

//# run 0xDEADC0DE::token_module::nested_function_call
script {
    let res1 = 0xDEADC0DE::token_module::nested_function_call(60);
    let res2 = 0xDEADC0DE::token_module::nested_function_call(20);
    // res1 should be 51 (since 60 > 50, calls helper_function2 with 10)
    // res2 should be 4 (since 20 <= 50, calls helper_function3 with 20)
}