//# publish
module 0xCAFE::LoopModule {
    // A simple counter stored in a resource
    struct Counter has store {
        count: u64,
    }

    public fun init(account: &signer) {
        let counter = Counter { count: 0 };
        move_to(account, counter);
    }

    // Use a while loop to increase the counter until it reaches limit
    public fun while_increment(account: &signer, limit: u64) {
        let counter = borrow_global_mut<Counter>(Signer::address_of(account));
        let mut i = 0;

        // while loop syntax in Move
        while (i < limit) {
            counter.count = counter.count + 1;
            i = i + 1;
        }
    }

    // Use an infinite loop and break to increment counter a certain count
    public fun loop_increment(account: &signer, limit: u64) {
        let counter = borrow_global_mut<Counter>(Signer::address_of(account));
        let mut i = 0;

        loop {
            counter.count = counter.count + 1;
            i = i + 1;
            if (i >= limit) {
                break;
            }
        }
    }

    // Runner function for testing that does each increment once with argument 5u64
    public fun runner(account: &signer) {
        init(account);
        while_increment(account, 5);
        loop_increment(account, 5);
    }
}
//# run 0xCAFE::LoopModule::runner --signers 0xCAFE

//# publish
module 0xCAFE::WrapperModule {
    use 0xCAFE::LoopModule;

    public fun init_and_run(account: &signer) {
        // Call LoopModule.runner to execute loops fully
        LoopModule::runner(account);
    }
}
//# run 0xCAFE::WrapperModule::init_and_run --signers 0xCAFE

//# run
script {
    use 0xCAFE::LoopModule;

    fun main(account: signer) {
        LoopModule::init(&account);
        LoopModule::while_increment(&account, 3);
        LoopModule::loop_increment(&account, 2);
    }
}

//# run
script {
    use 0xCAFE::WrapperModule;

    fun main(account: signer) {
        WrapperModule::init_and_run(&account);
    }
}

// Featurres:
// e68ecc42ec10b5f6d3edc1a25f9c727b: Support both regular modules and special script modules as Move targets.
// 0081d31df4108b9705ff56d6cf74e407: Arrange modules and scripts in dependency order for compilation.
// e646d5fb8be97e12c12b06b3ae8d7555: Write `while` and `loop` loop constructs.
