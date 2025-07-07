//# publish
module 0xCAFE::TestSpec {
    spec MySpec {
        field: u8;
    }
}

//# publish
module 0xCAFE::TestAbilities {
    // Duplicate abilities in the same context are not allowed
    // The following definition has duplicated `copy` ability and should produce an error during compilation
    struct DupAbilities has copy, drop, copy {
        a: u8
    }

    // Correct struct without duplicate abilities
    struct NoDupAbilities has store, key {
        b: u8
    }
}

//# run CheckScript

script {
    fun internal_fun() {
        let x = 5u8;
    }

    fun main() {
        internal_fun();
    }
}

// Featurres:
// 24697b5620d8e407cfa0c346d9d5fc04: Create a module specification block with a single member and optional attributes.
// d6b18feb62bf10640ad30fdeb701a653: Ensure that script functions do not use public, package, or friend visibility, as scripts must only contain internally visible functions.
// e5fe0227933449dc0c00c7c0a420afe8: Detect duplicate abilities in the same context and report errors
