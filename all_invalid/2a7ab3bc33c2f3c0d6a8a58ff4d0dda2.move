//# publish
module 0xCAFE::BacktraceControl {
    use std::debug;
    use std::signer;

    /// Stores whether backtrace is enabled or not.
    struct BacktraceFlag has key {
        enabled: bool,
    }

    public fun init(account: &signer) {
        move_to(account, BacktraceFlag { enabled: false });
    }

    public fun enable_backtrace(account: &signer) {
        let flag = borrow_global_mut<BacktraceFlag>(signer::address_of(account));
        flag.enabled = true;
    }

    public fun disable_backtrace(account: &signer) {
        let flag = borrow_global_mut<BacktraceFlag>(signer::address_of(account));
        flag.enabled = false;
    }

    public fun is_backtrace_enabled(addr: address): bool acquires BacktraceFlag {
        borrow_global<BacktraceFlag>(addr).enabled
    }

    /// This function triggers a panic to test backtrace behavior.
    public fun trigger_panic() {
        debug::abort(42);
    }

    /// A "runner" function to test enabling backtrace.
    public fun runner_enable(account: &signer) {
        init(account);
        enable_backtrace(account);
        assert!(is_backtrace_enabled(signer::address_of(account)), 1);
    }

    /// A "runner" function to test disabling backtrace.
    public fun runner_disable(account: &signer) {
        init(account);
        enable_backtrace(account);
        disable_backtrace(account);
        assert!(!is_backtrace_enabled(signer::address_of(account)), 1);
    }
}
//# run 0xCAFE::BacktraceControl::runner_enable --signers 0xCAFE
//# run 0xCAFE::BacktraceControl::runner_disable --signers 0xCAFE


//# publish
module 0xCAFE::FunctionVariety {
    use std::string;

    public fun no_params(): u64 {
        7
    }

    public fun with_params(a: u8, b: u16, c: u32): u64 {
        // Compute some value combining all parameters
        (a as u64) + (b as u64) * 10 + (c as u64) * 100
    }

    public fun many_params(a: u8, b: u8, c: u8, d: u8, e: u8, f: u8, g: u8, h: u8): u64 {
        // Sum all parameters multiplied by their position (1-indexed)
        let mut sum = 0u64;
        sum = sum + (a as u64) * 1;
        sum = sum + (b as u64) * 2;
        sum = sum + (c as u64) * 3;
        sum = sum + (d as u64) * 4;
        sum = sum + (e as u64) * 5;
        sum = sum + (f as u64) * 6;
        sum = sum + (g as u64) * 7;
        sum = sum + (h as u64) * 8;
        sum
    }

    public fun call_patterns(): (u64, u64, u64) {
        let np = no_params();
        let wp = with_params(1, 2, 3);
        let mp = many_params(1,1,1,1,1,1,1,1);
        (np, wp, mp)
    }

    /// Runner function to execute and verify function behaviors
    public fun runner(): bool {
        let no_p = no_params();
        let with_p = with_params(1, 2, 3);
        let many_p = many_params(1, 2, 3, 4, 5, 6, 7, 8);
        let (cp_np, cp_wp, cp_mp) = call_patterns();

        // check no_params() returns 7
        assert!(no_p == 7, 1);
        // check with_params(1,2,3) = 1 + 20 + 300 = 321
        assert!(with_p == 321, 2);
        // many_params(1..8) sum: 1*1+2*2+3*3+4*4+5*5+6*6+7*7+8*8
        // = 1+4+9+16+25+36+49+64 = 204
        assert!(many_p == 204, 3);
        // call_patterns returns (7, 321, 8*1=8*1?? wait call_patterns uses all ones for many_params)
        // call_patterns many_params(1,1,1,1,1,1,1,1):
        // sum = 1*1+1*2+1*3+1*4+1*5+1*6+1*7+1*8=36
        assert!(cp_np == 7, 4);
        assert!(cp_wp == 321, 5);
        assert!(cp_mp == 36, 6);

        true
    }
}
//# run 0xCAFE::FunctionVariety::runner


//# publish
module 0xCAFE::FriendModulesA {
    friend 0xCAFE::FriendModulesB;

    struct Secret has key {
        data: u64,
    }

    public fun new_secret(): Secret {
        Secret { data: 12345 }
    }

    public fun get_secret(secret: &Secret): u64 {
        secret.data
    }
}

//# publish
module 0xCAFE::FriendModulesB {
    use 0xCAFE::FriendModulesA;

    public fun access_secret(): u64 {
        let secret = FriendModulesA::new_secret();
        // FriendModulesB is friend of FriendModulesA, so it can access private fields
        FriendModulesA::get_secret(&secret)
    }
}

//# run 0xCAFE::FriendModulesB::access_secret

// Featurres:
// c0b463c645a069228809bdbae2525b35: Enable or disable move compiler backtraces by setting specific environment variables.
// 4adf157cea6759d562aa3cd24a34a045: Test that the Move module correctly handles functions with varying parameters and call patterns by verifying their execution and return values across different scenarios.
// 7674c49fd390a223ca5ce8af7ec49511: Declare friend modules or declarations for access control.
