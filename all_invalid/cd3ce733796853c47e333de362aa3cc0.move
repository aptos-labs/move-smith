

//# publish
module 0xCAFE::TestModule {
    // Import the vector module
    use std::vector;

    struct MultiFieldStruct has copy, drop {
        field1: u64,
        field2: bool,
        field3: vector<u8>,
    }

    public fun create_struct(): MultiFieldStruct {
        MultiFieldStruct { 
            field1: 42,
            field2: true,
            field3: b"hello"
        }
    }

    public fun unpack_struct(s: MultiFieldStruct): (u64, bool, vector<u8>) {
        let MultiFieldStruct { field1, field2, field3 } = s;
        (field1, field2, field3)
    }

    // Function to create nested closures and return an explicit type
    // Closure returning a vector<u8>
    public fun nested_closure() {
        let outer_closure = |x: u8| {
            // Inner closure, returning a vector<u8>
            |y: u8| {
                let result = vector::empty<u8>();
                vector::push_back(&mut result, x);
                vector::push_back(&mut result, y);
                result
            }
        };
        // Call inner closure with argument 7
        let inner_fn = outer_closure(3);
        let res = inner_fn(5);
        // The res should be [3,5]
        let _ = res;
    }
}



//# run
script {
    fun main() {
        // Test creating and unpacking struct
        let s = 0xCAFE::TestModule::create_struct();
        let (field1, field2, field3) = 0xCAFE::TestModule::unpack_struct(s);
        // The variables are for testing and would typically be used in assertions
        // but assertions are ignored in this test.
        let _ = (field1, field2, field3);

        // Test nested closures with explicit return types
        0xCAFE::TestModule::nested_closure();
    }
}