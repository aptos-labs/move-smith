//# publish
module 0x1::test_module {
    use std::error;
    use std::signer;
    use std::vector;

    // Struct to test mutation
    struct Counter has copy, drop, store {
        count: u64,
    }

    // Initialize the Counter resource under a specific address
    public fun init_counter(owner: &signer) has store {
        move_to(owner, Counter { count: 0 })
    }

    // Mutable function that increments the counter and returns its value
    public fun increment_counter(counter_ref: &mut Counter): u64 {
        counter_ref.count = counter_ref.count + 1;
        counter_ref.count
    }

    // Function to get a reference to the Counter resource
    public fun get_counter_ref(owner_addr: address): &mut Counter acquires Counter {
        &mut borrow_global_mut<Counter>(owner_addr)
    }

    // Function with invalid visibility to test enforcement (should fail if called)
    fun private_function() {
        // do nothing
    }
}

 //# run
script {
    // This script will test unsigned 16-bit arithmetic edge cases
    use std::debug;
    use std::error;
    use 0x1::test_module;

    // Valid operations
    let a: u16 = 40000;
    let b: u16 = 6000;

    // Addition - should overflow
    // Should trigger panic or error
    debug::print(&u16::add(a, b)); // expecting overflow error

    // Subtraction
    debug::print(&u16::sub(a, b)); // should succeed, result: 34000

    // Multiplication
    debug::print(&u16::mul(300, 200)); // should succeed, result: 60000

    // Division
    let div_result = u16::div(a, b);
    debug::print(&div_result); // valid division

    // Modulus
    let mod_result = u16::mod(a, b);
    debug::print(&mod_result); // valid modulus

    // Division by zero - should panic or error
    // You can simulate or note that this should cause an abort
    // e.g., debug::print(&u16::div(b, 0)); // expecting division by zero error
}

 //# run 0x1::test_module::init_counter --signers 0xA while true {
    // simulate a test runner for increment_counter
    // initialize the counter under address 0xA
    // repeatedly call increment_counter and check the output
//! Worker code to fetch and mutate
// The following code demonstrates calling the increment_counter function multiple times
// to verify mutation behavior and return values.

// First, initialize the counter
//0x1::test_module::init_counter --signers 0xA

// Loop to invoke increment_counter repeatedly
for i in 1..=10 {
    //# run 0x1::test_module::get_counter_ref::increment_counter --signers 0xA --args
    // Passing the address to get mutable reference
    // expected: increments counter each time, returning count value
    // e.g.,
    // //# run 0x1::test_module::increment_counter --signers 0xA --args <result of get_counter_ref>
}