
//# publish
module 0xCAFE::ReentrancyTest {
    use std::signer;
    use std::error;
    use std::vector;

    // Simulate a lock by using a resource that enforces exclusive access
    struct LockedResource has key {
        lock_flag: bool,
        data: u64,
    }

    // Assign a custom attribute to simulate // module_lock]
    // (In actual Move, custom attributes are not supported, so we simulate behavior via code comments or naming conventions)
    // For testing, assume this function is treated as // module_lock]
    public fun locked_function(res: &mut LockedResource): u64 acquires LockedResource {
        // Attempt to acquire lock
        if (res.lock_flag) {
            error::abort_code(1);
        }
        res.lock_flag = true;
        // Reentrant call to the same function (should cause an error)
        // For testing, simulate reentrancy attempt
        // This should trigger a lock conflict if reentrant mutable access is attempted
        let result = try_reentrant_call(res);
        res.lock_flag = false;
        result
    }

    // Helper function to simulate reentrant call
    public fun try_reentrant_call(res: &mut LockedResource): u64 {
        // Reentrant mutable access (should cause compile/verification error)
        // For testing, we simulate by attempting to call the same function again
        // This is expected to fail verification if [module_lock] enforces no reentrant mutable access
        locked_function(res)
    }

    // Define constants with attribute simulation and signature declaration
    // In actual Move, attributes are not available, but we simulate via naming/comments
    const // attribute_name("CONST_ONE")] CONST_ONE: u8 = 42;
    const // attribute_name("CONST_TWO")] CONST_TWO: u64 = 1000;

    // Use alias via `use` statement
    use std::vector as VecAlias;

    // Define a resource and access it directly by name
    struct MemberResource has key {
        member_value: u64,
    }

    public fun create_member(addr: &signer): MemberResource {
        move_to<MemberResource>(addr, MemberResource {member_value: 12345})
    }

    public fun access_member(addr: &signer): u64 {
        borrow_global<MemberResource>(signer::address_of(addr)).member_value
    }
}


//# run 0xCAFE::ReentrancyTest::locked_function --signers 0xBADD --args

//# run 0xCAFE::ReentrancyTest::create_member --signers 0xBADD

//# run 0xCAFE::ReentrancyTest::access_member --signers 0xBADD

// Featurres:
// 2947518c868e0787a5133650e7562527: Test that a function marked with #[module_lock] correctly blocks reentrant mutable access to the same resource within a callback, causing an error even when such reentrancy would be allowed under a regular lock.
// 450f5473644abac25d250627fc5d9d9a: Define constants with attributes and signatures
// 4524c941e71dd068b5bd278c754d71f7: Refer to a member (resource or function) directly by name within the current module or via an alias.
