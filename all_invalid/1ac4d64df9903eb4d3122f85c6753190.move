// Module and test file: struct_destruct_deprecated.move

// ------------------------------------
//# publish
module 0xCAFE::StructDestructuring {
    // A struct with three fields, one has copy, one not.
    struct Info has copy, drop {
        a: u8,
        b: u64,
        c: bool,
    }

    // Runner function to test destructuring without rename.
    public fun destructure_no_rename() {
        let info = Info { a: 7, b: 100, c: true };
        // Destructure into variables of same name
        let Info { a, b, c } = info;
        // Use the variables to exercise the code path
        let sum = (a as u64) + b + (if c { 1 } else { 0 });
        sum;
    }

    // Runner function to test destructuring with renaming variables
    public fun destructure_with_rename() {
        let info2 = Info { a: 123, b: 456, c: false };
        // Destructure and assign to new variable names
        let Info { a: x, b: y, c: z } = info2;
        // Use new names in an expression
        let result = ((x as u64) * y) + (if z { 1 } else { 0 });
        result;
    }

    // function with return value
    public fun sum_fields(info: Info): u64 {
        let Info { a, b, c } = info;
        (a as u64) + b + (if c { 1 } else { 0 })
    }

    // Runner function that calls sum_fields
    public fun run_sum_fields(): u64 {
        let i = Info { a: 2, b: 40, c: true };
        sum_fields(i)
    }
}
//# run 0xCAFE::StructDestructuring::destructure_no_rename
//# run 0xCAFE::StructDestructuring::destructure_with_rename
//# run 0xCAFE::StructDestructuring::run_sum_fields

// ------------------------------------
//# publish
// 'spec' syntax is legal for modules (though deprecated)
spec module 0xCAFE::WithSpecSyntax {
    // Simple constant for visibility
    const N: u8 = 4;

    // Runner
    public fun call_n(): u8 { N }
}
//# run 0xCAFE::WithSpecSyntax::call_n

// ------------------------------------
// Deprecation attribute
//# publish
#[deprecated(since = "1.0.0", note = "This module is deprecated!")]
module 0xCAFE::DeprecatedModule {
    struct Old has copy, drop {
        x: u64,
    }

    public fun old() {
        let _o = Old { x: 8 };
    }
}
//# run 0xCAFE::DeprecatedModule::old

// ------------------------------------
//# publish
// Attempt to define a module with the same name and address as a previous one
module 0xCAFE::DeprecatedModule {
    struct New has copy, drop {
        y: bool,
    }

    // This function should not be run and should not compile if previous is enforced.
    public fun new() {
        let _n = New { y: false };
    }
}

// Attempt duplicate module -- compiler must handle this gracefully (only one module actually applied)

// Featurres:
// 2a80c96bc8d5e92bd4bf6f5538acc384: Destructure structs and assign field values directly to variables with or without renaming.
// 693339c86332286bc3cd59d9497108c9: Declare a module using 'module' or 'spec' syntax.
// a0209d0d2cfe59088a84a326a63ded2b: Support module deprecation attributes and handle duplicated modules appropriately.
