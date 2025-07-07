
//# publish
module 0xCAFE::DuplicateCheck {
    struct UniqueStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct AnotherStruct has store {
        x: bool,
    }

    enum Color has copy, drop {
        Red,
        Green,
        Blue,
    }

    private fun private_function(): u8 {
        42
    }

    public fun call_private(): u8 {
        private_function()
    }

    public fun create_structs(): UniqueStruct {
        UniqueStruct { a: 1, b: 2u16 }
    }

    public fun duplicate_struct_def_test() {
        // We cannot redeclare UniqueStruct here, so trying to emulate no overwrite behavior
        // because Move compiler enforces no duplicate structs in the same module.
    }
}


//# run 0xCAFE::DuplicateCheck::call_private


//# run 0xCAFE::DuplicateCheck::create_structs


// Featurres:
// 7316bb769ca175c4835e19f740d6b134: Ensure that struct definitions are added without overwriting existing ones by checking for duplicates.
// 47924a32bab1c833b9aee713c5bab9b9: Use 'private' visibility for functions accessible only within the defining module.
// ee2f45bc2ad7ed5a6ecea83d00cd9342: Define structs and enum structures within modules.
