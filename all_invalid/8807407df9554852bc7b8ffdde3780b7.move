
//# publish
module 0xFEED::TestModule {
    // This module tests inline functions, enum variants, and condition clauses in specs

    use std::vector;

    struct Pair has copy, store {
        a: u8,
        b: u8,
    }

    enum MyEnum has copy, drop {
        VariantOne,
        VariantTwo(u32, u32),
        VariantThree {
            flag: bool
        },
    }

    // Inline function calling a function pointer and returning sum
    public inline fun foo(f: |u8, u8| u8, arg1: u8, arg2: u8): u8 {
        f(arg1, arg2) + arg1 + arg2
    }

    // Runner function to test inline 'foo'
    public fun run_foo_test() {
        let adder: |u8, u8| u8 = |x: u8, y: u8| {
            x + y
        };
        let result = foo(&adder, 2u8, 3u8);
        assert!(result == 2u8 + 3u8 + 2u8 + 3u8, 999);
    }

    // Function to create enum variants with varying structures
    public fun create_enum_variants(): MyEnum {
        let variant1 = MyEnum::VariantOne;
        let variant2 = MyEnum::VariantTwo(10, 20);
        let variant3 = MyEnum::VariantThree { flag: true };
        // return one of variants for testing
        variant3
    }

    // Function with spec conditions to test condition clauses
    public fun check_enum_conditions(e: MyEnum): bool {
        spec {
            // Condition: if variant1
            if (e == MyEnum::VariantOne) {
                // Additional condition
                true
            } else if (e == MyEnum::VariantTwo(10, 20)) {
                // Additional condition with pattern matching
                true
            } else {
                // fallback
                false
            }
        };
        // Return true if the enum matches some variants
        match (e) {
            MyEnum::VariantOne => true,
            MyEnum::VariantTwo(x, y) if (x == 10 && y == 20) => true,
            _ => false,
        }
    }
}


//# run 0xFEED::TestModule::run_foo_test


//# run 0xFEED::TestModule::create_enum_variants


//# run 0xFEED::TestModule::check_enum_conditions --args 0xFEED::MyEnum::VariantOne


// Featurres:
// f64ae958d4521612c97023ab5d1e3ae8: Test that the inline function 'foo' correctly calls the provided function pointer and returns the sum of specific arguments as expected.
// f25d1f528a8707df554044d60496d074: Use the syntax for enumerations with variants, optionally including block-structured variants and allowing optional commas between variants, enclosed within braces.
// 2170cd1c754087ec4348b4b393f60d8e: Use condition clauses in spec blocks to specify conditions with primary and additional expressions
