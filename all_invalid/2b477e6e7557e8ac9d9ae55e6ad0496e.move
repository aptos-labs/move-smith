//# publish
module 0xCAFE::DeprecationTest {
    use std::signer;

    /// Deprecated constant with diagnostic code 1001
    #[deprecated(code = 1001)]
    const OLD_CONST: u64 = 42;

    /// Deprecated function with diagnostic code 1002
    #[deprecated(code = 1002)]
    public fun old_fun(): u64 {
        OLD_CONST
    }

    /// Struct with multiple abilities specified by colon and plus-separated list
    struct MultiAbilityStruct has key: copy + drop + store {
        id: u64,
        enabled: bool,
    }

    /// Create an instance and write/store to address of signer
    public fun create_and_store(s: signer, id: u64) {
        let mas = MultiAbilityStruct {id, enabled: true};
        move_to<MultiAbilityStruct>(&s, mas);
    }

    /// Read stored struct from signer's address
    public fun read_struct(s: signer): (u64, bool) {
        let ref_str: &MultiAbilityStruct = borrow_global<MultiAbilityStruct>(signer::address_of(&s));
        (ref_str.id, ref_str.enabled)
    }

    /// Explicit dependency declaration on MyModule with alias MyMod
    #[dependency(address = 0xCAFE, module = "MyModule", alias = "MyMod")]
    public fun use_dependency_alias(x: u8, y: bool): u8 {
        MyMod::f1(x, y)
    }

    /// Runner function to invoke deprecated constant and function to test deprecation diagnostics
    public fun runner_deprecated() {
        let _v = OLD_CONST;
        let _w = old_fun();
    }
}

//# run 0xCAFE::DeprecationTest::runner_deprecated

//# run 0xCAFE::DeprecationTest::create_and_store --signers 0xBEEF --args 123u64

//# run 0xCAFE::DeprecationTest::read_struct --signers 0xBEEF

//# run 0xCAFE::DeprecationTest::use_dependency_alias --args 7u8 true

// Featurres:
// b2081e928f636305e3be6e682bcc0741: Get notifications about the use of deprecated items with specific diagnostic codes.
// d72e80a8027df807adc8d20303e0a24f: Specify multiple abilities with a colon and plus-separated list.
// 3558c32ed7144b2a1afeccb05dae6dfb: Create modules with explicit dependency declarations to enable dependency analysis.
