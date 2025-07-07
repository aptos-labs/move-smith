//# publish
module 0x01::AbortBehavior {

    // Function that aborts with a specific error code
    public fun fail_with_error() {
        abort 99;
    }

    // Function that aborts with another error code
    public fun fail_with_different_error() {
        abort 200;
    }

    // Function that does not abort
    public fun safe_function() {
        // no abort
    }

    // Function that combines aborts with logical AND, should abort if first aborts
    public fun abort_and() {
        fail_with_error() && safe_function();
    }

    // Function that combines aborts with logical OR, should abort if first aborts
    public fun abort_or() {
        fail_with_error() || safe_function();
    }

    // Function that combines successful function with abort in OR
    public fun success_or() {
        true || fail_with_error();
    }

    // Function that combines successful function with abort in AND, should not abort
    public fun success_and() {
        true && safe_function();
    }

    // Runner for abort_and
    public fun run_abort_and() {
        abort_and();
    }

    // Runner for abort_or
    public fun run_abort_or() {
        abort_or();
    }

    // Runner for success_or
    public fun run_success_or() {
        success_or();
    }

    // Runner for success_and
    public fun run_success_and() {
        success_and();
    }
}

//# run 0x01::AbortBehavior::run_abort_and --signers 0xASSERT --args
//# run 0x01::AbortBehavior::run_abort_or --signers 0xASSERT --args
//# run 0x01::AbortBehavior::run_success_or --signers 0xASSERT --args
//# run 0x01::AbortBehavior::run_success_and --signers 0xASSERT --args


//# publish
module 0x02::InlineFunctions {

    // Inline function applying passed functions to x and summing results
    inline fun calc(f: |u64| u64, g: |u64| u64, x: u64): u64 {
        f(x) + g(x)
    }

    // Test function utilizing 'calc'
    public fun test_calc() {
        assert!(calc(|v| v + 1, |v| v * 2, 10) == 23, 0);
        assert!(calc(|_| 5, |_| 7, 0) == 12, 1);
        assert!(calc(|v| v - 3, |v| v + 4, 6) == 11, 2);
    }
}

//# run 0x02::InlineFunctions::test_calc

//# publish
module 0x03::StructDropTest {

    // Struct with a phantom type and a drop ability
    struct Wrapper<phantom T> has drop {
        label: string,
    }

    // Function that creates and drops an instance
    public fun create_and_drop() {
        let _w: Wrapper<u64> = Wrapper<u64>{ label: "test" };
        // _w will be dropped after this function
    }
}

//# run 0x03::StructDropTest::create_and_drop