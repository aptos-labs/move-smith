//# publish
module 0xCAFE::InteractionTest {
    use std::vector;

    // Private internal struct, should not be accessible from outside
    struct InternalStruct has store, key {
        value: u64
    }

    // Function to create and store internal structure - internal, not pub
    fun internal_create(s: signer, val: u64) {
        let obj = InternalStruct { value: val };
        move_to<InternalStruct>(&s, obj);
    }

    // Public function to invoke internal creation
    public fun public_create(s: signer, val: u64) {
        internal_create(s, val);
    }

    // Fetch internal struct, only accessible internally
    fun get_internal_value(addr: address): u64 {
        let obj_ref: &InternalStruct = borrow_global<InternalStruct>(addr);
        obj_ref.value
    }
}



//# run 0xCAFE::InteractionTest::public_create --signers 0xBADD --args 42u64



//# run 0xCAFE::InteractionTest::get_internal_value --args 0xBADD

// Script to test variable scope, shadowing and loops

//# run
script {
    // Declare a local variable to use across the script
    let outer_var: u64 = 0;

    // First scope: assign to outer_var outside loop
    outer_var = 10;

    // Local variable shadowing outer_var inside the loop
    // Move 'let outer_var' inside the loop to create shadowing
    // Shadowing is achieved by redeclaring 'outer_var' inside the loop
    for i in 0..3 {
        // Shadow outer_var inside loop
        let outer_var = i;
        // Local variable in loop
        let temp: u64 = outer_var * 2;

        // Assert inner variable scope
        assert!(outer_var <= 2, 999);
        assert!(temp == outer_var * 2, 888);
    };

    // After loop, verify outer_var unchanged (shadowing should not affect outer)
    assert!(outer_var == 10, 777);

    // Use while loop with local variables
    let count: u64 = 0;
    let sum: u64 = 0;

    while (count < 5) {
        // Shadowing within while loop
        let count_inner = count;
        count = count + 1;
        sum = sum + count;
    };

    // After loop, count variable reflects last iteration (not shadowed)
    // Note: 'count' is mutable outside; 'count_inner' is shadowed inside loop
    assert!(count == 5, 666); // count after loop should be 5
    // sum should be 1+2+3+4+5 = 15
    assert!(sum == 15, 555);

    // Local variable into scope assigned after loop
    let total: u64 = sum + outer_var;
    total
}



//# run 0xCAFE::InteractionTest::public_create --signers 0xDEED --args 100u64



//# run 0xCAFE::InteractionTest::get_internal_value --args 0xDEED



//# run 0xCAFE::InteractionTest::get_internal_value --args 0xBADD



//# run 0xCAFE::InteractionTest::internal_create --signers 0xFACE --args 55u64
// This should fail because internal_create is not public

// Additional tests for access restrictions


//# run 0xCAFE::InteractionTest::internal_create --signers 0xF00D --args 123u64
// Expected to fail compile or runtime due to internal visibility
