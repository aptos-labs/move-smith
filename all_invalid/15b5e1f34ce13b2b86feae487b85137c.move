
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Enum with nested enum variants and some distinct types
    enum MetaData has copy, drop {
        Info(u64),
        Details { description: vector<u8>, timestamp: u64 },
        Flag(bool),
    }

    // Struct with nested struct
    struct Container<T> has copy, drop, store, key {
        id: u64,
        data: T,
    }

    // Function testing various control flow constructs and string escape sequences
    public fun complex_control_flow(x: u8, flag: bool): u8 {
        if (flag) {
            let _temp1 = 10;
        } else {
            let _temp2 = 20;
        };
        let result;
        match (x) {
            0 => result = 0,
            1 => result = 1,
            _ => result = 255,
        };
        let s1: vector<u8> = b"Line1\nLine2\r\nTab\tEnd\\\"";
        let s2: vector<u8> = x"abc\x00\x01";
        if (x > 10) {
            result = result + 1;
        } else {
            result = result - 1;
        };
        // Return the computed value
        result
    }

    // Inline function returning a tuple
    public inline fun pairwise_sum(a: u32, b: u32): (u32, u32) {
        (a + b, a - b)
    }

    // Function testing enums and pattern matching
    public fun handle_metadata(tag: MetaData): u8 {
        match (tag) {
            MetaData::Info(val) => val as u8,
            MetaData::Details { description: desc, timestamp: _ } => {
                // Return length of description or 0 if empty
                vector::length<&vector<u8>>(&desc)
            },
            MetaData::Flag(flag) => if (flag) { 1 } else { 0 },
        }
    }

    // Function testing function pointers and copying
    public fun apply_function(ptr: |u8| u8, val: u8): u8 {
        ptr(val)
    }

    // Function testing nested structs and string literals with escape sequences
    public fun create_container() {
        let desc: vector<u8> = b"This is a test string with \n newline, \t tab, and \\" backslash.";
        let container: Container<vector<u8>> = Container { id: 42, data: desc };
        // Use container in some way
        let _ = container.id;
        let _ = vector::length<&vector<u8>>(&container.data);
    }
}


//# run 0xCAFE::TestModule::complex_control_flow --args 15u8 true


//# run 0xCAFE::TestModule::pairwise_sum --args 100u32 200u32


//# run 0xCAFE::TestModule::handle_metadata --args MetaData::Info(123456789u64)



//# run 0xCAFE::TestModule::handle_metadata --args MetaData::Details { description: b"Sample description\nwith new line".to_vector(), timestamp: 161803398u64 }


//# run 0xCAFE::TestModule::handle_metadata --args MetaData::Flag(true)


//# run 0xCAFE::TestModule::apply_function --signers 0xBEEF --args |u8| u8,5u8


//# run 0xCAFE::TestModule::create_container

// Featurres:
// 944c71e0a34ef5d7ebaf41b064209326: Exclude spec blocks associated with filtered-out members from the module.
// 3ac43b78737cf1b5249e62b2be37e37f: Use the standard string escape sequences (\n, \r, \t, \\, \0, \" ) inside Move byte string literals.
// 4920ae24a905cbbf287461b8bd4655d5: Define a module name using an identifier.
