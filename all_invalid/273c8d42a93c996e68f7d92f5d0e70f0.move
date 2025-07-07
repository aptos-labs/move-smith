
//# publish
module 0xCAFE::SpecBlockUseAlias {
    // Test 1: Block Expressions with nested blocks and mixed types
    public fun test_block_exprs(): u8 {
        let x = {
            let a = 1u8;
            let b = {
                let c = 2u8;
                c + 1u8
            };
            a + b // should be 4u8
        };
        x
    }

    // Use statements and aliasing
    use 0xCAFE::MyModule;
    use MyModule::E as AliasEnum;

    public fun test_use_alias(): u8 {
        let e = AliasEnum::V2(5u32, 7u32);
        let res = match (e) {
            AliasEnum::V1 => 0u8,
            AliasEnum::V2(x, y) => (x + y) as u8,
            AliasEnum::V3 { a } => if (a) {1u8} else {2u8},
        };
        res
    }

    // Spec functions with and without return types
    spec fun spec_with_return(a: u8): u8 {
        a + 10
    }

    spec fun spec_without_return(a: u8) {
        let _ = a + 20;
    }

    // Call spec functions inside a block, mixed return types
    public fun test_spec_in_block(a: u8): u8 {
        let result = {
            let x = spec_with_return(a);
            spec_without_return(x);
            x + 1u8
        };
        result
    }

    // Combined test: block expressions, use statements, spec functions all together
    public fun combined_test(a: u8): u8 {
        let res = {
            // Using alias in block
            let e = AliasEnum::V3{a: true};
            let v = match (e) {
                AliasEnum::V1 => spec_with_return(0u8),
                AliasEnum::V2(x, y) => spec_with_return((x + y) as u8),
                AliasEnum::V3 { a } => if (a) {
                    spec_with_return(a as u8)
                } else {
                    0u8
                },
            };

            // Nested block with spec call without return type
            let _ = {
                spec_without_return(v);
            };

            v
        };
        res
    }
}


//# run 0xCAFE::SpecBlockUseAlias::test_block_exprs


//# run 0xCAFE::SpecBlockUseAlias::test_use_alias


//# run 0xCAFE::SpecBlockUseAlias::test_spec_in_block --args 5u8


//# run 0xCAFE::SpecBlockUseAlias::combined_test --args 2u8


// Featurres:
// bd0d82d62d8269d2a5bd834f8a8fa85e: Group multiple expressions into a block with the `block` expression.
// 36e48cd89925e2df15f9975bdf234867: Use 'use' statements within modules without affecting implicit aliasing.
// ac5550c3dc0faea9883b6ddb91b73e4a: Specify return types for spec functions using the colon syntax, or fall back to unit return if omitted.
