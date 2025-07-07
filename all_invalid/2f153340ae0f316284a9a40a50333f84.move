
//# publish
module 0xCAFE::SchemaModule {
    use std::vector;

    // Define a schema for a specification with type parameters
    spec schema TestSchema<T> {
        // simple fields
        field1: u8;
        field2: T;
        // nested schema inside
        nested_schema: NestedSchema<T>;
    }

    // Define a nested schema
    spec schema NestedSchema<U> {
        value: U;
        flag: bool;
    }

    // Define an enum with multiple named variants, each with their own fields
    enum MultiVariations {
        VariantA { a: u8, b: u16 },        // Variant with named fields
        VariantB(u8, u16),                 // Tuple variant
        VariantC { c: bool }               // Variant with a single field
    }

    // Struct that is an enum with variants
    struct VariantStruct has copy, drop, store {
        variant: MultiVariations;
    }

    // Inline function to demonstrate multiple mutable references and updates
    public fun inline_func(x: &mut u64, y: &mut u64) {
        *x = *x + 1;
        *y = *y + 2;
        // mutate both refs
    }

    // Function that creates and updates multiple local vars with inline functions
    public fun test_inline_update() {
        let a = 5u64;
        let b = 10u64;
        inline_func(&mut a, &mut b);
        // Update again with the same refs
        inline_func(&mut a, &mut b);
        // Last expression is the sum of updated values
        a + b
    }

    // Function to test multiple inline mutations with repeated references
    public fun test_repeated_inline_refs() {
        let val1 = 20u64;
        let val2 = 30u64;
        // Call inline_func multiple times with the same mutable references
        inline_func(&mut val1, &mut val2);
        inline_func(&mut val1, &mut val2);
        // Return sum
        val1 + val2
    }
}


//# run 0xCAFE::SchemaModule::test_inline_update


//# run 0xCAFE::SchemaModule::test_repeated_inline_refs

// Features:
// d213f1ef7712e285fb393c4b126746c6: Define specification schemas using 'spec schema <Name>[<TypeParameters>] { ... }'.
// 8248d516eaee8c132040c2cb556f60a2: Define structs as enums with multiple named variants, each with their own fields and position style.
// 37a1bfd1a456704dfea42fde00aaefbd: Test that inline functions correctly update and use mutable references when the same variable is passed multiple times within a single expression.