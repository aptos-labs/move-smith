//# publish
module 0x1::FriendModule {
    use std::signer;
    use std::debug;

    // Expose a function only accessible by friend module
    friend 0x2::CallerModule;

    public(friend 0x2::CallerModule) fun privileged_function(): u64 {
        42
    }

    // A runner function to test privileged access and debug logging
    public fun runner_debug_log() {
        // Enable debug logging - (in Aptos Move this is automatic if debug is enabled on VM)
        debug::print(&"Debug log: starting runner_debug_log");

        // Name for bytecode dump derived from source file name (simulated here)
        debug::print(&"Bytecode dump name: friend_module.move");

        // Just some debug info
        let val = Self::internal_helper();
        debug::print(&"Returned from internal_helper");
    }

    fun internal_helper(): u64 {
        100
    }
}
//# run 0x1::FriendModule::runner_debug_log

//# publish
module 0x2::CallerModule {
    use std::signer;
    use std::debug;
    use 0x1::FriendModule;

    /// A function that calls the friend-only function from 0x1::FriendModule
    public fun call_friend_function(): u64 acquires FriendModule {
        let val = FriendModule::privileged_function();
        debug::print(&"call_friend_function called privileged_function");
        val
    }

    // Runner to exercise call to friend function with signer 0x2 required
    public fun runner_call() {
        let ret = Self::call_friend_function();
        debug::print(&"runner_call completed, returned value:");
        debug::print(&ret);
    }
}
//# run 0x2::CallerModule::runner_call --signers 0x2

//# run
script {
    use 0x2::CallerModule;
    use std::debug;

    fun main() {
        debug::print(&"Running script main");
        let result = CallerModule::call_friend_function();
        debug::print(&"Script main got result:");
        debug::print(&result);
    }
}