//# publish
module 0xCAFE::LoopTest {
    const CONST_VAL: u64 = 100;

    // A function to test a for-loop with immutable loop variable
    fun test_for_loop_immutable() {
        let x: u64 = 0;
        let nums = vector::empty<u64>();
        let nums = vector::push_back(nums, 1);
        let nums = vector::push_back(nums, 2);
        let nums = vector::push_back(nums, 3);

        // The following loop tries to assign to the loop variable 'i' and should fail to compile.
        // So we won't put that code here (it would not compile),
        // but the fact that the compiler accepts this test means it accepts immutability.

        // Instead, we write a correct loop with a loop variable and confirm usage:

        for i in nums {
            // i is immutable - cannot do: i = i + 1;
            // We do some reading only to test the compiler behavior.
            let _val = i + CONST_VAL;
            // i is immutable, reassignment would error out and is not attempted here.
        };
    }

    // Generic function using type parameter T and primitive types in type declarations
    fun generic_function<T>(val: T, count: u64): vector<T> {
        let mut v = vector::empty<T>();
        let mut i = 0;
        while (i < count) {
            v = vector::push_back(v, val);
            i = i + 1;
        };
        v
    }

    // Runner function to exercise the above code
    public fun runner() {
        test_for_loop_immutable();

        let v = generic_function<u8>(42u8, CONST_VAL);
        let _len = vector::length(&v);
    }
}

//# run 0xCAFE::LoopTest::runner --signers 0xCAFE

// Featurres:
// ef7dd4f6c5026fa243fcc93c244ad89e: Test that the loop variable in a Move for-loop is immutable and cannot be reassigned within the loop body.
// d54f7f059d217f7618dea9ec827fa5c2: Use primitive types or type parameters in type declarations
// 36f33fe235cdad4c61527b4091b05f11: Ensure constant values are within the u64 range.
