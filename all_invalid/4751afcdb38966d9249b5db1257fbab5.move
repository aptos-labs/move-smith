
//# publish
module 0xCAFE::TestFeatures {

    use std::vector;
    use std::signer;
    use 0xCAFE::MyModule;

    // Native function with multiple parameters and return types
    native fun native_multi_params_and_return(
        param1: u8,
        param2: u16,
        param3: bool,
        out1: &mut u8,
        out2: &mut u16,
    );

    // Function to test elided fields with '..' syntax
    public fun test_struct_unpack(x: 0xCAFE::MyModule::S, y: 0xCAFE::MyModule::S): bool {
        let S {x: a, y: b} = x; // full destructure
        let S {..} = y; // elided destructure
        // For the test, check if x.x == y.x to confirm partial unpacking
        a == b
    }

    // Function to construct pack value with module access, type args, and fields
    public fun construct_pack_value(signer: &signer.Signer): vector<u8> {
        // invoke native with multiple fields
        let out1: u8 = 0;
        let out2: u16 = 0;
        native_multi_params_and_return(10, 20, true, &mut out1, &mut out2);

        // Construct a struct with elided fields -->
        let s = 0xCAFE::MyModule::S {x: 42, y: 84};

        // Construct value: pack with module access, type args, fields
        let type_args = vector::empty::<u8>();
        let packed_value = bcs::to_bytes(&s);
        packed_value
    }

    // Function to perform the test
    public fun run_tests(signer: &signer.Signer) {
        // Call native with multiple params and get outputs
        let out1: u8 = 0;
        let out2: u16 = 0;
        native_multi_params_and_return(5, 15, false, &mut out1, &mut out2);
        // Construct struct with elided unpacking
        let s1 = 0xCAFE::MyModule::S {x: 1, y: 2};
        let s2 = 0xCAFE::MyModule::S {x: 3, y: 4};
        let _ = test_struct_unpack(s1, s2);
        // Construct pack value
        let _packed_value = construct_pack_value(signer);
        // Additional test: use `..` syntax in destructure and check values indirectly
        let S {x: x_value, ..} = s1;
        assert!(x_value == 1, 999);
    }
}


//# run 0xCAFE::TestFeatures::run_tests --signers 0xBADD

// Featurres:
// 656cc215cd36479a92d928dbf07cf0cf: Use the '..' (dot-dot) syntax to indicate elided fields in positional struct unpacking.
// 04713cafdd3f020f94c6eb5ebe4ceade: Declare multiple parameters and return types for a native function.
// cfc2fdac37678eab319a0d31c41e206f: Construct pack values with module access, type arguments, and fields.
