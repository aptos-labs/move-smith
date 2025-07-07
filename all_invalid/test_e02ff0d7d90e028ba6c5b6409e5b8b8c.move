//# publish
module 0xA100::TokenManagement {

    use 0x42::objects as obj;

    // Define a simple token resource with a value
    struct TokenResource has key {
        value: u64
    }

    // Function to initialize and store a token resource for an owner
    public fun init_token(owner: &obj::OwnerRef, val: u64, signer: &signer) {
        let addr = obj::owner_addr_of(owner);
        move_to<TokenResource>(signer, TokenResource { value: val });
    }

    // Function to get a token's value via a reader reference
    public fun get_token_value(reader: &obj::ReaderRef<TokenResource>): u64 {
        borrow_global<TokenResource>(obj::reader_addr_of(reader)).value
    }

    // Function to set a token's value via a writer reference
    public fun set_token_value(writer: &obj::WriterRef<TokenResource>, new_val: u64) {
        borrow_global_mut<TokenResource>(obj::writer_addr_of(writer)).value = new_val;
    }

    // Helper function to create a token and verify its value update
    public fun test_token_flow(owner_addr: address, initial_val: u64, updated_val: u64, signer_addr: address) {
        // Create owner reference
        let owner_ref = obj::make_owner_ref(owner_addr);
        // Initialize token with initial value
        init_token(&owner_ref, initial_val, &signer_addr);

        // Obtain reader and writer references
        let reader_ref = obj::reader_ref(&owner_ref);
        let writer_ref = obj::writer_ref(&owner_ref);

        // Read value
        let val = get_token_value(&reader_ref);
        assert!(val == initial_val, 0);

        // Update value
        set_token_value(&writer_ref, updated_val);

        // Verify update via reader
        let new_val = get_token_value(&reader_ref);
        assert!(new_val == updated_val, 1);
    }
}

//# run --signers 0xA100
script {
    use 0xA100::TokenManagement;

    fun main(s: signer) {
        // Invoke test with specified addresses and values
        TokenManagement::test_token_flow(@0xA100, 100, 200, @0xA100);
    }
}

//# publish
module 0xA100::ClosureShadowing {

    public fun test_shadowing() {
        let outer_var: u64 = 10;
        let outer_var_ref = &mut outer_var;

        // Closure that modifies outer variable
        let mut closure = |new_val: u64| {
            *outer_var_ref = new_val;
        };

        // Invoke closure with new value
        closure(42);
        assert!(*outer_var_ref == 42, 0);
    }
}

//# run 0xA100::ClosureShadowing::test_shadowing

//# publish
module 0xA100::FunctionPassing {

    // Two functions to be passed as arguments
    inline fun f1(x: u64): u64 {
        x + 1
    }

    inline fun g1(x: u64): u64 {
        x * 2
    }

    // A function that accepts two functions and applies them to x, summing results
    inline fun apply_functions(f: |u64| u64, g: |u64| u64, x: u64): u64 {
        f(x) + g(x)
    }

    public fun test() {
        let result = apply_functions(f1, g1, 7);
        assert!(result == (7 + 1) + (7 * 2), 0);
    }
}

//# run 0xA100::FunctionPassing::test