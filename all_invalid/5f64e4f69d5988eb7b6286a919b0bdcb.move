//# publish
module 0x1::DuplicateFieldsTest {
    struct S has copy, drop, store {
        a: u64,
        // The duplicate field "a" should cause a diagnostic error in compilation
        a: u64,
        b: u64,
    }
}

//# publish
module 0x1::ModuleAliases {
    // Validate member alias names
    // For demonstration, this will try to define and use aliases and enforce naming rules (must start with uppercase)
    alias MyAlias = u64;
    // invalid alias name (lowercase) should cause diagnostic error if compiler validated properly
    alias invalid_alias = u8;

    public fun runner(): u64 {
        let x: MyAlias = 10;
        x
    }
}

//# run 0x1::ModuleAliases::runner

//# publish
module 0x1::NestedBindings {
    public fun runner(): u64 {
        let mut x = 1;
        let mut y = 2;

        {
            // inner block 1
            let tmp = x;
            x = y;
            y = tmp + 10; // modifies y
        }

        {
            // inner block 2
            let tmp = x;
            x = y * 2;
            y = tmp - 1;
        }

        // compute total sum of x + y
        x + y
    }
}

//# run 0x1::NestedBindings::runner