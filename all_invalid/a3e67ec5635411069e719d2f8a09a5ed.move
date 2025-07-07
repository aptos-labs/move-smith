//# publish
module 0xCAFE::AttrSpec {
    // Module-level spec block with attribute
    spec module {
        #[test_attribute]
        const MY_CONST: u64 = 42;
    }

    // A generic struct with one type parameter T
    struct GenStruct<T> has store, key {
        value: T,
    }

    // A runner function that creates and returns GenStruct<u64>
    public fun runner(): GenStruct<u64> {
        GenStruct { value: 100 }
    }
}
//# run 0xCAFE::AttrSpec::runner

//# run
script {
    use 0xCAFE::AttrSpec;

    fun main() {
        // Create an instance of GenStruct<u8>
        let gs: AttrSpec::GenStruct<u8> = AttrSpec::GenStruct { value: 255u8 };

        // Call the runner function that returns GenStruct<u64>
        let gs64 = AttrSpec::runner();
        let _val_u64 = gs64.value;

        // The code only exercises the compiler and VM;
        // no assertions or output needed.
    }
}

// Featurres:
// 1db81fe0db0a4b13fc748f0d00c7155f: Attach attributes to a module-level specification block
// aea0924f9167959f01edde6ae806553e: Filter modules, scripts, or addresses based on specific criteria during compilation.
// 18337b379384f2c8fe0fb128bd8a8c7c: Declare type parameters for Move struct types
