//# publish
module 0x1::Dependency {
    use std::signer;

    #[skip(lint_name_1, lint_name_2)]
    struct R has key {
        val: u64,
    }

    // Create a new R resource with val = 0
    public fun create_r(account: &signer) {
        move_to(account, R { val: 0 });
    }

    // Get reference to R resource
    public fun borrow_r(account: &signer): &R {
        borrow_global<R>(signer::address_of(account))
    }

    // Mutable reference to R
    public fun borrow_r_mut(account: &signer): &mut R {
        borrow_global_mut<R>(signer::address_of(account))
    }
}

//# publish
module 0x1::Target {
    use std::signer;
    use 0x1::Dependency;

    #[skip(lint_skip_1)]
    struct Container has key {
        inner: Dependency::R,
    }

    public fun create_container(account: &signer) {
        // create an R resource under account first
        Dependency::create_r(account);
        // move R into Container
        let r = move_from<Dependency::R>(signer::address_of(account));
        move_to(account, Container { inner: r });
    }

    /// do() function modifies inner.val according to v
    public fun do(account: &signer, v: u64) {
        let container = borrow_global_mut<Container>(signer::address_of(account));
        if (v % 2 == 0) {
            // even: add v to val
            let val_ref: &mut u64 = &mut container.inner.val;
            *val_ref = *val_ref + v;
        } else {
            // odd: subtract v from val if possible
            let val_ref: &mut u64 = &mut container.inner.val;
            if (*val_ref >= v) {
                *val_ref = *val_ref - v;
            }
        }
    }

    // Runner function without args or signers, just creates container and calls do() internally
    public fun runner(account: &signer) {
        create_container(account);
        do(account, 10); // even number add 10
        do(account, 3);  // odd number subtract 3 if possible
    }
}
//# run 0x1::Target::runner --signers 0x1

//# run
script {
    use 0x1::Dependency;
    use 0x1::Target;
    use std::signer;

    fun main(account: signer) {
        // test creating R resource directly
        Dependency::create_r(&account);
        let r_ref: &Dependency::R = Dependency::borrow_r(&account);
        // just simulate using r_ref to test reference to resource
        let _ = r_ref.val;

        // create Container from Target module and run do() with various values
        Target::create_container(&account);
        Target::do(&account, 42u64);
        Target::do(&account, 11u64);

        // finally call runner to run combined logic
        Target::runner(&account);
    }
}