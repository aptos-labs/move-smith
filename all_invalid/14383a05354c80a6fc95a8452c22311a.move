
//# publish
module 0xCAFE::TestExpectedFailure {
    use std::signer;

    struct R has key {
        val: u8,
    }

    // Function that aborts with code 777 deliberately
    // expected_failure(abort_code = 777)]
    public fun abort_somewhere() {
        abort 777;
    }

    // Function that aborts with code 888 deliberately
    // expected_failure(abort_code = 888)]
    public fun abort_with_expr() {
        let x = 888u64;
        abort x;
    }

    // Assignment expression test: assign to a local variable
    public fun assignment_local() {
        let x = 1u8;
        let y = 2u8;
        let a = x + y;
        let b = a;
        b = b + 1;
        // b is last expression to return
        b
    }

    // Assignment test with resource field and declared struct
    struct StructResource has key {
        val: u64,
    }

    public fun create_resource(s: signer, v: u64) {
        let r = StructResource { val: v };
        move_to<StructResource>(&s, r);
    }

    public fun update_resource(s: signer, new_val: u64) {
        let r_mut_ref = borrow_global_mut<StructResource>(signer::address_of(&s));
        r_mut_ref.val = new_val;
    }

    public fun read_resource(s: signer): u64 {
        let r_ref = borrow_global<StructResource>(signer::address_of(&s));
        r_ref.val
    }

    // Test assigning resource field after borrowing
    public fun assignment_resource_field(s: signer) {
        let r_mut_ref = borrow_global_mut<StructResource>(signer::address_of(&s));
        r_mut_ref.val = 42u64;
    }
}


//# run 0xCAFE::TestExpectedFailure::abort_somewhere


//# run 0xCAFE::TestExpectedFailure::abort_with_expr


//# run 0xCAFE::TestExpectedFailure::assignment_local


//# run 0xCAFE::TestExpectedFailure::create_resource --signers 0xF00D --args 10u64


//# run 0xCAFE::TestExpectedFailure::read_resource --signers 0xF00D


//# run 0xCAFE::TestExpectedFailure::update_resource --signers 0xF00D --args 100u64


//# run 0xCAFE::TestExpectedFailure::read_resource --signers 0xF00D


//# run 0xCAFE::TestExpectedFailure::assignment_resource_field --signers 0xF00D


// Featurres:
// b2d74da62124bc08a6dc7513a04ad40c: Use the `#[expected_failure(...)]` attribute to specify expected errors or abort codes in your tests.
// c2690b9c0a9fa1771bbd371be5f3e8e0: Create assignment expressions with left-value and right-value.
// 6ab8797b66a06348f368b697382c1c80: Declare resources as 'resource struct StructName' instead of 'resource StructName'.
