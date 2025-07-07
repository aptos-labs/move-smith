
//# publish
module 0xBADD::FeatureTest {
    use std::vector;

    // Feature 1: Check for the presence of the Move module magic number
    // This is a compile-time check, not runtime, so we perform a dummy function that relies on the MAGIC constant.
    public fun check_magic() {
        let magic_value = std::u32::consts::MODULE_MAGIC;
        assert!(magic_value == 0xCADE, 9999);
    }

    // Feature 2: Use the 'Copy' ability for values to be duplicated
    public fun copy_value(x: u8): (u8, u8) {
        let y = copy x;
        (x, y)
    }

    // Feature 3: Test vector copy and reference safety
    public fun vector_copy_and_use_after_move(): u8 {
        let v1: vector<u64> = vector::empty<u64>();
        vector::push_back(&v1, 42);
        // Copy the vector handle
        let v2 = copy v1;
        // Use v2 after v1 is moved
        let borrowed_value = *vector::borrow(&v2, 0);
        borrowed_value
    }

    // Runner to execute all tests
    public fun run() {
        check_magic();
        let (a, b) = copy_value(10u8);
        assert!(a == 10u8 && b == 10u8, 1234);

        let result = vector_copy_and_use_after_move();
        assert!(result == 42, 5678);
    }
}


//# run 0xBADD::FeatureTest::run


// Featurres:
// 0570ad80826f2d2b88ce4fcf68107ff6: Check for the presence of the Move module magic number in a binary file
// 238182ffc740764119186b5d92e4ed82: Use the 'Copy' ability to allow values to be duplicated.
// e42dce7ea06b22692bc18a435a5737ce: Test that a vector can be copied and then its reference used after moving the original vector, ensuring correct live variable analysis for references and moves.
