// # publish
module 0xCAFE::TestModule {

// Test struct to use in spec and move functions
struct Data has store, copy, drop {
    val: u64,
}

// A normal test function - should work fine
#[test]
public fun test_success() {
    let x = 1u64;
    let y = 1u64;
    let z = x + y;
    let _ = z; // use z so no warning
}

// A test function with expected failure attribute - valid usage
#[test]
#[expected_failure]
public fun test_expected_failure() {
    assert(false, 1); // always fails
}

// Invalid: #[expected_failure] without #[test] - uncommenting this should cause compiler error
// #[expected_failure]
// public fun invalid_expected_failure() {}

// Spec block to test assignment with '=' syntax
spec module {
    // State variable for spec
    variable counter: u64;

    // Update counter assignment to another expression
    update inc_counter() {
        counter = counter + 1;
    }

    // Assign using '=' more than once to ensure internal assignment works in specs
    update reset_and_increment() {
        counter = 0;
        counter = counter + 10;
    }
}

// Runner function for tests that require no args, signers
public fun run() {
    test_success();
    test_expected_failure();
}

}

// # run 0xCAFE::TestModule::run --signers 0xCAFE

// # publish
module 0xBEEF::OtherPkg {

// A function we expose to test cross-package calls
public fun external_func(): u64 {
    42
}

}

// # run
script {
    use 0xCAFE::TestModule;
    use 0xBEEF::OtherPkg;

    fun main() {
        // Call the runner in TestModule (valid call)
        TestModule::run();

        // Try to call function from other package directly - this should fail at compile time
        // Uncommenting the following line should cause compile error because cross package direct call is disallowed
        // let val = OtherPkg::external_func();
        // let _ = val;
    }
}

// Featurres:
// b68fd5df19d1fd7e122925cea71b6bb9: Use #[expected_failure] attribute on test functions to mark expected failures, ensuring they are only on functions annotated with #[test].
// 7cc49543fa09eb05657b36151d8d9960: Write specification block update statements that assign one expression to another using the '=' syntax inside Move spec blocks
// eabf01419e097908e5f01fa6b40be7de: Ensure that functions from different packages cannot be called directly
