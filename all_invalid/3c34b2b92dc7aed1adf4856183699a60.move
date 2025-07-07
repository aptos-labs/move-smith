//# publish
module 0x1::FriendModule {
    use std::signer;
    use std::debug;

    /// A friend module which exposes a privileged function
    friend 0x1::MainModule;

    /// Privileged function only callable by friend MainModule
    public fun privileged_function(caller: &signer) {
        let caller_addr = signer::address_of(caller);
        debug::print(&debug::raw_encode(&caller_addr));
    }
}

//# publish
module 0x1::MainModule {
    use std::signer;
    use std::debug;
    use 0x1::FriendModule;

    /// A runner function to exercise caller and debug logging as well as friend call
    public fun runner(caller: &signer) {
        // Print debug bytecode dump name derived from source file (simulate)
        let source_name = b"MainModule.move";
        let dump_name = debug::concat(source_name, b".bytecode");
        debug::print(&dump_name);
        FriendModule::privileged_function(caller);
    }
}

//# run 0x1::MainModule::runner --signers 0x1
script {
    use std::debug;
    use std::signer;
    use 0x1::MainModule;

    /// Transactional test driver with #[test] attribute for parameter binding
    #[test(signer(0x1))]
    fun test_run(s: signer) {
        debug::print(b"Running MainModule::runner test");
        MainModule::runner(&s);
    }
}