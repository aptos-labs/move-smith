
//# publish
module 0xBADD::TestModule {
    use std::vector;

    // Custom error code for diagnostic error testing
    const ERROR_CODE_DIAG: u64 = 9999;

    // Generic struct with type parameter
    struct Container<T> has copy, drop, store {
        value: T
    }

    // Struct with a nested generic struct
    struct NestedContainer<T> has copy, drop, store {
        inner: Container<T>
    }

    // Enum to test pattern matching with type arguments
    enum Status<E> has copy, drop {
        Active,
        Inactive,
        Pending,
        Custom(E)
    }

    // Function that processes pattern matching with destructuring generic pattern
    public fun handle_status<E: copy>(status: Status<E>): u64 {
        match (status) {
            Status::Active => 1,
            Status::Inactive => 2,
            Status::Pending => 3,
            Status::Custom(e) => {
                // Pattern matching with nested generic pattern
                // Pattern deconstruction with type argument pattern
                // For testing, just return a specific value
                match (e) {
                    // Since E can be any type, just handle the default case
                    _ => 42,
                }
            }
        }
    }

    // Function that executes an intentional diagnostic error to test error reporting
    public fun trigger_diag_error() acquires {
        // Simulate an error scenario: abort with custom error code
        abort(ERROR_CODE_DIAG);
    }

    // Lambda as a private top-level function that adds to the generic pattern
    fun private_lambda<T: copy>(x: T, y: T): T {
        // For simplicity, just return x
        x
    }

    // Function to test calling the private lambda with generic pattern
    public fun test_lambda<T: copy>(a: T, b: T): T {
        private_lambda(a, b)
    }
}



//# run 0xBADD::TestModule::handle_status --args 0u64


//# run 0xBADD::TestModule::trigger_diag_error --args


//# run 0xBADD::TestModule::test_lambda --args 10u64 20u64


// Features:
// ed8d524ae2cba3a5f48fa2e3eb5ff31e: Specify type arguments in struct or schema patterns during deconstruction for generic patterns.
// d0b1590093892fcbd530e24213ca133e: Handle diagnostic errors with a custom error reporting mechanism
// f760109d2b7d4ba9e4333b4b2b4a464f: Add new lambda functions as private top-level functions in the module after lifting.
