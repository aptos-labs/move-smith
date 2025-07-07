//# publish
module 0xCAFE::VisibilityTest {
    /// A public friend function with no return value.
    public(friend) fun friend_fn() {
        // This function should be accessible to friend modules
    }

    /// A public script function returning bool
    public(script) fun script_fn(): bool {
        // Return true explicitly
        return true;
    }

    /// A public package function with an argument and return value
    public(package) fun package_fn(x: u64): u64 {
        if (x > 0) {
            return x;
        }
        return 0;
    }

    /// A private function which returns a fixed value
    fun private_fn(): u8 {
        return 42;
    }

    /// Runner function to call other public functions inside this module
    public(script) fun runner(): bool {
        // call friend_fn (should be OK inside the module)
        friend_fn();

        // call script_fn and ensure return is propagated
        let res = script_fn();
        if (!res) {
            return false;
        }
        // call package_fn with 10, expect 10
        let val = package_fn(10);
        if (val != 10) {
            return false;
        }

        // call private_fn and check value
        let private_val = private_fn();
        if (private_val != 42) {
            return false;
        }

        // explicit return true
        return true;
    }
}
//# run 0xCAFE::VisibilityTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::VisibilityTest;

    fun main() {
        // Directly call the public script function, check return (no assert needed)
        let b = VisibilityTest::script_fn();
        return;
    }
}

//# run
script {
    use 0xCAFE::VisibilityTest;

    fun main() {
        // Call the package function (public(package)) from script, allowed?
        // This will test visibility from script to package function.
        let v = VisibilityTest::package_fn(99);
        return;
    }
}

//# run
script {
    use 0xCAFE::VisibilityTest;

    fun main() {
        // Try to explicitly return from main with a value from a function (allowed?)
        // Should be allowed to return void or return.
        let val = VisibilityTest::script_fn();
        if (val) {
            // explicit return
            return;
        }
        // if not, just return anyway
        return;
    }
}

// Featurres:
// 7824497406c0a2cffa665434660b9333: Parse the source content of a Move file to extract definitions and comments.
// e63e42321ff4978cb6c06f6f0400322f: Use 'public()' with 'script', 'friend', or 'package' sub-modifiers to declare different levels of visibility.
// c2a87e653143cce1e6d6463e6d200f77: Return from functions using the `return` expression, optionally with a value.
