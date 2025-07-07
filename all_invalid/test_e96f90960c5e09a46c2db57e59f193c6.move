//# publish
module 0xA14::ErrorHandlingTest {
    struct Counter has key {
        count: u64,
    }

    struct Validator has key, store {
        active: bool,
    }

    /// Function to intentionally cause integer overflow.
    public fun trigger_overflow() {
        let _x = 18446744073709551615u64 + 1u64; // should abort
    }

    /// Function to attempt subtraction that results in underflow.
    public fun trigger_underflow() {
        let _x = 0u64 - 1u64; // should abort
    }

    /// Function to cause a division by zero.
    public fun trigger_divide_zero() {
        let _x = 1u64 / 0u64; // should abort
    }

    /// Function to trigger a modulus by zero.
    public fun trigger_mod_zero() {
        let _x = 1u64 % 0u64; // should abort
    }

    /// Moves a resource and triggers an abort to test resource loss.
    public fun resource_move_and_abort(account: &signer) {
        move_to(account, Validator { active: true });
        abort 999; // abort after move
    }

    /// Function that catches aborts to verify resource state.
    public fun safe_move_checker(account: &signer) {
        // attempt to move Validator resource
        // code should handle abort, but for testing, we just attempt
        // and see if resource exists
        if (exists<Validator>(signer::address_of(account))) {
            // do nothing
        } else {
            // resource does not exist
        }
    }

    /// Function to toggle an active flag with explicit resource check.
    public fun toggle_validator(account: &signer) {
        if (exists<Validator>(signer::address_of(account))) {
            let val = move_from<Validator>(signer::address_of(account));
            move_to(account, Validator { active: !val.active });
        } else {
            // resource does not exist, create new
            move_to(account, Validator { active: true });
        }
    }

    /// Function to catch integer overflow.
    public fun test_overflow() {
        trigger_overflow();
    }

    /// Function to catch underflow.
    public fun test_underflow() {
        trigger_underflow();
    }

    /// Function to catch divide by zero.
    public fun test_divide_zero() {
        trigger_divide_zero();
    }

    /// Function to catch modulus by zero.
    public fun test_mod_zero() {
        trigger_mod_zero();
    }

    /// Function to move resource and then abort, checking resource state.
    public fun test_resource_move_abort(account: &signer) {
        resource_move_and_abort(account);
        // code should not reach here if aborts propagate.
    }

    /// Function to verify resource existence after abort.
    public fun verify_resource_presence(account: &signer) {
        if (exists<Validator>(signer::address_of(account))) {
            // resource persists
        } else {
            // resource is missing
        }
    }
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::test_overflow()
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::test_underflow()
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::test_divide_zero()
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::test_mod_zero()
}
}

//# run --signers 0x1
script {
use 0xA14::ErrorHandlingTest;
fun main(account: signer) {
    // test resource move and abort
    ErrorHandlingTest::test_resource_move_abort(&account);
}
}

//# run --signers 0x1
script {
use 0xA14::ErrorHandlingTest;
fun main(account: signer) {
    // verify resource state after abort
    ErrorHandlingTest::verify_resource_presence(&account);
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::trigger_overflow();
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::trigger_underflow();
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::trigger_divide_zero();
}
}

//# run
script {
use 0xA14::ErrorHandlingTest;
fun main() {
    ErrorHandlingTest::trigger_mod_zero();
}
}