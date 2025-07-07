//# publish
module 0x1::DepMod {
    use std::signer;

    // Dummy function to be used as dependency
    public fun dep_fun(_addr: address): u64 {
        42
    }
}

//# publish
module 0x1::ResourceMod {
    use std::signer;

    #[skip(lint_incomplete_abilities, lint_unused_var)]
    struct R has key {
        val: u64,
    }

    public fun new_r(val: u64): R {
        R { val }
    }

    public fun get_val(r: &R): u64 {
        r.val
    }

    // do modifies R based on value of v:
    // if v > 10 add 1 to val,
    // if v == 10 multiply val by 2,
    // else subtract 1
    public fun do(r: &mut R, v: u64) {
        if (v > 10) {
            r.val = r.val + 1;
        } else if (v == 10) {
            r.val = r.val * 2;
        } else {
            r.val = r.val - 1;
        }
    }

    // runner: creates a resource, runs do with different values, no args needed
    public fun run_do() {
        let mut r = new_r(10);
        do(&mut r, 5);   // expect val=9 (10-1)
        do(&mut r, 10);  // expect val=18 (9*2)
        do(&mut r, 11);  // expect val=19 (18+1)
    }
}

//# run 0x1::ResourceMod::run_do

//# publish
module 0x1::SettingsCheck {
    use std::signer;

    /// This dummy function just illustrates Checker config in 'Specification' mode by signature / comment
    /// (can't directly configure checker from Move source but for test imply config used)
    /// We simulate checking ability duplicates via deliberately redeclaring or commenting intention
    ///
    /// Example abilities sets with a duplicate:
    #[skip(lint_duplicate_abilities)]
    struct S has copy, drop, store, drop {}

    // We simulate duplicate detection by violating the abilities attribute syntax,
    // Move compiler will emit error normally. The skip attribute suppresses the lint error.

    /// Dummy runner function to simulate checker and reporting in Specification mode
    public fun spec_mode_check() {
        // no-op
    }
}

//# run 0x1::SettingsCheck::spec_mode_check

//# publish
module 0x1::LiteralTest {
    use std::signer;

    #[skip(lint_unused_var)]
    public fun test_hex_literals() {
        let a0: u8 = 0x00u8;
        let a1: u8 = 0x0Au8;
        let a2: u8 = 0x0fu8;
        let a3: u8 = 0xFFu8;
        let a4: u16 = 0x000Au16;
        let a5: u16 = 0x00FFu16;
        let a6: u32 = 0x0000AA32u32;
        let a7: u64 = 0x0000000AA32u64;
        let a8: u128 = 0x00000000000AA321u128;

        // use them to avoid warnings
        let _sum_u8 = a0 + a1 + a2 + a3;
        let _sum_u16 = a4 + a5;
        let _sum_u32 = a6;
        let _sum_u64 = a7;
        let _sum_u128 = a8;
    }

    public fun run_all() {
        test_hex_literals();
    }
}

//# run 0x1::LiteralTest::run_all

//# run
script {
    use 0x1::ResourceMod;
    use 0x1::DepMod;

    fun main(account: signer) {
        // Instantiate resource
        let mut r = ResourceMod::new_r(15);

        // Call do with various values
        ResourceMod::do(&mut r, 9);
        ResourceMod::do(&mut r, 10);
        ResourceMod::do(&mut r, 20);

        // Call dependency function to test dependency parsing
        let _dep_val = DepMod::dep_fun(signer::address_of(&account));
    }
}