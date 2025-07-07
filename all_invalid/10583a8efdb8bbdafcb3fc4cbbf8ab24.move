
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    struct PhantomStruct<T> has copy, drop, store, key {
        // No fields, phantom type parameter T
        // Note: 'is_phantom' is not a valid Move keyword; to declare phantom types you simply define the struct without fields using T.
    }

    struct Container<T> has key {
        value: u8,
        _phantom: PhantomStruct<T>,
    }

    public fun let_binding_example(): u8 {
        let a = 5u8;
        let b = a + 10u8;
        b
    }

    public(deprecated_script) fun deprecated_func(s: signer): u8 {
        let x = signer::address_of(&s);
        let _unused = x;
        42u8
    }

    entry fun entry_function_example(s: signer) acquires Container {
        let addr = signer::address_of(&s);
        let c = Container<u8> { value: 99u8, _phantom: PhantomStruct<u8> {} };
        move_to<Container<u8>>(&s, c);
    }
}



//# run 0xCAFE::FeatureTest::let_binding_example



//# run 0xCAFE::FeatureTest::deprecated_func --signers 0xBABE



//# run 0xCAFE::FeatureTest::entry_function_example --signers 0xBABE


// Featurres:
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
// 442e0dcdfd33d8af2b7856544d547ff0: Mark struct type parameters as phantom using is_phantom
// 77fd16c7d6ef9e1e8e0b07ecad6da90a: Declare a function with optional public, entry, or deprecated script visibility modifiers.
