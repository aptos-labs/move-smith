
//# publish
module 0xCAFE TestDereferenceAndExpressions {
    struct Dummy { value: u64 }

    public fun create_dummy(): Dummy {
        Dummy { value: 42 }
    }
}


//# publish
module 0xCAFE TestReferences {
    // This module will help test dereferencing with * operator
    public fun get_value_reference(dummy_ref: &Dummy): &u64 {
        &dummy_ref.value
    }
}


//# publish
module 0xCAFE TestExpressions {
    // Test expressions list and decimal number usage
    public fun compute(): u64 {
        let a = 10;
        let b = 20;
        let c = 30;
        // List multiple expressions in a single expression list
        // using addition of multiple values
        (a + b + c + 100 + 200)
    }
}


//# run 0xCAFE::TestDereferenceAndExpressions::create_dummy


//# run 0xCAFE::TestReferences::get_value_reference --signers 0xCAFE --args 0xCAFE::TestDereferenceAndExpressions::create_dummy


//# run 0xCAFE::TestExpressions::compute

// Featurres:
// 18cf1f39dcb041faa40e91477f2e04da: Dereference references using the * operator.
// 2235658ff2cf510854ab0cd8af9f181c: List multiple expressions in a single expression list context.
// ae556999094ab5cc4bb99d642a8bcf5b: Write decimal numbers directly without a prefix.
