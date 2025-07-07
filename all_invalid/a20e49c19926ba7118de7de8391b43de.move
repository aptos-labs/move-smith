// Test all features as described

// ====================================
//# publish
module 0x1::DecreasesAndSpecDemo {
    // A struct with a field and a specification block
    struct Counter has key {
        value: u64,
    }
    spec Counter {
        // Spec block attached directly to struct
        invariant old(self.value) <= self.value;
    }

    public fun new_counter(val: u64, account: &signer): Counter {
        move_to(account, Counter { value: val });
        Counter { value: val }
    }

    /// Decrement the counter recursively, with decreases expression
    public fun dec(mut cnt: &mut Counter, n: u64) acquires Counter {
        spec {
            decreases [n]; // measure for termination
            // Spec for function
            ensures cnt.value == old(cnt.value) - n;
        }
        if (n == 0) {
            return;
        }
        borrow_global_mut<Counter>(@0x1).value = cnt.value - 1;
        dec(cnt, n - 1);
    }

    /// A runner function for test purposes
    public fun run_dec(account: &signer) {
        let mut c = Counter { value: 5 };
        dec(&mut c, 3);
        // The counter should be decremented by 3 (from 5 to 2)
    }

    // Spec block attached directly to function
    spec run_dec {
        ensures true; // just to test spec attachment
    }
}

//# run 0x1::DecreasesAndSpecDemo::run_dec --signers 0x1

// ====================================
//# publish
address 0x2 {
module RefTest {
    resource struct Nested has key {
        i: u64,
        v: vector<u8>,
    }

    /// Borrowing and mutating nested fields, with spec directly on function
    public fun mutate_nested(idx: u8, account: &signer) {
        let mut n = Nested { i: 10, v: vector [1,2,3,4] };
        let r = &mut n;
        let ref_i = &mut r.i;
        *ref_i = *ref_i + 5;

        let ref_vec = &mut r.v;
        // test borrowing via alias and mutating element
        let el = &mut ref_vec[idx];
        *el = *el + 1;
        // update back to storage just for exercise
        move_to(account, n);
    }

    /// Borrows an item conditionally, returns it, tests move borrow/mut alias
    public fun cond_ref_update(condition: bool, account: &signer) {
        let mut n = Nested { i: 7, v: vector [11,13,17] };
        let r = &mut n;

        let ref_val = if (condition) {
            &mut r.i
        } else {
            let ref_vec = &mut r.v;
            &mut ref_vec[1]
        };
        *ref_val = *ref_val + 20;
        move_to(account, n);
    }

    spec mutate_nested {
        // Just a sample spec block attached directly
        ensures true;
    }

    spec cond_ref_update {
        // Sample spec to test spec attachment and mutable ref handling in formal mode
        ensures true;
    }

    public fun runner(account: &signer) {
        mutate_nested(2u8, account);
        cond_ref_update(true, account);
        cond_ref_update(false, account);
    }
}
}
//# run 0x2::RefTest::runner --signers 0x2

// ====================================
//# run
script {
    use 0x1::DecreasesAndSpecDemo;

    fun main(account: &signer) {
        DecreasesAndSpecDemo::run_dec(account);
    }
}

//# run
script {
    use 0x2::RefTest;

    fun main(account: &signer) {
        RefTest::mutate_nested(0u8, account);
        RefTest::cond_ref_update(true, account);
        RefTest::cond_ref_update(false, account);
    }
}