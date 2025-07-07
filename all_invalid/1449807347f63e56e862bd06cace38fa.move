//# publish
module 0xCAFE::GenericModule {
    use std::option;

    /// A generic container struct with copy and drop abilities.
    struct Container<T> has copy, drop, store {
        val: T,
    }

    /// A generic enum representing a simple variant with generic data
    /// Uses copy and drop.
    enum MyEnum<T: copy + drop> has copy, drop {
        VariantA,
        VariantB(T),
    }

    /// Generic function to create a container with a given value.
    public fun create_container<T>(val: T): Container<T> {
        Container<T> { val }
    }

    /// Extract the value from Container<T>.
    public fun get_val<T: copy + drop>(c: &Container<T>): T {
        copy c.val
    }

    /// Function that matches on generic enum MyEnum<T>.
    /// Returns true if variant is VariantA, false otherwise.
    public fun is_variant_a<T: copy + drop>(e: &MyEnum<T>): bool {
        match (e) {
            MyEnum::VariantA => true,
            MyEnum::VariantB(_) => false,
        }
    }

    /// Runner function to test generic structs and enums without argument.
    public fun runner() {
        let c = create_container<u64>(123u64);
        let v = get_val<u64>(&c);
        // Ignoring assertions as per instruction

        let e1 = MyEnum::VariantA<u8>;
        let e2 = MyEnum::VariantB<u8>(42u8);
        let b1 = is_variant_a<u8>(&e1);
        let b2 = is_variant_a<u8>(&e2);
        // Ignoring assertions
    }
}
//# run 0xCAFE::GenericModule::runner

//# publish
module 0xCAFE::MultiFileDependent {
    use 0xCAFE::GenericModule;

    struct Wrapper<T> has copy, drop, store {
        container: GenericModule::Container<T>,
        enum_val: GenericModule::MyEnum<T>,
    }

    public fun create_wrapper_u8(val: u8): Wrapper<u8> {
        let c = GenericModule::create_container<u8>(val);
        let e = GenericModule::MyEnum::VariantB<u8>(val);
        Wrapper<u8> { container: c, enum_val: e }
    }

    /// Function that reads from Wrapper and returns true if the enum variant is VariantB
    public fun is_variant_b(wrapper: &Wrapper<u8>): bool {
        match (&wrapper.enum_val) {
            GenericModule::MyEnum::VariantB(_) => true,
            GenericModule::MyEnum::VariantA => false,
        }
    }

    public fun runner() {
        let w = create_wrapper_u8(99u8);
        let b = is_variant_b(&w);
        let v = GenericModule::get_val<u8>(&w.container);
        // Ignoring assertions again.
    }
}
//# run 0xCAFE::MultiFileDependent::runner

//# run
script {
    use 0xCAFE::GenericModule;
    use 0xCAFE::MultiFileDependent;

    fun main() {
        let c = GenericModule::create_container<u64>(2024u64);
        let val = GenericModule::get_val<u64>(&c);

        let e = GenericModule::MyEnum::VariantA<u64>;
        let is_a = GenericModule::is_variant_a<u64>(&e);

        let w = MultiFileDependent::create_wrapper_u8(255u8);
        let is_b = MultiFileDependent::is_variant_b(&w);

        // No assertion, just execute code to test compiler and VM
    }
}

// Featurres:
// 2ce90d901bca5fb6660243f591a0acdf: Write Move source code in multiple files, which are then deterministically sorted and compiled to ensure repeatable builds.
// b89769747726b0ff0a79b7b55c58d5d4: Use type parameters in generic functions and structs.
// dd45b96ea0255dd2bc3c9268e179045c: Write match expressions using the syntax `match (<exp>) { <arms> }` to perform pattern matching in Move code.
