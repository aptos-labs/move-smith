//# publish
module 0x1::TestPhantom {
    use std::marker;
    use std::vector;

    // A simple phantom struct: Phantom<T> with no fields
    struct Phantom<T> has copy, drop, store {
        _marker: marker::PhantomData<T>,
    }

    // A struct with multiple fields, including a phantom type parameter U that is unused
    struct DataWithPhantom<T, U> has copy, drop, store {
        value: u64,
        label: vector<u8>,
        phantom: Phantom<U>,
    }

    // Return a new Phantom instance
    fun new_phantom<U>(): Phantom<U> {
        Phantom {_marker: marker::PhantomData}
    }

    // Create and return a DataWithPhantom<T, U> with given value and label
    fun new_data<T, U>(value: u64, label: vector<u8>): DataWithPhantom<T, U> {
        DataWithPhantom {
            value,
            label,
            phantom: new_phantom<U>(),
        }
    }

    // A runner function to exercise unpacking DataWithPhantom with field unpacking having phantom
    public fun run() {
        // Create an instance with phantom u8, phantom parameter is unused in data
        let data = new_data<u64, u8>(42, b"hello");

        // Unpack with specified fields, ignore phantom by discarding it
        let DataWithPhantom {value, label, phantom: _} = data;

        // We do no assertions here, just unpacking to test compiler
        let _ = value;
        let _ = label;
    }
}
//# run 0x1::TestPhantom::run


//# publish
module 0x1::TestSourceLocation {
    use std::vector;

    /// A struct to represent SourceLocation as in Aptos Framework
    struct SourceLocation has copy, drop, store {
        file_hash: vector<u8>,
        start: u32,
        end: u32,
    }

    /// Construct a SourceLocation for given file_hash and start/end positions
    public fun new_source_location(file_hash: vector<u8>, start: u32, end: u32): SourceLocation {
        SourceLocation {
            file_hash,
            start,
            end,
        }
    }

    /// Runner to create a SourceLocation and unpack it with specified fields
    public fun run() {
        let hash = b"abcdefghabcdefghabcdefghabcdefgh"; // 32-byte file hash

        // Create source location
        let loc = new_source_location(hash, 10, 20);

        // Unpack fields explicitly
        let SourceLocation {file_hash, start, end} = loc;

        // Use variables to avoid unused warnings
        let _ = file_hash;
        let _ = start;
        let _ = end;
    }
}
//# run 0x1::TestSourceLocation::run


//# run
script {
    use 0x1::TestPhantom;
    use 0x1::TestSourceLocation;
    use std::vector;

    fun main() {
        // Call TestPhantom runner to exercise phantom type and unpack
        TestPhantom::run();

        // Call TestSourceLocation runner to exercise source location creation and unpack
        TestSourceLocation::run();

        // Additional direct unpacking in script to test unpacking with specified fields

        let data = TestPhantom::new_data<u8, u16>(99, b"world");
        let TestPhantom::DataWithPhantom {value, label, phantom: _} = data;
        let _ = value;
        let _ = label;

        let hash = b"zyxwvutsrqponmlkjihgfedcbaabcdef";
        let loc = TestSourceLocation::new_source_location(hash, 5, 15);
        let TestSourceLocation::SourceLocation {file_hash, start, end} = loc;
        let _ = file_hash;
        let _ = start;
        let _ = end;
    }
}