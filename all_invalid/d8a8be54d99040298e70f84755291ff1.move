//# publish
module 0xCAFE::StructTest {
    // Struct with a primitive type field and a generic field.
    struct MyStruct<T> has copy, drop, store {
        id: u64,
        val: T,
    }

    // Non-generic struct for clarity.
    struct NotGeneric has copy, drop, store {
        x: u8,
    }

    // "Runner" function to test pack expression, let-bindings, primitive type sanity.
    public fun run_struct_tests() {
        // 1. Packing with a module, optional type arguments, and fields (using pack expr).
        let s1 = MyStruct<u8> { id: 42, val: 15u8 };
        let s2 = MyStruct<NotGeneric> { id: 100, val: NotGeneric { x: 250 } };

        // 2. Let binding for symbol with specified expression.
        let simple_val = 77u8;
        let tval = 0xABCDu64;

        // 3. Make sure 'u64' is used as concrete type, not as a type parameter by accident.
        let s3 = MyStruct<u64> { id: 9, val: 123456u64 };
        let s4 = NotGeneric { x: simple_val };

        // Touch the values so they're used (no-ops).
        let _ = s1;
        let _ = s2;
        let _ = s3;
        let _ = s4;
        let _ = tval;
    }
}
//# run 0xCAFE::StructTest::run_struct_tests --signers 0xCAFE

//# run
script {
    use 0xCAFE::StructTest;

    fun main() {
        // Directly call runner function from script context.
        StructTest::run_struct_tests();
    }
}