
//# publish
module 0xCAFE::SpecAndVectorTest {
    // Spec functions and native spec functions, vector with type parameters, abilities declaration.

    use std::vector;

    // struct with ability declared after variants with postfix ability declaration
    struct Container<T> has copy, store {
        inner: vector<T>
    }

    // enum with abilities before and after variant list, and ability postfix decl
    enum Status has copy, drop, store {
        Ok,
        Error(u64);
    } has key;

    // Use vector of generic type in struct
    struct VectorWrapper<T> has copy, drop, store {
        items: vector<T>
    }

    // Spec functions in spec block
    spec module {
        fun spec_fun(x: u8): u8 {
            x + 1
        }

        native fun native_spec_fun(x: u8): bool;
    }

    public fun call_spec_funs(x: u8): bool {
        let a = spec_fun(x);
        // call native spec function will return bool, here we just return it
        Self::native_spec_fun(a)
    }

    public fun create_container<T>(elems: vector<T>): Container<T> {
        Container<T> {inner: elems}
    }

    public fun create_vector_wrapper<T>(items: vector<T>): VectorWrapper<T> {
        VectorWrapper<T> {items}
    }

    public fun get_status_error_code(s: Status): u64 {
        match s {
            Status::Ok => 0,
            Status::Error(code) => code,
        }
    }
}


//# run 0xCAFE::SpecAndVectorTest::call_spec_funs --args 10u8


//# run 0xCAFE::SpecAndVectorTest::create_container --args vector[1u8, 2u8, 3u8]


//# run 0xCAFE::SpecAndVectorTest::create_vector_wrapper --args vector[4u64, 5u64, 6u64]


//# run 0xCAFE::SpecAndVectorTest::get_status_error_code --args 0u8


//# run 0xCAFE::SpecAndVectorTest::get_status_error_code --args 1u64


// Featurres:
// f3a04639cbf00572c112bac1cda633ed: Define specification functions or native specification functions using the 'fun' or 'native' keywords in spec blocks.
// 197544a0f742c8cd528080dbf5dd48fd: Declare vector types that can contain type parameters as elements
// 2731021478adb70b395236d2630f22ed: Declare abilities before or after variant lists with optional postfix ability declarations.
