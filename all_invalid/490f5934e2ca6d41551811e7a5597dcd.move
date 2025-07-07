// Test Aptos Move compiler and VM with deprecated, typed literals, and nested blocks.

//# publish
module 0xCAFE::DeprecatedMod {
    #[deprecated]
    public fun deprecated_func(): u64 {
        42u64
    }

    #[deprecated]
    public fun deprecated_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun runner(): u64 {
        // Use deprecated function inside the module to test warning issuance
        let val = deprecated_func();
        val + 1u64
    }
}
//# run 0xCAFE::DeprecatedMod::runner --signers 0xCAFE

//# publish
module 0xCAFE::TypedLiteralMod {
    public fun literal_add(): u128 {
        let a = 123u8;
        let b = 456u64;
        let c = 789u128;
        // Use just u128 addition, cast smaller types to u128
        (a as u128) + (b as u128) + c
    }

    public fun runner(): u128 {
        literal_add()
    }
}
//# run 0xCAFE::TypedLiteralMod::runner --signers 0xCAFE

//# publish
module 0xCAFE::NestedBlockMod {
    public fun nested_update(): u64 {
        let mut x = 10u64;

        // Nested blocks, assignments and references used within an expression
        let y = {
            {
                x = x + 5u64;
                &x
            }
        };

        // y is a reference to x, use * operator to dereference
        let v = *y + {
            {
                x = x * 2u64;
                x
            }
        };
        // At this point, x updated twice in nested blocks:
        // first x=15, then x=30, final v = 15 + 30 = 45
        v
    }

    public fun runner(): u64 {
        nested_update()
    }
}
//# run 0xCAFE::NestedBlockMod::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::DeprecatedMod;
    use 0xCAFE::TypedLiteralMod;
    use 0xCAFE::NestedBlockMod;

    fun main(_signer: signer) {
        // Call deprecated functions to test warnings on usage
        let dep_val = DeprecatedMod::deprecated_func();
        let sum = DeprecatedMod::deprecated_add(1u64, 2u64);

        // Run module runners to test their internal usage as well
        let runner1 = DeprecatedMod::runner();
        let runner2 = TypedLiteralMod::runner();
        let runner3 = NestedBlockMod::runner();

        // Use all values to avoid unused warnings
        let _ = dep_val + sum + runner1 + (runner2 as u64) + runner3;
    }
}

// Featurres:
// 4a690b89f56f1d2ec0a295d2eb1077ce: Recognize deprecated modules and issue warnings when their members are used.
// bf9d6723bbe3a98f8af6efcf0b0e836f: Write typed numeric literals directly as values, such as with a specific suffix.
// f5965d3be3245ba5e43ade508a6260c4: Test that nested `{}` blocks with assignments and references correctly update and use local variables within an expression.
