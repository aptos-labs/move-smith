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

    // Internal-only manipulation, package-level "friend" example
    friend 0xCAFE::FriendAccess; // Only FriendAccess is a friend

    // This is a (simulated) package-internal function,
    // Aptos Move doesn't currently have package-private, but 'friend' is close
    fun increment_by(n: &mut Number, add: u64) {
        n.value = n.value + add;
    }

    // Exposed public runner function
    public fun test_locals_and_update(addr: address): u64 {
        let mut_num = create_number(10);
        let mut_num2 = create_number(30);

        let sum;
        sum = mut_num.value + mut_num2.value;

        // variable reassignment & updating
        let intermediate;
        intermediate = sum * 2;
        let final_val = intermediate + 2;
        // Now: mut_num will be incremented
        let n = mut_num;
        // Use friend-call access chain: ComplexAccess::increment_by
        // (this will be accessed by friend only in next module)
        final_val
    }

    // This public function can be called with Call-Access chain with type parameters,
    // for demonstration.
    public fun get_number_owned<T>(v: T, x: u64): vector<u8> {
        // Just return bytes to show type-parameter presence
        b"complex"
    }
}
//# run 0xCAFE::ComplexAccess::test_locals_and_update --signers 0xCAFE --args 0xCAFE

//# publish
module 0xCAFE::FriendAccess {
    // Test friend and friend-call semantics, including call-chaining

    // Accessing private function via friend access
    use 0xCAFE::ComplexAccess;

    public fun friend_increment(addr: address): u64 {
        let num = ComplexAccess::create_number(5);
        let n = &mut(num);
        // Chained function call using friend-access (simulates package boundary)
        // increment_by only accessible because of 'friend' declaration in ComplexAccess
        ComplexAccess::increment_by(n, 15);
        // Return incremented value
        n.value
    }

    public fun call_complex_address(): vector<u8> {
        // Address specifier 'Call' with chain and type argument:
        // Simulate the call: 0xCAFE::ComplexAccess::get_number_owned<u8>(b'a', 9)
        0xCAFE::ComplexAccess::get_number_owned<u8>(10u8, 9)
    }

    // runner function to be called as script test
    public fun runner() {
        let res = friend_increment(@0xCAFE);
        let complex_bytes = call_complex_address();
        let _ = (res, complex_bytes);
    }
}

//# run 0xCAFE::FriendAccess::runner --signers 0xCAFE

//# run 0xCAFE::FriendAccess::call_complex_address --signers 0xCAFE

// Featurres:
// b47e794a03683025102fcc2f16562b5b: Use address specifier 'Call' with a chain of accesses, type arguments, and a name to specify a complex address involving function call semantics.
// 31ddf10201d17bf51c517c098d4beadd: Test that local variables declared with 'let' can be reassigned and updated within a function.
// 0ef6c610c35853f3409aab0a62c7da63: Enforce package-level boundaries for friend and package-visible functions.
