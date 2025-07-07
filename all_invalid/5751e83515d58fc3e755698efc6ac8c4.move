// Transactional test for Aptos Move

script {
    // 1. Map source file hashes to their corresponding file names and content
    use std::hash;
    use std::string;

    // A struct to store source file info in memory for test purpose
    struct SourceFileInfo has copy, drop, store {
        name: vector<u8>,
        content: vector<u8>,
        hash: vector<u8>,
    }

    // Function to simulate hashing a source file content
    fun hash_source(content: &vector<u8>): vector<u8> {
        // Using SHA3-256 from std::hash (if available in Aptos std)
        // Note: Aptos std::hash only provides hashing primitives. We'll simulate.
        hash::sha3_256(content)
    }

    // 3. Custom attribute assignment using '=' syntax on structs/modules.
    //
    // Move attributes are limited, but Aptos Move recently supports:
    // #[foo = 42]
    // Apply it on a dummy struct and a dummy function to test parsing.

    #[foo = 42]
    struct AttrTest has copy, drop, store {
        #[bar = 100]
        field: u64,
    }

    #[foo = 7]
    fun attr_test_fun(u: u64): u64 {
        u + 1
    }

    // 2. Conditional branch with an infinite loop containing a break
    fun test_conditional_loop_break(cond: bool): u64 {
        let mut i = 0;
        if cond {
            loop {
                // Infinite loop but breaks immediately
                break;
            }
            i = 42;
        } else {
            i = 7;
        };
        i
    }

    fun test_transactional(): u64 acquires SourceFileInfo {
        // Simulate source files
        let name1 = string::utf8(b"ModuleA.move");
        let content1 = string::utf8(b"module 0x1::ModuleA { /*...*/ }");
        let hash1 = hash_source(&content1);

        let name2 = string::utf8(b"ModuleB.move");
        let content2 = string::utf8(b"module 0x1::ModuleB { /*...*/ }");
        let hash2 = hash_source(&content2);

        // Store info in vectors (simulate map)
        let info1 = SourceFileInfo { name: name1, content: content1, hash: hash1 };
        let info2 = SourceFileInfo { name: name2, content: content2, hash: hash2 };

        // Verify that hashes are consistent and files differ
        assert!(info1.hash != info2.hash, 1001);

        // Test conditional loop with break
        let r1 = test_conditional_loop_break(true);
        assert!(r1 == 42, 1002);

        let r2 = test_conditional_loop_break(false);
        assert!(r2 == 7, 1003);

        // Test attribute values (just using dummy calls to prevent "unused" warning)
        let t = AttrTest { field: 123 };
        let res = attr_test_fun(t.field);
        assert!(res == 124, 1004);

        res
    }
}

// Featurres:
// 0772e38ae5cf4b0bc3d91be9a39786fd: Associate source file hashes with their corresponding file names and source contents for use in the package system.
// e21c2311d71aed9b099d9976f106e805: Test that a conditional branch with an infinite loop containing a break statement executes correctly without causing deadlock or unintended behavior.
// 9be637bb0ab85bd36006309d3ed55829: Assign values to attributes using the '=' syntax (e.g., #[foo = 42]).
