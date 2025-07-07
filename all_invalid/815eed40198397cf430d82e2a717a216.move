//# publish
module 0x1::Dep {
    use std::signer;

    #[skip(verifier::dependent_move_resource)]
    resource struct R has key {
        v: u64,
    }

    public fun create_r(account: &signer, initial: u64): R {
        R { v: initial }
    }
}

//# publish
module 0x1::Main {
    use std::signer;
    use 0x1::Dep;

    #[skip(lint_example,verifier::dependent_move_resource)]
    resource struct R has key {
        val: u64,
    }

    public fun create_r(account: &signer, initial: u64): R {
        R { val: initial }
    }

    public fun do(s: &signer, r: &mut Dep::R) {
        let current = r.v;
        if (current % 2 == 0) {
            r.v = current + 1;
        } else {
            r.v = current * 2;
        }
    }

    public fun runner(account: &signer) {
        let mut r = Dep::create_r(account, 10);
        do(account, &mut r);
        // modify again
        do(account, &mut r);
        // no return needed
    }
}

//# run 0x1::Main::runner --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::Dep;
    use 0x1::Main;

    fun main(account: signer) {
        // create resource R in Dep with initial value 3 (odd)
        let mut r = Dep::create_r(&account, 3);
        // call do once -- should apply the odd branch: v = 3 * 2 = 6
        Main::do(&account, &mut r);
        // call do again -- now v = 6 (even), so v = 6 + 1 = 7
        Main::do(&account, &mut r);
    }
}