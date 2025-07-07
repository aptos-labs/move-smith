// ====================
// 1. Module using immutable borrow and address Literal
// ====================
//# publish
module 0xBEADC0DE::TestFeature {
    // Struct to store a simple value
    struct MyData has key {
        value: u64,
    }

    // Publish resource under caller's address
    public entry fun publish_data(account: &signer, v: u64) {
        move_to(account, MyData { value: v });
    }

    // Function using immutable borrows (&), returns value by reference
    public fun get_value(addr: address): u64 {
        // Use address Literal in borrow_global
        let data_ref = borrow_global<MyData>(0xBEADC0DE);
        // Immutable borrow the .value field
        let value_ref: &u64 = &data_ref.value;
        // Use the borrowed reference in an expression (copy the value)
        *value_ref + 100
    }

    // Function with explicit return annotation and runner for test
    public entry fun runner(account: &signer) {
        // Publish data to this account
        Self::publish_data(account, 42);
        // Call get_value and drop result
        let _result = Self::get_value(@0xBEADC0DE);
        // (Result unused, just to exercise code)
    }
}

//# run 0xBEADC0DE::TestFeature::runner --signers 0xBEADC0DE

// ====================
// 2. Script using address Literal and immutable borrow
// ====================
//# run
script {
    use 0xBEADC0DE::TestFeature;

    fun main(account: &signer) {
        // Use address Literal directly in script and call get_value
        let val = TestFeature::get_value(@0xBEADC0DE);
        let res: u64 = &val + 2; // use '&' even on locals
        let _ = res;
    }
}