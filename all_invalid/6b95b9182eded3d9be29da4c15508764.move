//# publish
module 0xCAFE::TestOptionalTypeParams {
    use std::signer;

    struct Data<T> has copy, drop, store {
        value: T
    }

    struct Container has key {
        data: Data<u64>
    }

    public fun create_container(s: signer, val: u64) {
        let d = Data<u64> { value: val };
        let c = Container { data: d };
        move_to<Container>(&s, c);
    }

    public fun fetch_container_value(s: signer): u64 {
        let c_ref = borrow_global<Container>(signer::address_of(&s));
        c_ref.data.value
    }

    // Using optional type parameter pattern in spec signature for demonstration
    spec module {
        struct Data<T> {
            value: T;
        }

        function dummy<T>(): bool;
    }

    public fun dummy<T>() {
        // Dummy function to test optional type parameter specification patterns
    }
}

//# run 0xCAFE::TestOptionalTypeParams::create_container --signers 0xBEEF --args 987u64

//# run 0xCAFE::TestOptionalTypeParams::fetch_container_value --signers 0xBEEF

// Featurres:
// 3ead418b1ce59f603f43e76987f39c53: Declare structs within modules.
// 5f0bdd6ad1a7efa983e75c7cc96d83a6: Specify optional type parameters within the specification pattern.
// 5f1b7e24ebb57d672feaf7f6235ba7d7: Write module identifiers using the syntax <address>::<module_name> in your Move programs.
