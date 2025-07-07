// This transactional test exercises:
// 1. Module-level friend relationships with 'friend'
// 2. Native function declaration with multi-parameter and multi-return
// 3. Iteration over a collection of lvalues and custom function processing

// =========================== MODULE 1 ===========================
//# publish
module 0xCAFE::FriendTarget {
    // This struct and function are private, but can be accessed by the friend module.
    struct Secret has copy, drop { value: u64 }

    // A public constructor for test purposes
    public fun create_secret(val: u64): Secret {
        Secret { value: val }
    }

    // Private function to double a number
    fun double(x: u64): u64 {
        x * 2
    }

    // Expose internal function to friend modules only
    friend 0xCAFE::FriendCaller;

    // This function is only callable by a friend
    fun friend_only_calc(x: u64): u64 {
        double(x) + 100
    }

    // Test function to show Secret usage
    public fun reveal(s: &Secret): u64 {
        s.value
    }
}

// ========================== MODULE 2 (FRIEND) ==========================
//# publish
module 0xCAFE::FriendCaller {
    // Declare friendship usage for compilation
    use 0xCAFE::FriendTarget;

    // Call the friend-only function in the target module
    public fun call_friend_func(x: u64): u64 {
        // This would fail without friendship!
        FriendTarget::friend_only_calc(x)
    }

    public fun call_secret_reveal(): u64 {
        let s = FriendTarget::create_secret(777);
        FriendTarget::reveal(&s)
    }

    // Runner for test
    public fun runner(): u64 {
        Self::call_friend_func(42) + Self::call_secret_reveal()
    }
}
    //# run 0xCAFE::FriendCaller::runner

// ============================ MODULE 3 (NATIVE) =========================
//# publish
module 0xCAFE::NativeDemo {
    native public fun multi_params_and_returns(x: u64, y: u8): (u8, u64);

    // Import for simulation/test purposes (simulate the result)
    public fun simulate_native(x: u64, y: u8): (u8, u64) {
        // Simulate native logic: swap and increment
        (y + 1, x + 10)
    }

    // Runner for test
    public fun native_runner(): (u8, u64) {
        Self::simulate_native(10, 21)
    }
}
    //# run 0xCAFE::NativeDemo::native_runner

// ==================== MODULE 4 (COLLECTION/ITERATION) ===================
//# publish
module 0xCAFE::LvalueIterate {
    // Function to process (square) each value in a vector of u64s
    public fun square_each(input: &mut vector<u64>) {
        let len = vector::length(input);
        let mut i = 0;
        while (i < len) {
            // Get a mutable reference to each element and mutate in place
            *vector::borrow_mut(input, i) = custom_square(*vector::borrow(input, i));
            i = i + 1;
        }
    }

    // Custom function for demonstration (square a value)
    fun custom_square(v: u64): u64 { v * v }

    // Runner for testing: will initialize and run square_each
    public fun runner(): vector<u64> {
        let mut v = vector[2, 5, 9];
        Self::square_each(&mut v);
        v
    }
}
    //# run 0xCAFE::LvalueIterate::runner

// ============================= SCRIPT 1 ==============================
//# run
script {
    use 0xCAFE::LvalueIterate;

    fun main() {
        // Runner function to test iteration
        let res = LvalueIterate::runner();
        // res should now be vector[4, 25, 81]
    }
}

// ============================= SCRIPT 2 ==============================
//# run
script {
    use 0xCAFE::NativeDemo;

    fun main() {
        let (b, n) = NativeDemo::native_runner();
        // b == 22u8, n == 20u64
    }
}

// Featurres:
// 2e44c943908f03ef3c8d0b8d6d02a784: Declare module-level friend relationships using the 'friend' feature.
// 04713cafdd3f020f94c6eb5ebe4ceade: Declare multiple parameters and return types for a native function.
// ab69861b97fb5288b5cf94638af3e7a6: Iterate over a collection of lvalues and process each one with a custom function.
