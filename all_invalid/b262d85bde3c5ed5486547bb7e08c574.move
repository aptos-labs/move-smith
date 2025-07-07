//# publish
module 0xCAFE::IdentifierTest {
    // Function to return module address and name as a tuple
    public fun get_module_info(): (address, vector<u8>) {
        (@0xCAFE, b"IdentifierTest")
    }
}

//# publish
module 0xCAFE::DataStructures {
    struct VecStruct has copy, drop {
        data: vector<u8>,
    }

    struct PackStruct has copy, drop {
        x: u64,
        y: bool,
    }

    struct NestedStruct has copy, drop {
        id: u64,
        inner: VecStruct,
        pack: PackStruct,
    }

    // Function to create a VecStruct
    public fun create_vec_struct(data: vector<u8>): VecStruct {
        VecStruct { data }
    }

    // Function to create a PackStruct
    public fun create_pack_struct(x: u64, y: bool): PackStruct {
        PackStruct { x, y }
    }

    // Function to create a NestedStruct
    public fun create_nested_struct(id: u64, data: vector<u8>, x: u64, y: bool): NestedStruct {
        let v_struct = create_vec_struct(data);
        let p_struct = create_pack_struct(x, y);
        NestedStruct { id, inner: v_struct, pack: p_struct }
    }
}

//# run 0xCAFE::IdentifierTest::get_module_info
//# run 0xCAFE::DataStructures::create_vec_struct --args b"hello" 
//# run 0xCAFE::DataStructures::create_pack_struct --args 42u64 true
//# run 0xCAFE::DataStructures::create_nested_struct --args 100u64 b"test" 7u64 false