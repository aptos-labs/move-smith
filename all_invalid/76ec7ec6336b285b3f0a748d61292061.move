
//# publish
module 0xBEE0::TestModule {
    use std::vector;

    struct CopyStruct has copy, drop {
        a: u8,
        b: u8,
    }

    public fun copy_struct_instance(): CopyStruct {
        CopyStruct {a: 10, b: 20}
    }
}


//# publish
module 0xBEE0::Transformations {
    use std::vector;
    use 0xBEE0::TestModule;

    // Function to test variable consumption with primitives in mutually exclusive branches
    public fun test_primitive_consumption(cond: bool): (u32, u32) {
        let x: u32 = 42;
        let y: u32 = 24;

        if (cond) {
            let _ = x;
        } else {
            let _ = y;
        };
        // We re-assign in different branches; simulate consumption by cloning
        let x2 = x;
        let y2 = y;
        (x2, y2)
    }

    // Function to test variable consumption with struct with copy/drop abilities
    public fun test_struct_consumption(cond: bool): (u8, u8) {
        let s = TestModule::copy_struct_instance();

        if (cond) {
            let _ = s.a;
        } else {
            let _ = s.b;
        };
        // clone s to simulate safe consumption
        let a_val = s.a;
        let b_val = s.b;
        (a_val, b_val)
    }

    // Function for rewriting specifications and verifying transformations
    public fun rewrite_and_transform(cond: bool): (u8, u8, u32, u32) {
        let (prim_x, prim_y) = test_primitive_consumption(cond);
        let (struct_a, struct_b) = test_struct_consumption(cond);
        let spec1 = if (cond) { prim_x } else { prim_y };
        let spec2 = if (!cond) { struct_a } else { struct_b };
        (spec1, spec2, prim_x, prim_y)
    }

    // Generate a set of source files for testing
    public fun make_files_source_text(): vector<vector<u8>> {
        let file1: vector<u8> = b"
            module 0xBEE0::TestModule {
                use std::vector;
                struct CopyStruct has copy, drop {
                    a: u8,
                    b: u8,
                }
                public fun copy_struct_instance(): CopyStruct {
                    CopyStruct {a: 10, b: 20}
                }
            }";

        let file2: vector<u8> = b"
            module 0xBEE0::Transformations {
                use std::vector;
                use 0xBEE0::TestModule;
                public fun test_primitive_consumption(cond: bool): (u32, u32) {
                    let x: u32 = 42;
                    let y: u32 = 24;
                    if (cond) {
                        let _ = x;
                    } else {
                        let _ = y;
                    };
                    let x2 = x;
                    let y2 = y;
                    (x2, y2)
                }
                public fun test_struct_consumption(cond: bool): (u8, u8) {
                    let s = TestModule::copy_struct_instance();

                    if (cond) {
                        let _ = s.a;
                    } else {
                        let _ = s.b;
                    };
                    let a_val = s.a;
                    let b_val = s.b;
                    (a_val, b_val)
                }
                public fun rewrite_and_transform(cond: bool): (u8, u8, u32, u32) {
                    let (prim_x, prim_y) = test_primitive_consumption(cond);
                    let (struct_a, struct_b) = test_struct_consumption(cond);
                    let spec1 = if (cond) { prim_x } else { prim_y };
                    let spec2 = if (!cond) { struct_a } else { struct_b };
                    (spec1, spec2, prim_x, prim_y)
                }
            }";

        vector::empty()
            |> vector::concat(vector::singleton(file1))
            |> vector::concat(vector::singleton(file2))
    }
}


//# run 0xBEE0::Transformations::test_primitive_consumption --args true
// with different boolean args to test consumption across branches


//# run 0xBEE0::Transformations::test_struct_consumption --args false


//# run 0xBEE0::Transformations::rewrite_and_transform --args true

// Featurres:
// 4432107e86be4f839c4cf9df52cc7518: Test that a variable declared with let and initialized with copy can be safely consumed twice through different code paths guarded by mutually exclusive boolean conditions, for both primitives and struct types with copy/drop abilities.
// 946f98cb5b61645c0d2428b7312cdd18: Rewrite specifications as part of code transformations.
// 637de7a85680d386bdf7afa6060e776a: Use `make_files_source_text` to generate a mapping from file content hashes to file names and contents for a set of source files.
