//# publish
module 0xCAFE::VerifierTest {

    struct S has store, key, copy, drop {
        a: u8,
        b: u64,
        c: bool,
        d: vector<u8>,
    }

    public fun new_s(): S {
        S {
            a: 42u8,
            b: 1000000u64,
            c: true,
            d: b"Hello Move\0xCAFE",
        }
    }

    public fun runner() {
        let s = new_s();
        // Unpack struct fields
        let S { a, b, c, d } = s;

        // Use unpacked fields in some dummy code
        let _x = a + (b as u8);
        let _y = if c { 1u8 } else { 0u8 };
        let _z = vector::length(&d);
    }

}

//# run 0xCAFE::VerifierTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::VerifierTest;

    fun main(_signer: signer) {
        let s = VerifierTest::new_s();
        let S { a, b, c, d } = s;

        // Dummy consume usage to exercise byte string and unpacking
        let len = vector::length(&d);
        let bool_as_u8 = if c { 1u8 } else { 0u8 };
        let sum = a + (bool_as_u8 as u8) + (len as u8);

        // No assertions needed, just flow exercises compiler and VM
    }
}

// Featurres:
// 1df11cc43eeec814df9873a5318f87a8: Ensure modules pass the bytecode verifier before publishing or executing.
// 5f2a00cdcd250456968fb75d1c359440: Use byte string literals to include raw byte sequences within your code.
// 7d2f36c5f74800a3dae2a3d414aadf47: Unpack structs into fields on the left-hand side of an assignment.
