//# publish
module 0xCAFE::Test1 {
    use std::signer;
    use std::vector;
    use std::signer; // needed for move_to import

    /// A struct with key ability so it can be stored in global storage,
    /// marked copy and drop for convenience in testing.
    struct Point has key, store, copy, drop {
        x: u64,
        y: u64,
    }

    /// Public function to create a Point and store it under the caller's account.
    public fun create_point(account: &signer, x: u64, y: u64) {
        let p = Point { x, y };
        move_to(account, p);
    }

    /// Public function that reads the Point stored under the caller's account and returns sum of x and y.
    public fun sum_coordinates(account: &signer): u64 {
        let p = borrow_global<Point>(signer::address_of(account));
        p.x + p.y
    }

    /// Public function that demonstrates lvalue tuple binding and returns sum of a and b.
    public fun test_let_binding(): u64 {
        // Multiple values destructuring in single let statement
        let (a, b) = (123u64, 456u64);
        a + b
    }

    /// Runner function to trigger the test_let_binding function
    /// No arguments or signers needed.
    public fun runner() {
        // Just call test_let_binding and discard result
        let _ = test_let_binding();
    }

    spec module {
        // Spec invariant with a generic type parameter T, dummy to test generic invariants
        // Spec generic parameters use <T>
        invariant<T> {
            // Just a trivial always true invariant, to test optional type parameters on invariants
            true
        }
    }
}
//# run 0xCAFE::Test1::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::Test1;
    use std::signer;

    fun main(account: signer) {
        // Call create_point and sum_coordinates to exercise public function visibility
        Test1::create_point(&account, 7u64, 8u64);
        let s = Test1::sum_coordinates(&account);
        // No assertions, ignoring s
        return;
    }
}