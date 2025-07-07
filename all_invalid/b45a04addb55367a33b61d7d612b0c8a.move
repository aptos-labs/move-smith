//# publish
address 0x1 {
module Dep {
    use std::signer;

    #[skip(vec![all])]
    resource struct R {
        value: u64,
    }

    public fun create_r(account: &signer): R {
        R { value: 0 }
    }

    public fun do(r: &mut R, v: u64) {
        // If v == 0, reset R.value to 0, else add v to it.
        if v == 0 {
            r.value = 0;
        } else {
            r.value = r.value + v;
        }
    }

    public fun runner() {
        // Create a local R resource and run do() with different values
        let mut r = R { value: 10 };
        do(&mut r, 5);
        do(&mut r, 0);
        do(&mut r, 42);
    }
}
//# run 0x1::Dep::runner

//# publish
address 0x2 {
module Main {
    use std::signer;
    use 0x1::Dep;

    #[skip(vec![unused_variable, all])]
    public fun do_local(r: &mut Dep::R, v: u64) {
        // This calls Dep::do and modifies the resource based on v.
        Dep::do(r, v);
    }

    public fun runner() {
        let mut r = Dep::R { value: 100 };
        do_local(&mut r, 20);
        do_local(&mut r, 0);
    }
}
//# run 0x2::Main::runner
}

//# run
script {
    use 0x1::Dep;
    use 0x2::Main;
    use std::signer;

    fun main(account: signer) {
        // Create a resource R in the script locally and test calls.
        let mut r = Dep::create_r(&account);
        Dep::do(&mut r, 15);
        Dep::do(&mut r, 0);
        Main::do_local(&mut r, 7);
        Main::do_local(&mut r, 0);
    }
}