module 0x1::TestTransactionalFeatures {
    use std::debug;
    use std::signer;

    /// 1. Test logical negation with the '!' operator.
    /// This function returns `true` if the negation of `input` is true.
    public fun test_logical_negation(input: bool): bool {
        // Should return !input
        let negated = !input;
        negated
    }

    /////////////////////////////////////////////
    /// 2. Compiler errors on duplicate field names.
    ///
    /// The following struct definitions are commented out because
    /// they produce compiler errors due to duplicate fields.
    /// Uncommenting them should fail compilation with errors similar to:
    /// "Duplicate struct field: `field`".
    /////////////////////////////////////////////

    /*
    // Duplicate field 'foo' in struct
    struct DuplicateFieldStruct has copy, drop {
        foo: u64,
        foo: u64,
    }

    // Duplicate field 'bar' in resource
    resource struct DuplicateFieldResource {
        bar: bool,
        bar: bool,
    }
    */

    /////////////////////////////////////////////
    /// 3. Unpacking structs only within defining module.
    ///
    /// We define a struct and expose a function to return it.
    /// We do NOT expose the struct to other modules.
    /// Then, we attempt to unpack it in this module (allowed),
    /// but unpacking outside this module should cause compiler error.
    /////////////////////////////////////////////

    struct InternalStruct has copy, drop {
        value: u64,
        flag: bool,
    }

    /// Create a new InternalStruct instance
    public fun new_internal_struct(): InternalStruct {
        InternalStruct { value: 42, flag: true }
    }

    /// Unpack the InternalStruct within this module: allowed.
    public fun unpack_internal_struct(s: InternalStruct): (u64, bool) {
        let InternalStruct { value, flag } = s;
        (value, flag)
    }
}

// Featurres:
// aebf58ec057a3449ce7b6e56d8b9b22d: Use the '!' operator to perform logical negation in expressions.
// b0dd8d21d612fb9287d60cc5e8081c3a: Receive compiler errors when duplicate field names are given in a struct or resource definition.
// 778766bd9007fc34ed8890a022ea7149: Unpack structs only within the module that defines the struct.
