
//# publish
module 0xCAFE::ResourcePermissionTest {
    use std::signer;

    struct Permit has key, store {
        id: u64,
        granted: bool,
    }

    public fun create_permit(s: signer, id: u64): Permit {
        Permit { id, granted: false }
    }

    public fun grant_permission(p: &mut Permit) {
        p.granted = true;
    }

    public fun use_permission(p: &Permit): bool {
        p.granted
    }

    // Runner that creates a permit, grants permission, and checks use_permission
    public fun runner(s: signer): bool {
        let permit = create_permit(s, 123);
        grant_permission(&mut permit);
        use_permission(&permit)
    }
}


//# run 0xCAFE::ResourcePermissionTest::runner --signers 0xBEEF


//# run 0xCAFE::ResourcePermissionTest::create_permit --signers 0xBEEF --args 42u64


    // Attribute attached to this constant
    // plain]
    const MAX_COUNT: u64 = 100;

    // test_only]
    const MESSAGE: vector<u8> = b"Testing Attributes";

    fun main() {
        let count: u64 = MAX_COUNT;
        let _message: vector<u8> = MESSAGE;
        // Code block with multiple statements and a final expression
        {
            let x = 1 + 2;
            let y = x * 3;
            x + y // final expression without semicolon, returns 9
        };
    }
}


//# run --signers 0xFEED


// Featurres:
// 02631bce2439dd3897f85984bbc2d9bd: Write code blocks (sequences) comprising multiple statements and an optional final expression.
// b780cd281bc15892e47b5a16d51ecde3: Configure functions to acquire resources or permissions during execution.
// 6e849da79a5ab5af6f0e827f4a094ec3: Attach attributes to individual 'const' declarations inside your script.
