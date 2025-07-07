// Example transactional test for Aptos Move
// Features tested:
// 1. Handle unpacking of structs with multiple fields.
// 2. Assign values to lists of expressions in a single statement (tuple unpack).

//# publish
module 0xCAFE::StructUnpackTest {
    // Struct with multiple fields. 
    // All primitives have copy and drop by default.
    struct TestStruct has copy, drop, store {
        a: u8,
        b: u64,
        c: bool,
    }

    // Function to build a test struct
    public fun make_struct(x: u8, y: u64, z: bool): TestStruct {
        TestStruct { a: x, b: y, c: z }
    }

    // Test function that unpacks a struct into multiple bindings, and tuple assignment
    public fun runner() {
        let s = make_struct(7, 99, true);
        // Unpack the struct with multiple fields.
        let TestStruct { a, b, c } = s;
        // Assigning values to multiple variables in a single statement.
        let (x, y, z) = (a, b, c);

        // Assign again with different tuple expressions
        let (p, q, r) = (x + 1, y * 2, !z);
        // Consume variables so the function remains valid.
        use_vars(p, q, r);
    }

    public fun use_vars(x: u8, y: u64, z: bool) {
        // Just reference variables to ensure they're used.
        let _x = x;
        let _y = y;
        let _z = z;
    }
}

// After module published, run the runner function to exercise compiler+VM
//# run 0xCAFE::StructUnpackTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::StructUnpackTest;

    fun main(account: &signer) {
        // Also exercise the module's make_struct (direct call)
        let s = StructUnpackTest::make_struct(3, 2, false);
        // Unpack struct in script using full unpacking and tuple assignment
        let StructUnpackTest::TestStruct { a, b, c } = s;
        let (u, v, w) = (a, b, c);
        // Call module function to consume
        StructUnpackTest::use_vars(u, v, w);
    }
}

// Featurres:
// c19468a1da3acda83a13098dd8448c20: Handle unpacking of structs with multiple fields in Move code.
// 6eb3067fc04ceed51227965b4d9b3fe9: Assign values to lists of expressions in a single statement
