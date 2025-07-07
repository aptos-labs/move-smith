//# publish
module 0xabcde::var_test {
    // Test updating a local variable multiple times and returning its final value
    fun update_local_var(): u64 {
        let mut counter = 10;
        counter = counter + 5;
        counter = counter * 2;
        counter
    }

    // Runner function
    public fun main() {
        assert!(update_local_var() == 30, 0);
    }
}

//# run 0xabcde::var_test::main

//# publish
module 0xabcde::nested_abort {
    fun inner_abort(): u64 {
        abort 42;
    }

    fun outer_abort(): u64 {
        inner_abort(); // Should trigger abort 42
        0
    }

    // Function to test abort propagation
    public fun test_abort(): u64 {
        outer_abort();
        0 // Should not reach here
    }
}

//# run 0xabcde::nested_abort::test_abort

//# publish
module 0xabcde::resource_borrow {
    use 0x1::signer;

    struct Flag has key, drop {
        value: bool
    }

    // Initialize resource at address s
    fun init_flag(s: &signer) {
        move_to(s, Flag { value: true });
    }

    // Borrow and verify the resource at a given address
    fun get_flag(addr: address): bool reads Flag {
        borrow_global<Flag>(addr).value
    }

    // Attempt to borrow a resource from an uninitialized address (should fail)
    fun fail_borrow(addr: address): bool {
        borrow_global<Flag>(addr).value
    }

    // Creator to initialize resource for testing
    public fun setup(s: &signer) {
        init_flag(s);
    }
}

//# run --signers 0x1 -- 0xabcde::resource_borrow::setup

//# run --args @0x1 -- 0xabcde::resource_borrow::get_flag

//# run --args @0x2 -- 0xabcde::resource_borrow::fail_borrow