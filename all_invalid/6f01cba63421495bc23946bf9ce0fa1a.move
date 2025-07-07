//# publish
module 0x1::UnaryOpsTest {
    use std::signer;
    use std::debug;

    // A function demonstrating unary operators
    public fun run_unary_ops() {
        let x: i64 = 5;
        let y: bool = false;
        // Apply unary minus
        let nx = -x;
        // Apply unary not
        let ny = !y;
        debug::print(&("unary minus of 5: ", nx));
        debug::print(&("unary not of false: ", ny));
    }
}
//# run 0x1::UnaryOpsTest::run_unary_ops

//# publish
module 0x1::MultipleEntriesTest {
    use std::debug;

    // Configuration storing an integer value
    struct Config has key {
        value: u64,
    }

    public fun set_config(account: &signer, val: u64) {
        if (exists<Config>(signer::address_of(account))) {
            // Overwrite existing config
            move_from<Config>(signer::address_of(account));
        }
        move_to(account, Config { value: val });
    }

    public fun get_config(addr: address): u64 acquires Config {
        borrow_global<Config>(addr).value
    }

    // Runner to demonstrate override: set, override, and read config
    public fun run_override(account: &signer) {
        set_config(account, 10);
        // Override previous setting
        set_config(account, 20);
        let val = get_config(signer::address_of(account));
        debug::print(&("Final config value (should be 20): ", val));
    }
}
//# run 0x1::MultipleEntriesTest::run_override --signers 0x1

//# publish
module 0x1::WarningsTest {
    use std::debug;

    // This function declares an unused variable to cause a warning
    public fun unused_var_warning() {
        let unused: u64 = 100;
        debug::print(&("Testing warning on unused var",));
    }

    // This function defines unreachable code to cause a warning
    public fun unreachable_code_warning() {
        return;
        // unreachable code below, should trigger a warning
        let x = 5;
        debug::print(&("This line is unreachable",));
    }

    // Runner to call both warning-generating functions
    public fun run_warnings() {
        unused_var_warning();
        unreachable_code_warning();
    }
}
//# run 0x1::WarningsTest::run_warnings