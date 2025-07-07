//# publish
address 0xCAFE {
module Module0 {
    // This function tests viewing initialized state of variables step by step.
    // It initializes some variables, modifies them, and returns a tuple of results.
    public fun view_vars(): (u64, bool, u8) {
        let x = 42u64;
        let y = true;
        let z = 10u8;
        // modify x
        let x = x + 1;
        // flip y
        let y = !y;
        // multiply z by 2
        let z = z * 2;
        (x, y, z)
    }

    // This function tests vector copying and moving
    // It copies a vector and then moves the original vector,
    // then accesses the reference to the vector copy.
    public fun test_vector_copy_move(): u8 {
        let v1 = vector::empty<u8>();
        vector::push_back(&mut v1, 7u8);
        vector::push_back(&mut v1, 11u8);

        let v2 = copy v1; // copy the vector
        let _moved_v1 = v1; // move original vector

        // Use reference to v2 after v1 moved (should be valid)
        let ref_v2 = &v2;
        // Return sum of elements to prove access
        let sum = (*ref_v2)[0] + (*ref_v2)[1];
        sum
    }

    // Runner function without arguments that calls both tests, discarding results
    public fun runner(_signer: &signer) {
        let _ = Self::view_vars();
        let _ = Self::test_vector_copy_move();
    }
}
}

//# run 0xCAFE::Module0::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::Module0;

    fun main(account: &signer) {
        Module0::runner(account);
    }
}

// Featurres:
// d4d86b2b4034f80cf9d967a21ee064f2: View the initialized state of variables before and after each instruction in a Move function.
// e42dce7ea06b22692bc18a435a5737ce: Test that a vector can be copied and then its reference used after moving the original vector, ensuring correct live variable analysis for references and moves.
// 0d819c688c655b41ba48a5bae7e0ea36: Use explicit address name syntax for defining addresses.
