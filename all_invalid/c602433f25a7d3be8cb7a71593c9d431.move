//# publish
module 0xCAFE::MacroAndAttributeTest {
    use std::signer;

    // Attribute testing:
    // Define functions with nested and non-nested attributes, enforcing attribute usage rules.
    #[test] // Non-nested attribute example
    public fun non_nested_attr() {
        // Unit type value usage: return unit type explicitly
        ()
    }

    #[path = "some/path"] // Attribute that would normally be non-nested; we pretend it's non-nested here.

    public fun nested_attr() {
        // Parentheses for unit value
        let u: () = ();
        let _ = u;
    }

    // Macro/syntactic sugar expansion examples:

    // Expand for loop syntactic sugar manually to a while loop
    public fun expanded_for_loop(): u64 {
        let mut sum = 0u64;
        let mut i = 0u64;
        while (i < 3) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    // Expand range operator manually into a loop with breaks
    public fun expanded_range_loop(): u8 {
        let mut acc = 0u8;
        let mut i = 1u8;
        loop {
            if (i >= 5) {
                break;
            };
            acc = acc + i;
            i = i + 1;
        };
        acc
    }

    // Use unit type as a field in a struct
    struct UnitStruct has copy, drop, store {
        field: ()
    }

    public fun unit_struct_func(): UnitStruct {
        UnitStruct { field: () }
    }

    // Use unit type as a field in a resource
    struct UnitResource has key {
        field: ()
    }

    public fun create_unit_resource(s: signer) {
        let r = UnitResource { field: () };
        move_to<UnitResource>(&s, r);
    }

    public fun destroy_unit_resource(s: signer) {
        let r = move_from<UnitResource>(signer::address_of(&s));
        let UnitResource { field: () } = r;
    }
}

//# run 0xCAFE::MacroAndAttributeTest::non_nested_attr

//# run 0xCAFE::MacroAndAttributeTest::nested_attr

//# run 0xCAFE::MacroAndAttributeTest::expanded_for_loop

//# run 0xCAFE::MacroAndAttributeTest::expanded_range_loop

//# run 0xCAFE::MacroAndAttributeTest::unit_struct_func

//# run 0xCAFE::MacroAndAttributeTest::create_unit_resource --signers 0xBABE

//# run 0xCAFE::MacroAndAttributeTest::destroy_unit_resource --signers 0xBABE

// Featurres:
// 2dd7578d325883fa41ddc631335c1f43: Expand macro or syntactic sugar constructs during compilation.
// e743770752c5b668ad11d9541647e0f6: Specify whether attributes are nested or non-nested to enforce attribute usage rules.
// 59d0366e034fa8533bb30a594ea89ad2: Use unit type as a value.
