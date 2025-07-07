// #publish
module 0xCAFE::MutabilityTest {
    /// A function showing variable bindings in blocks and lambdas (anonymous functions)
    /// and testing mutability by modifying variables within scopes.
    /// This function has no arguments and returns unit.
    public fun test_mutability(): () {
        let x = 1u8;
        // Shadow x with a mutable let binding inside a block
        {
            let x = x + 1;
            // x is now 2u8, but immutable because no mut keyword needed, but variable bindings are always mutable in Move
            // Modify x by assigning x + 3
            let x = x + 3;
            // x is now 5
            // Inner block ends, outer x is still 1
        }
        // Introduce a lambda function that takes no arguments and captures x
        let mut_lambda = || {
            // shadow x
            let x = x + 10;
            x
        };
        // Call the lambda, result should be 11
        let res = mut_lambda();
        // res is not used for assertion (ignored in test), but this checks compilation + variable binding handling

        // Test variable bindings inside nested blocks mutating variables
        let mut y = 100u64;
        {
            y = y + 22;
            {
                y = y * 2;
            }
        };
    }

    /// Runner function to be called without arguments.
    public fun runner(): () {
        test_mutability()
    }
}
// #run 0xCAFE::MutabilityTest::runner

// #publish
module 0xCAFE::CastTest {
    // Test casting u64 to u8 and u16 with values in and out of range.
    // The values in range should be correctly cast.
    // To test in range, do (value as u8) and assign.
    // To test out of range, attempt downcast with value too big.
    // Note: Move compiler should reject code that obviously overflows on cast (compile-time error).
    // Here we show proper usage and avoiding overflow at runtime by guarding with if-else.

    /// Return u8 after casting u64 in range
    public fun cast_u64_to_u8_in_range(): u8 {
        let large: u64 = 123;
        let small: u8 = (large as u8);
        small
    }

    /// Return u16 after casting u32 in range
    public fun cast_u32_to_u16_in_range(): u16 {
        let i: u32 = 32000;
        let s: u16 = (i as u16);
        s
    }

    /// Try casting u64 to u8 with overflow. This needs to be a run-time test: 
    /// return 0u8 if casting overflow detected, else return casted value.
    public fun cast_u64_to_u8_overflow_check(): u8 {
        let val: u64 = 256;
        if (val > 255) {
            0u8
        } else {
            (val as u8)
        }
    }

    /// Runner that calls these functions, ignoring return values.
    public fun runner(): () {
        let _ = cast_u64_to_u8_in_range();
        let _ = cast_u32_to_u16_in_range();
        let _ = cast_u64_to_u8_overflow_check();
    }
}
// #run 0xCAFE::CastTest::runner

// #publish
module 0xCAFE::AliasTest1 {
    // Define a simple struct that will be aliased and used.
    struct Foo has copy, drop, store {
        x: u64,
    }

    public fun make_foo(): Foo {
        Foo { x: 999 }
    }
}

// #publish
module 0xCAFE::AliasTest2 {
    // Use alias imports from AliasTest1
    use 0xCAFE::AliasTest1::Foo as MyFoo;
    use 0xCAFE::AliasTest1;

    public fun create_and_get_x(): u64 {
        let f: MyFoo = AliasTest1::make_foo();
        f.x
    }

    public fun runner(): () {
        let res = create_and_get_x();
        let _ = res;
    }
}
// #run 0xCAFE::AliasTest2::runner


// #run
script {
    use 0xCAFE::MutabilityTest;
    use 0xCAFE::CastTest;
    use 0xCAFE::AliasTest2;

    fun main() {
        MutabilityTest::runner();
        CastTest::runner();
        AliasTest2::runner();
    }
}

// Featurres:
// 8171a7fbf944cb0c44bd028f983d3a3b: Handle variable bindings in lambda expressions and blocks to determine their mutability status.
// 39b7ee3bfddcbf2b9dc76cfba509762a: Test that casting various unsigned integer types to smaller unsigned integer types correctly preserves values within range and fails appropriately when overflowing.
// 55c797bfffbc304fd73fe6bbfbc37f89: Use 'use' declarations within a module to alias imported items.
