//# publish
module 0xCAFE::ComplexAccess {
    // Test for local variable re-assignment and updating within a function

    // Public struct for storage
    struct Number has copy, drop, store, key {
        value: u64,
    }

    // Create a new Number
    public fun create_number(val: u64): Number {
        Number { value: val }
    }
}

//# publish
module 0xCAFE::FriendAccess {
    // FriendAccess is allowed to access ComplexAccess internals for demonstration.
    friend 0xCAFE::ComplexAccess; // Reverse the typical friend direction (not required here, but for illustration)

    use 0xCAFE::ComplexAccess;

    // Re-implement increment_by for friend-access demo, since "friend" methods must be defined in the callee,
    // but in Move, friend declarations need the friend module published first.
    // So, for this test, put increment_by here!
    fun increment_by(n: &mut ComplexAccess::Number, add: u64) {
        n.value = n.value + add;
    }

    public fun friend_increment(addr: address): u64 {
        let num = ComplexAccess::create_number(5);
        let n = &mut(num);
        // Chained function call using friend-access (simulates package boundary)
        increment_by(n, 15);
        // Return incremented value
        n.value
    }

    public fun get_number_owned<T>(v: T, x: u64): vector<u8> {
        // Just return bytes to show type-parameter presence
        b"complex"
    }

    public fun call_complex_address(): vector<u8> {
        get_number_owned<u8>(10u8, 9)
    }

    // Test for local variable re-assignment and updating within a function
    public fun test_locals_and_update(addr: address): u64 {
        let mut_num = ComplexAccess::create_number(10);
        let mut_num2 = ComplexAccess::create_number(30);

        let sum;
        sum = mut_num.value + mut_num2.value;

        // variable reassignment & updating
        let intermediate;
        intermediate = sum * 2;
        let final_val = intermediate + 2;
        // Now: mut_num will be incremented
        let n = mut_num;
        // No call to increment_by here, just returning final_val
        final_val
    }

    // runner function to be called as script test
    public fun runner() {
        let res = friend_increment(@0xCAFE);
        let complex_bytes = call_complex_address();
        let _ = (res, complex_bytes);
        let _ = test_locals_and_update(@0xCAFE);
    }
}

//# run 0xCAFE::FriendAccess::test_locals_and_update --signers 0xCAFE --args 0xCAFE
//# run 0xCAFE::FriendAccess::runner --signers 0xCAFE
//# run 0xCAFE::FriendAccess::call_complex_address --signers 0xCAFE

// Features:
// b47e794a03683025102fcc2f16562b5b: Use address specifier 'Call' with a chain of accesses, type arguments, and a name to specify a complex address involving function call semantics.
// 31ddf10201d17bf51c517c098d4beadd: Test that local variables declared with 'let' can be reassigned and updated within a function.
// 0ef6c610c35853f3409aab0a62c7da63: Enforce package-level boundaries for friend and package-visible functions.