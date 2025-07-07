//# publish
module 0xabc::nested_rename {
    public fun compute_sum(): u64 {
        let a = 5;
        let b = 10;

        // Rename 'a' and 'b', reassign 'a' inside nested expression
        let (a_rename, b_rename) = (a, b);
        let a = a_rename + 2;
        let b = b_rename + 3;

        // Reassign 'b' again after nested expressions
        let b = b + a;

        // Use the renamed variables in further computations
        a + b
    }

    public fun run_test() {
        Self::compute_sum()
    }
}

//# run 0xabc::nested_rename::run_test

//# publish
module 0xabc::swap_and_verify {
    public fun swap(x: u64, y: u64): (u64, u64) {
        let temp = x;
        let x = y;
        let y = temp;
        (x, y)
    }

    public fun verify_swap() {
        let (a, b) = swap(42, 99);
        // Assertions (ignored in test, focus on function correctness)
        assert!(a == 99, 0);
        assert!(b == 42, 1);
    }

    public fun run() {
        Self::verify_swap()
    }
}

//# run 0xabc::swap_and_verify::run

//# publish
module 0xabc::token_value_management {
    use 0x42::objects;
    use 0x42::token;

    struct TempToken has key {
        val: u64
    }

    public fun create_token(s: &signer, owner: &objects::OwnerRef, initial_value: u64): token::Token {
        token::create(s, owner, initial_value)
    }

    public fun update_value_with_reader(owner: &objects::OwnerRef, new_val: u64) {
        let rr = token::reader_ref(owner);
        let val_ref = &mut token::borrow_global_mut<Token>(objects::reader_addr_of(&rr));
        val_ref.val = new_val;
    }

    public fun verify_value(owner: &objects::OwnerRef, expected: u64) {
        let rr = token::reader_ref(owner);
        let actual = token::get_value(&rr);
        assert!(actual == expected, 0);
    }

    public fun run() {
        let owner = objects::make_owner_ref(@0xabc);
        create_token(&0xabc, &owner, 50);
        verify_value(&owner, 50);
        update_value_with_reader(&owner, 75);
        verify_value(&owner, 75);
    }
}

//# run 0xabc::token_value_management::run