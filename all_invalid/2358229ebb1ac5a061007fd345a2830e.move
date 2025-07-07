//# publish
module 0xCAFE::Nested {
    public fun get_u8(): u8 {
        42u8
    }

    public fun get_u16(): u16 {
        1000u16
    }

    public fun get_u32(): u32 {
        50000u32
    }

    public fun get_u64(): u64 {
        1_000_000u64
    }

    public fun get_u128(): u128 {
        12345678901234567890u128
    }

    public fun get_u256(): u256 {
        340282366920938463463374607431768211455u256
    }
}

//# publish
module 0xCAFE::Nested::NestedInner {
    public fun combine_values(): u64 {
        // combining values from parent module
        let a = 0xCAFE::Nested::get_u64();
        let b: u64 = 123456u64;
        a + b
    }
}

//# run 0xCAFE::Nested::NestedInner::combine_values

//# run 0xCAFE::Nested::get_u8
//# run 0xCAFE::Nested::get_u16
//# run 0xCAFE::Nested::get_u32
//# run 0xCAFE::Nested::get_u64
//# run 0xCAFE::Nested::get_u128
//# run 0xCAFE::Nested::get_u256


//# run 0xCAFE::Nested::non_existing_function

//# run 0xBABE::MissingModule::foo

// Featurres:
// 221307cdfdf0015dc7caaf85add65ff1: Write integer literals with explicit type suffixes u8, u16, u32, u64, u128, or u256 to specify their type in Move code.
// 531270db1412b409e3b2e734b6fa50cf: Reference modules via module access chains, allowing composition of nested module paths.
// 14ce65feff3d2cda05a0a6e99eaf109f: Receive diagnostics if referring to modules that have not been defined or imported in your current context
