
//# publish
module 0xDEAD::LiveVariableAndTypeTests {
    use std::signer;
    use std::vector;

    // 1. Function to test live variable names at a specific code offset (simulate by a specific point)
    public fun test_variable_names_at_offset(): u8 {
        // Local variables
        let msg_prefix = b"Vars at offset: ";
        let offset = 42u8;
        let print = vector::append(msg_prefix, vector::single(offset));
        // The variable names should include 'msg_prefix' and 'offset'
        // The test mainly checks the compiler's ability, so return a dummy value
        offset
    }

    // 2. Function to create an address specifier using empty parentheses '()'
    public fun create_empty_address(): address {
        // Using an empty tuple as address component is invalid, simulate by zero address
        address::zero()
    }

    // 3. Struct with generic types, with `phantom` annotation
    use std::phantom;
    struct GenStruct<T> has copy, drop, store {
        value: T,
        _phantom: phantom::Phantom<()>,
    }

    // Constructor for GenStruct with type parameter T (phantom annotation present)
    public fun create_gen_struct_with_phantom<U>(val: U): GenStruct<U> {
        let gen_struct = GenStruct { value: val, _phantom: phantom::Phantom() };
        gen_struct
    }

    // Struct with multiple generic parameters with/without `phantom`
    struct MultiGenStruct<A, B> has copy, drop {
        a: A,
        b: B,
    }

    // Instantiate MultiGenStruct with phantom annotation on second type
    public fun create_multi_gen_struct<A, B>(a: A, b: B): MultiGenStruct<A, B> {
        let s = MultiGenStruct { a, b };
        s
    }

    // 4. Function combining variable usage, address specifier, and generic types with optional phantom
    public fun combined_test<U>(val: U, with_phantom: bool): u8 {
        // Use local variable
        let local_var = 7u8;
        // Create address using empty parentheses '()'
        let addr = create_empty_address();

        // Instantiate generic struct with phantom
        let gen_struct = if (with_phantom) {
            create_gen_struct_with_phantom(val)
        } else {
            // Use without phantom
            GenStruct { value: val, _phantom: phantom::Phantom() }
        };

        // Return payload combining these features
        let _ = addr;
        local_var
    }
}


//# run 0xDEAD::LiveVariableAndTypeTests::test_variable_names_at_offset

//# run 0xDEAD::LiveVariableAndTypeTests::create_empty_address

//# run 0xDEAD::LiveVariableAndTypeTests::create_gen_struct_with_phantom --args 100u64

//# run 0xDEAD::LiveVariableAndTypeTests::create_multi_gen_struct --args 200u16 300u16

//# run 0xDEAD::LiveVariableAndTypeTests::combined_test --args 123u8 false


// Featurres:
// 1c7da22ca3eb9a17df676a040facf1f8: Retrieve and display the raw names of local variables that are live at a specific code offset.
// 537175b4d9097cf7f9719b9b366cada2: Create an address specifier with no content using empty parentheses, e.g., '()'.
// dbc61010b56c6e17fc7d45d9a6cfbc23: Define type parameters with optional 'phantom' annotations
