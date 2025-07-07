//# publish
module 0xCAFE::AccessSpecifiersTest {
    use std::vector;

    // Testing access specifiers construction and usage

    /// Enum to simulate access specifiers
    public enum AccessSpecifier has copy, drop, store {
        Private,
        Public,
        Script,
        Friend,
    }

    /// Construct and return Private specifier
    public fun private_access(): AccessSpecifier {
        AccessSpecifier::Private
    }

    /// Construct and return Public specifier
    public fun public_access(): AccessSpecifier {
        AccessSpecifier::Public
    }

    /// Construct and return Script specifier
    public fun script_access(): AccessSpecifier {
        AccessSpecifier::Script
    }

    /// Construct and return Friend specifier
    public fun friend_access(): AccessSpecifier {
        AccessSpecifier::Friend
    }

    /// Runner function to exercise constructors and borrowing
    public fun runner(): AccessSpecifier {
        let priv = Self::private_access();
        let pub = Self::public_access();
        let scr = Self::script_access();
        let frd = Self::friend_access();

        // Borrowing immutably the public access specifier reference
        let pub_ref = &pub;

        // Use the borrowed value in a dummy expression (match)
        match pub_ref {
            AccessSpecifier::Public => {},
            _ => {},
        };

        // Returning one instance just to exercise return value
        frd
    }
}
//# run 0xCAFE::AccessSpecifiersTest::runner

//# publish
module 0xCAFE::ModuleFileTest {
    use std::vector;
    use std::signer;

    /// Sample data to simulate file contents with magic number
    struct ModuleFile has copy, drop, store {
        magic: vector<u8>,
        content: vector<u8>,
    }

    /// Known magic number to identify a compiled Move module file (e.g. 'MOVE' signature)
    const MAGIC_NUMBER: vector<u8> = b"MOVE";

    /// Create a dummy compiled module file
    public fun create_module_file(): ModuleFile {
        let content = b"\x00\x61\x62\x63\x64\x65"; // dummy bytecode content
        ModuleFile {
            magic: copy MAGIC_NUMBER,
            content,
        }
    }

    /// Verify the magic number in the module file content
    public fun verify_magic(file: &ModuleFile): bool {
        if (vector::length(&file.magic) == vector::length(&MAGIC_NUMBER)) {
            let mut i = 0;
            let length = vector::length(&MAGIC_NUMBER);
            while (i < length) {
                if (*vector::borrow(&file.magic, i) != *vector::borrow(&MAGIC_NUMBER, i)) {
                    return false;
                };
                i = i + 1;
            };
            true
        } else {
            false
        }
    }

    /// Runner to create a file, verify its magic and return dummy value
    public fun runner(): bool {
        let file = Self::create_module_file();
        let result = Self::verify_magic(&file);
        result
    }
}
//# run 0xCAFE::ModuleFileTest::runner

//# run
script {
    use 0xCAFE::AccessSpecifiersTest;
    use 0xCAFE::ModuleFileTest;

    fun main() {
        // Run the AccessSpecifiersTest runner function
        let _ = AccessSpecifiersTest::runner();

        // Run the ModuleFileTest runner function
        let _ = ModuleFileTest::runner();
    }
}

// Featurres:
// 47d4ca81c3e1568d734b223e6ca2faf1: Use the constructor function to create specific types of access specifiers during parsing.
// 237605aafab643cc82370697bc77220c: Use '&' to borrow a variable immutably in expressions.
// 0c284b2c46af0aad538cc694b9614ca9: Store compiled Move modules in files with a recognizable magic number for identification
