//# publish
module 0xCAFE::ComplexLvalueShadowing {
    use std::vector;

    // Struct with multiple fields for testing tuple destructuring assignment
    struct Pair has copy, drop {
        a: u64,
        b: u64,
    }

    // Function to test tuple destructuring assignment to multiple variables
    public fun tuple_assignment_example(): (u64, u64, u64) {
        let (x, y, z) = (1u64, 2u64, 3u64);
        // Reassign with expressions using tuple destructuring
        let (a, b, c) = (x + 10, y + 20, z + 30);
        (a, b, c)
    }

    // Function to test tuple destructuring assignment with struct fields
    public fun destruct_struct_fields(): (u64, u64) {
        let p = Pair { a: 7u64, b: 11u64 };
        let Pair { a: a_val, b: b_val } = p;
        (a_val, b_val)
    }

    // Test variable shadowing with an inline closure that reassigns outer scope variable
    public fun shadowing_with_closure(): u64 {
        let mut outer = 5u64;
        let f = || {
            let outer = 10u64;
            outer
        };
        let inner = f();
        outer + inner
    }
}

//# run 0xCAFE::ComplexLvalueShadowing::tuple_assignment_example

//# run 0xCAFE::ComplexLvalueShadowing::destruct_struct_fields

//# run 0xCAFE::ComplexLvalueShadowing::shadowing_with_closure


//# publish
module 0xCAFE::MakeFilesSourceText {
    use std::vector;
    use std::string;

    struct FileContent has copy, drop, store {
        name: vector<u8>,
        content: vector<u8>,
    }

    struct FileMap has store {
        files: vector<FileContent>,
    }

    // Constructs a FileMap from vectors of names and contents
    public fun make_files_source_text(
        names: vector<vector<u8>>,
        contents: vector<vector<u8>>,
    ): FileMap {
        let files = vector::empty<FileContent>();
        let len_names = vector::length(&names);
        let len_contents = vector::length(&contents);
        assert!(len_names == len_contents, 100);
        let mut i = 0;
        while (i < len_names) {
            let name = vector::borrow(&names, i);
            let content = vector::borrow(&contents, i);
            let file = FileContent {
                name: vector::clone(name),
                content: vector::clone(content),
            };
            vector::push_back(&mut files, file);
            i = i + 1;
        };
        FileMap { files }
    }

    // Return length of files vector in FileMap for validation
    public fun file_map_len(fm: &FileMap): u64 {
        vector::length(&fm.files)
    }
}

//# run 0xCAFE::MakeFilesSourceText::make_files_source_text --args vector[b"file1.move", b"file2.move"] vector[b"module A {}", b"script {main() {}}"]

//# run 0xCAFE::MakeFilesSourceText::file_map_len --args


// Featurres:
// d479217191dddd027e7ba5e8ee233f7b: Use complex lvalues such as tuples on the left-hand side of assignment to assign multiple variables at once.
// 54cf3a2312b67ef38fb60f071d65d5c2: Test that variable shadowing allows the outer scope variable to be reassigned from within an inline closure.
// 637de7a85680d386bdf7afa6060e776a: Use `make_files_source_text` to generate a mapping from file content hashes to file names and contents for a set of source files.
