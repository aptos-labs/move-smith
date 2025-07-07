// Attempt to publish a module with invalid attribute name to trigger compiler error for incorrect module identifier format
// This intentionally uses an invalid attribute to test compiler error reporting
// invalid-attr]

//# publish
module 0xCAFE::InvalidAttrModule {
    public fun dummy() {
    }
}


//# publish
module 0xCAFE::LocalInitCheck {
    // Test that local variables are properly initialized before use in complex branchings

    public fun test_local_init(x: bool): u8 {
        let a: u8;
        if (x) {
            a = 10u8;
        } else {
            a = 20u8;
        };
        // a must be initialized regardless of the branch taken
        a
    }

    public fun test_local_init_with_loop(cond: bool): u8 {
        let initialized_value = 0u8;
        let i = 0u8;
        while (i < 3u8) {
            if (cond) {
                initialized_value = initialized_value + 1;
            };
            i = i + 1;
        };
        initialized_value
    }
}


//# run 0xCAFE::LocalInitCheck::test_local_init --args true


//# run 0xCAFE::LocalInitCheck::test_local_init --args false


//# run 0xCAFE::LocalInitCheck::test_local_init_with_loop --args true


//# run 0xCAFE::LocalInitCheck::test_local_init_with_loop --args false


//# publish
module 0xCAFE::MultiTypeMatch {
    enum MultiTypeEnum has copy, drop {
        U8Val(u8),
        BoolVal(bool),
        AddrVal(address)
    }

    public fun match_u8(v: u8): u8 {
        let e = MultiTypeEnum::U8Val(v);
        match (e) {
            MultiTypeEnum::U8Val(val) => val,
            MultiTypeEnum::BoolVal(_) => 0u8,
            MultiTypeEnum::AddrVal(_) => 0u8,
        }
    }

    public fun match_bool(v: bool): u8 {
        let e = MultiTypeEnum::BoolVal(v);
        match (e) {
            MultiTypeEnum::U8Val(_) => 0u8,
            MultiTypeEnum::BoolVal(true) => 1u8,
            MultiTypeEnum::BoolVal(false) => 2u8,
            MultiTypeEnum::AddrVal(_) => 0u8,
        }
    }

    public fun match_address(v: address): u8 {
        let e = MultiTypeEnum::AddrVal(v);
        match (e) {
            MultiTypeEnum::U8Val(_) => 0u8,
            MultiTypeEnum::BoolVal(_) => 0u8,
            MultiTypeEnum::AddrVal(x) => {
                if (x == @0xCAFE) { 1u8 } else { 2u8 }
            }
        }
    }

    public fun runner() {
        let _ = Self::match_u8(42u8);
        let _ = Self::match_bool(true);
        let _ = Self::match_bool(false);
        let _ = Self::match_address(@0xCAFE);
        let _ = Self::match_address(@0xBEEF);
    }
}


//# run 0xCAFE::MultiTypeMatch::runner


// Featurres:
// aa21c1a85619b03f65dd0721c186fa37: Trigger an error when an attribute value does not conform to expected module identifier formats, aiding in debugging and correctness verification.
// 46ce62a5fd4d623bd77f014b67bcfbfe: Help in verifying that local variables are properly initialized before use to ensure safety in Move code.
// 9a66068c5a8239c2aac418d8c0664f80: Test expressions against multiple types (likely for pattern matching).
