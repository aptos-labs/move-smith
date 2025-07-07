//# publish
module 0xCAFE::FileReader {
    use std::vector;
    use std::option;
    use std::file;

    // This struct will store the file contents as vector<u8>
    struct FileContent has copy, drop {
        content: vector<u8>,
    }

    // Function to read a file by name and return contents
    public fun read_file(filename: vector<u8>): FileContent {
        // Try reading; returns option::Option<vector<u8>>
        let maybe_bytes = file::read_file(filename);
        match maybe_bytes {
            option::Some(bytes) => FileContent { content: bytes },
            option::None => FileContent { content: b"" },
        }
    }

    // Runner with a known file, e.g. test.move (should already exist during test infra)
    public fun runner() {
        let name = b"test.move";
        let _result = Self::read_file(name);
        // Discard result. Succeed if can read or empty fallback.
    }
}
//# run 0xCAFE::FileReader::runner

//# publish
module 0xCAFE::GenericTest {
    // A simple struct using a type parameter and primitive types
    struct Wrap<T: copy, drop> has copy, drop {
        t: T,
        number: u8,
    }

    // Create a Wrap<u8> and a Wrap<bool>, exercise generics and primitives
    public fun runner() {
        let x = Wrap<u8> { t: 99u8, number: 1u8 };
        let y = Wrap<bool> { t: true, number: 2u8 };
        let _ = (x, y); // Use to silence unused warning

        // Test loop with bodies and without bodies
        let mut_i = 0u8;
        while (let_i = mut_i; let_i < 5u8;) {
            mut_i = mut_i + 1u8;
        }
        // Now, loop with no body (single ;), just to test parser & VM
        let j = 0u8;
        while (j < 0u8) {}
    }
}
//# run 0xCAFE::GenericTest::runner

// Featurres:
// 164ba562c4731671143e8b98bdd3d61c: Open and read a Move source file by filename.
// d54f7f059d217f7618dea9ec827fa5c2: Use primitive types or type parameters in type declarations
// 90b396f0cda421632ed164532a7cc258: Create loop expressions with optional bodies.
