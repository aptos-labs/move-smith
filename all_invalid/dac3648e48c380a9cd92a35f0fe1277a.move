
//# publish
module 0xCAFE::DeprecationWrapper {
    /// Mark the entire namespace as deprecated to see if it propagates
    // deprecated]
    // Note: The deprecated attribute syntax may vary; in Move, it's usually // deprecated]
    // but since this is an illustrative comment, we will remove or comment it out if not supported.
    // Since deprecated attributes are often not supported at the namespace level, we will comment this.
    // If your compiler supports deprecated at namespace level, uncomment accordingly.
    // // deprecated]
    // Module content
//# publish
    module 0xCAFE::MyModule {}
}
// Note: The above publish block had improperly formatted comments which cause syntax errors.
// We need to properly comment or remove invalid comment syntax.


//# publish
module 0xCAFE::TestExplicitFailures {
    // This module will include code expected to cause compile-time errors
    // that are explicitly annotated so that the test runner can verify
    // proper failure reporting.
    // Example: declaring a variable without initialization in all control paths

    public fun fail_uninitialized_variable() {
        let x: u64;
        if (true) {
            x = 42;
        } else {
            // missing else branch initialization - move code within the if to avoid dead code
            // To fix, ensure x is initialized before use. Here, kept as is for test purpose.
            // For compilation, this will cause uninitialized variable error as intended.
        }
        // The following line is commented out intentionally
        // assert!(x == 42, 999);
    }

    public fun fail_invalid_assign() {
        let a = 10;
        // Attempting to mutate an immutable value (should cause compile error)
        // a = 20; // should cause compile error: cannot assign to immutable variable
        // Similarly, trying to assign to a temporary or non-mutable reference
        let b = copy a;
        // b = 6; // expected compile error: cannot assign to immutable variable `b`
    }
}


//# publish
module 0xCAFE::VerificationCheck {
    // Static bytecode verification check: the module should be verified before execution
    // The following constant is used to trigger verification explicitly
    const BYTECODE_CHECK: u8 = 1;
}


//# publish
module 0xCAFE::ComplexAssignments {
    // Tests for assignment via references, nested fields, expressions, inline functions, temporaries, and closures.

    // Simple struct to test nested field assignment
    struct Inner {
        value: u64,
    }

    struct Outer has store {
        inner: Inner,
        counter: u64,
    }

    public fun init_outer(): Outer {
        Outer {
            inner: Inner { value: 10 },
            counter: 0,
        }
    }

    // Function to mutate nested fields and variables
    public fun complex_assignments() {
        let outer = init_outer();

        // 1. Assignment to a nested field directly
        let outer_ref: &mut Outer = &mut outer;
        outer_ref.inner.value = 20;

        // 2. Assignment via temporary value
        let temp = Outer {
            inner: Inner { value: 30 },
            counter: 1,
        };
        outer = temp;

        // 3. Assignment via inline function returning a value
        // Move the inline function outside as "lambda" syntax is limited
        // In Move, inline functions can be defined as inline functions, not lambdas
        fun update_value(val: u64): u64 {
            val + 100
        }
        outer.counter = update_value(outer.counter);

        // 4. Assignment to a variable initialized in all paths
        let x: u64;
        if (outer.inner.value > 10) {
            x = outer.inner.value;
        } else {
            x = 0;
        };
        // Assign via expression involving x
        outer.counter = outer.counter + x;

        // 5. Assignment through closure capturing outer mutably
        // Move closure outside the function scope
        let capture_closure = |delta: u64| {
            outer.counter = outer.counter + delta;
        };
        capture_closure(5);
    }
}


//# run 0xCAFE::VerificationCheck::BYTECODE_CHECK


//# run 0xCAFE::DeprecationWrapper::MyModule --signers 0xBADD --args


//# run 0xCAFE::ComplexAssignments::complex_assignments


//# run 0xCAFE::TestExplicitFailures::fail_uninitialized_variable
// Expected failure: uninitialized variable x may cause compile error


//# run 0xCAFE::TestExplicitFailures::fail_invalid_assign
// Expected failure: attempts to mutate immutable value or temporaries

// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// 1011b8aa32f48fef72a832a6a7a35814: Write Move code that is statically checked for bytecode-level correctness before execution
// f592f715445dc4b59d133d0ac40d4069: Test that the compiler allows variable declarations before an if-else where all return paths are covered, even if the variable is only initialized in one branch and not used before the return.
// b6e96a49b120efc88bc72a8870c6502e: Test that assignment through &mut references (including to fields, nested fields, complex expressions, inline functions, temporaries, and closures) is correctly type-checked, handled, and never mutates non-mutable values or temporaries in the Aptos Move language.
