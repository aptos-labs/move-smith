// file: StructHandleTest.move
//# publish
module 0xCAFE::StructHandleTest {
    use std::vector;
    use std::type;

    struct S has store, key { val: u64 }

    public fun create_s(): S {
        S { val: 42 }
    }

    public fun runner() {
        let s = create_s();
        let _ = s; // consume s to avoid unused warning
    }

    // This function returns the `S` type tag via the `Struct` feature (by handle index)
    public fun get_type_tag_struct_handle(): type::Type {
        // Explicitly use Struct by handle index here to get the type
        // Normally, `Type` can be constructed using `Struct` with module and struct handles
        type::Type::Struct(type::Struct {
            address: 0xCAFE,
            module_name: b"StructHandleTest",
            struct_name: b"S",
            abilities: vector::empty<u8>(),
            generic_type_params: vector::empty<type::Type>()
        })
    }
}
//# run 0xCAFE::StructHandleTest::runner --signers 0xCAFE

// file: SpecReturnTypeTest.move
//# publish
module 0xCAFE::SpecReturnTypeTest {
    spec module {
        // Spec function with explicit return type annotation
        fun spec_explicit_return(): u64 {
            123
        }

        // Spec function without return type, defaults to unit
        fun spec_implicit_return(): () {
            // no explicit return needed
        }
    }

    public fun runner() {
        // no runtime code needed; spec functions don't execute at runtime
    }
}
//# run 0xCAFE::SpecReturnTypeTest::runner --signers 0xCAFE

// file: ScriptRunner.move
//# run
script {
    use 0xCAFE::StructHandleTest;
    use 0xCAFE::SpecReturnTypeTest;

    fun main() {
        // Calling the runner functions to exercise VM and compiler
        StructHandleTest::runner();
        SpecReturnTypeTest::runner();
    }
}