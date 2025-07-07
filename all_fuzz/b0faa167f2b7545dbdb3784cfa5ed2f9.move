
//# publish
module 0xCAFE::UnitAndStructs {
    use std::signer;

    struct EmptyStruct has store, drop {}

    // [test_only]
    public fun function_with_custom_attribute() {
        // This function is annotated with a custom attribute `test_only`

        // Assign unit type () to unit variable and nested unit pattern
        let (): () = ();
        let (_unit1, _unit2, ()) = ((), (), ());
    }

    public fun create_empty_struct(): EmptyStruct {
        EmptyStruct {}
    }

    public fun accept_empty_struct(es: EmptyStruct): bool {
        // Just accept the struct and return true
        true
    }
}



//# run 0xCAFE::UnitAndStructs::function_with_custom_attribute



//# run 0xCAFE::UnitAndStructs::create_empty_struct



//# run 0xCAFE::UnitAndStructs::accept_empty_struct --args 0xCAFE::UnitAndStructs::EmptyStruct{}


// Featurres:
// 7786fd569d57ae98a513426be143e150: Assign values to unit type (empty tuples) as valid assignment targets
// 3ead418b1ce59f603f43e76987f39c53: Declare structs within modules.
// 7f74eaf7a019ed1b7ea639c9aee6ead9: Annotate functions with custom attributes for use by the compiler or external tooling.
