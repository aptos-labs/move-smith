// file: StructHandleTest.move
//# publish
module 0xCAFE::StructHandleTest {
    use std::vector;

    struct S has store, key { val: u64 }

    public fun create_s(): S {
        S { val: 42 }
    }

    public fun runner() {
        let s = create_s();
        let _ = s; // consume s to avoid unused warning
    }

    // This function returns the `S` type tag via the `Struct` feature (by handle index)
    public fun get_type_tag_struct_handle(): std::type::Type {
        // Explicitly use Struct by handle index here to get the type
        // Normally, `Type` can be constructed using `Struct` with module and struct handles
        std::type::Type::Struct(StructHandle {
            address: 0xCAFE,
            module: b"StructHandleTest",
            name: b"S",
            abilities: std::vector::empty<u8>(),
            generic_type_params: std::vector::empty<std::type::Type>()
        })
    }
}
//# run 0xCAFE::StructHandleTest::runner --signers 0xCAFE

// file: SpecReturnTypeTest.move
//# publish
module 0xCAFE::SpecReturnTypeTest {
    use std::vector;

    spec module {
        // Spec function with explicit return type annotation
        public fun spec_explicit_return(): u64 {
            123
        }

        // Spec function without return type, defaults to unit
        public fun spec_implicit_return() {
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

// Featurres:
// 33393c308eb8a6712ef2abfbbd0718db: Specify struct types by their handle index using the 'Struct' feature.
// fdb59ec2bff91564a747de8c365df315: Associate each source file with its filename and content for further analysis or processing.
// ac5550c3dc0faea9883b6ddb91b73e4a: Specify return types for spec functions using the colon syntax, or fall back to unit return if omitted.
