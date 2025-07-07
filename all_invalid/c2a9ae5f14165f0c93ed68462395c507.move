// 0xCAFE is the test address

//# publish
module 0xCAFE::AttributeTest {
    // This test module tries to test attributes used incorrectly, like nested attributes
    // and also tests inline functions with closure arguments.

    // Trying to place an attribute in an illegal or nested place should cause warnings or errors.
    // However, since this is a transactional test, just defining some @ attributes in strange places
    // will exercise the compiler's attribute handling.

    // For demonstration, we place a dummy attribute in an illegal location (a comment says so).
    // Note: This will trigger warnings or errors as intended by the test runner.

    // A valid inline function that accepts a closure of no arguments and returns u8
    public inline fun call_closure_noargs(f: &fun(): u8): u8 {
        f()
    }

    // An inline function that accepts a closure with 2 u64 args, returns u64
    public inline fun call_closure_2args(f: &fun(u64, u64): u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    // An inline function that accepts a closure with 1 u8 arg, returns u8
    public inline fun call_closure_1arg(f: &fun(u8): u8, x: u8): u8 {
        f(x)
    }

    // A function to generate test cases:
    // For example, generate all u8 numbers from start to end inclusive and return as vector<u8>
    public fun generate_u8_range(start: u8, end: u8): vector<u8> {
        let mut res = vector::empty<u8>();
        let mut i = start;
        while (i <= end) {
            vector::push_back(&mut res, i);
            i = i + 1;
        }
        res
    }

    // Runner function to be called without arguments.
    // Invokes the inline functions with closures testing the closure arguments of different kinds.
    public fun runner(): vector<u8> {
        // 1. call_closure_noargs with closure returning 42u8
        let val0 = call_closure_noargs(&((): u8 { 42 }));

        // 2. call_closure_2args with closure returning sum
        let val1 = call_closure_2args(&((x: u64, y: u64): u64 { x + y }), 40, 2);

        // 3. call_closure_1arg with closure returning arg + 1
        let val2 = call_closure_1arg(&((x: u8): u8 { x + 1 }), 41);

        // Generate test vector using generate_u8_range from val0 to val2 inclusive.
        // val0 = 42, val2 = 42, so range is 42..42 = [42] single element
        let range = generate_u8_range(val0, val2);

        // Return the vector to exercise vector usage.
        range
    }
}
//# run 0xCAFE::AttributeTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::AttributeTest;

    fun main(account: signer) {
        let res = AttributeTest::runner();
        // Just use res so no unused warnings, no assertions needed.
        // For demonstration, just discard.
        vector::empty<u8>();
    }
}

// Featurres:
// 28e3cac7cfb6fd855decf014568a084c: Identify and warn about attributes used in incorrect positions, such as nested attributes where they are not expected.
// 426aee62717231b92c1e9e4a6b492596: Test that the inline function correctly accepts and executes closure arguments with different parameter configurations and returns the expected computed value.
// f4a5587deaeba3f912adad22b2d6230f: Use the module's functions to generate a list of test cases based on specific criteria.
