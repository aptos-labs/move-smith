
//# publish
module 0xCAFE::TestModule {
    // Struct with a type parameter
    struct Container<T> {
        value: T,
    }

    // Struct with multiple variants (enums)
    enum Variant {
        KindA,
        KindB,
        KindC,
    }

    // Function with private and friendless public functions
    public fun main() {
        let _container = Container { value: 42 };
        let _variant_a = Variant::KindA;
        let _variant_b = Variant::KindB;
        // Call the private function to check its dead code detection
        do_private_function();
        // Call a friendless public function
        do_public_without_friend();
    }

    // Private function (should warn about dead code if unused)
    fun do_private_function() {
        // no-op
    }

    // Public function with no friends (should warn about unused)
    public fun do_public_without_friend() {
        // no-op
    }
}

//# run 0xCAFE::TestModule::main --signers 0xCAFE