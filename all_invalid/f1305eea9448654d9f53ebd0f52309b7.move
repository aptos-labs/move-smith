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
    // FIXED: Removed duplicate `copy` ability
    struct DupAbilities has copy, drop {
        a: u8
    }

    // Correct struct without duplicate abilities
    struct NoDupAbilities has store, key {
        b: u8
    }
}

//# script

script {
    fun internal_fun() {
        let x = 5u8;
    }

    fun main() {
        internal_fun();
    }
}