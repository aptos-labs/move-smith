//# publish
module 0xCAFE::LintSkipExample {
    #[skip(uppercase_constants, unused_imports, non_camel_case_types)]
    use std::signer;

    #[skip(uppercase_constants)]
    const some_constant: u64 = 123;

    #[skip(non_camel_case_types)]
    struct some_struct has copy, drop, store {
        a_field: u8,
    }

    #[skip(uppercase_constants, unused_imports)]
    public fun runner() {
        let x = some_constant;
        let s = some_struct { a_field: 7 };
        let _ = x + s.a_field;
    }
}

//# run 0xCAFE::LintSkipExample::runner


//# publish
module 0xCAFE::LintCheckEnforcer {
    use std::signer;

    const CONST_VAL: u8 = 42;

    struct ValidStruct has copy, drop, store {
        field1: u64,
        field2: bool,
    }

    public fun new_struct(field1: u64, field2: bool): ValidStruct {
        ValidStruct { field1, field2 }
    }

    public fun use_struct(s: &ValidStruct): u64 {
        if (s.field2) {
            s.field1 + 1
        } else {
            s.field1
        };
        s.field1
    }

    public fun runner() {
        let s = new_struct(100, true);
        let _ = use_struct(&s);
    }
}

//# run 0xCAFE::LintCheckEnforcer::runner


//# run
script {
    use 0xCAFE::LintSkipExample;
    use 0xCAFE::LintCheckEnforcer;

    fun main() {
        LintSkipExample::runner();
        LintCheckEnforcer::runner();
    }
}

// Featurres:
// 934f25f8d7e4c1f5e940ba86173abd13: Use the `#[skip(...)]` attribute with a list of lint check names to skip certain lint checks.
// 087171980c5f3b251bbacc114de2fd23: Write Move modules and scripts that will be run through the Move compiler.
// 649533cb9c7559bb985c95ba8ec28fa9: Apply model AST lint checks for conformance to best practices
