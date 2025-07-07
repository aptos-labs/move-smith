//# publish
module 0xCAFE::ScopedAliasTest {
    use std::vector;
    use std::string;

    // A function to demonstrate grouping expressions in blocks
    public fun group_expressions(): u64 {
        let x = 1;
        {
            let y = 2;
            let z = y + x;
            z
        } +
        {
            let a = 3;
            a
        }
    }

    // A function to demonstrate variable aliasing and scope restoration
    public fun aliasing_scopes(): u64 {
        let val = 10;
        let result = {
            let val = 20; // This shadows the outer val
            val + 5
        };
        val + result // val outside block + result inside block
    }

    // A function to demonstrate imported member usage
    public fun vector_push_example(): vector::Vector<u8> {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 42);
        v
    }

    // Runner function that calls all above functions to exercise them
    public fun runner() {
        let _ = group_expressions();
        let _ = aliasing_scopes();
        let _ = vector_push_example();
    }
}

//# run 0xCAFE::ScopedAliasTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::ImportAlias {
    use std::vector::{Vector, push_back};

    // Alias Vector as Vec and push_back as pb to test alias import
    use std::vector::{Vector as Vec, push_back as pb};

    public fun import_alias_runner(): u64 {
        let mut v: Vector<u64> = vector::empty<u64>();
        push_back(&mut v, 10);
        pb(&mut v, 20);
        vector::length(&v)
    }
}

//# run 0xCAFE::ImportAlias::import_alias_runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::ScopedAliasTest;
    use 0xCAFE::ImportAlias;

    fun main() {
        let _ = ScopedAliasTest::group_expressions();
        let _ = ScopedAliasTest::aliasing_scopes();
        let v = ScopedAliasTest::vector_push_example();

        let len = ImportAlias::import_alias_runner();

        // No assertions needed, just exercise the functions and VM
        let _ = (v, len);
    }
}

// Featurres:
// ab0752c7406abd141c62b88224109b28: Group expressions in blocks to form sequences of statements or expressions.
// 2600ef82a57001239d1672a1df7ea46b: Manage variable aliases by entering a new scope for each sequence to prevent name conflicts and restore the previous scope after processing the sequence.
// 6027537863a2e7c5e74d6c3d82e94650: Import specific members of a module enclosed in braces with optional aliases
