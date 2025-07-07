
//# publish
module 0xCAFE::CopyDestroy {
    struct Wrapper has copy, drop {
        val: u8,
    }

    public fun test_copy_and_destroy_chain(): bool {
        let w1 = Wrapper { val: 10u8 };
        // Copy w1 to w2
        let w2 = copy w1;
        // Copy w2 to w3
        let w3 = copy w2;

        // Re-assign w2 with a new Wrapper instance, destroys old w2
        let w2 = Wrapper { val: 20u8 };

        // After re-assignment destroy of old w2, copies chain related to old w2 should be invalid.
        // Check equality: w1.val and w3.val still 10, w2.val is 20
        // Use manual checks that these values are correctly independent
        let cond1 = (w1.val == 10u8);
        let cond2 = (w3.val == 10u8);
        let cond3 = (w2.val == 20u8);

        cond1 && cond2 && cond3
    }
}


//# run 0xCAFE::CopyDestroy::test_copy_and_destroy_chain


//# publish
module 0xCAFE::InterfaceWriter {
    use std::string;
    use std::vector;
    use std::debug;

    /// Dummy function to simulate writing interface files into deterministic directories.
    /// This does not actually do file writing, but logs the deterministic directory path.
    public fun write_interface_file(address: address, module_name: &vector<u8>) {
        // Convert address to u8 vector hex string representation (simplified)
        let addr_str = vector::empty<u8>();
        let addr_bytes = &address;
        vector::push_back(&mut addr_str, b'0');
        vector::push_back(&mut addr_str, b'x');
        // Simplify: just push the 8 bytes as hex chars (not correct hex conversion for brevity)
        let bytes = address.to_bytes();
        let i = 0;
        while (i < vector::length(&bytes)) {
            let byte = *vector::borrow(&bytes, i);
            vector::push_back(&mut addr_str, b'A' + (byte >> 4));
            vector::push_back(&mut addr_str, b'A' + (byte & 0xF));
            i = i + 1;
        };

        // Compose directory path: "gen_interfaces/" + addr_str + "/" + module_name
        let dir = b"gen_interfaces/";
        vector::append(&mut dir, &addr_str);
        vector::push_back(&mut dir, b'/');
        vector::append(&mut dir, module_name);

        // Log the directory path as a vector<u8>
        debug::print(&dir);
    }

    /// Wrapper to use string literals
    public fun runner() {
        write_interface_file(@0xCAFE, b"InterfaceWriter");
        write_interface_file(@0xBEEF, b"MyModule");
    }
}


//# run 0xCAFE::InterfaceWriter::runner



//# publish
module 0xCAFE::ConstTest {
    // Native constants are NOT supported:
    // const NATIVE_CONST: u64; // <- native not allowed, omit or define normally

    // Define a normal constant without native modifier
    const NORMAL_CONST: u64 = 0xDEADBEEF;

    public fun return_const(): u64 {
        NORMAL_CONST
    }
}


//# run 0xCAFE::ConstTest::return_const


// Featurres:
// 5f2ba91b946acfaef5bc1b41c3366d82: Test that destroying a variable in a copy chain with a re-assignment correctly removes all related copy information, ensuring equality comparisons use the correct values.
// 5da39f22b97fcdde468bbd846c1eb1d8: Write interface files into a deterministic directory for each module address and name.
// 2aa0d1241aaa35c2dbbc5ed762c75ab9: Native constants are not supported; do not use the 'native' modifier on constants.
