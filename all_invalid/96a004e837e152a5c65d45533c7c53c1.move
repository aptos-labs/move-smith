//# publish
module 0xDEAD::TestAdvancedFeatures {
    use std::signer;
    use std::vector;

    // Function that takes 66 u8 arguments and returns their sum
    public fun takes_66_args(args: vector<u8>): u8 {
        let sum: u8 = 0;
        let length = vector::length(&args);
        let index = 0;
        while (index < length) {
            let value = *vector::borrow(&args, index);
            sum = sum + value;
            index = index + 1;
        };
        sum
    }

    // Function that aborts a specified number of times before success
    public fun abort_then_succeed(abort_times: u64, counter: u64): u64 {
        if (abort_times > 0) {
            abort(999);
        } else {
            counter + 1
        }
    }

    // Function to test conditional aborts
    public fun test_conditional_abort(flag: bool): u64 {
        if (flag) {
            abort(555);
        } else {
            42
        }
    }

    // Function to filter modules based on a simple condition (simulate address check)
    public fun filter_modules(modules: vector<address>): vector<address> {
        let result = vector::empty<address>();
        let len = vector::length(&modules);
        let i = 0;
        while (i < len) {
            let addr = *vector::borrow(&modules, i);
            // Example condition: include only addresses that are even when interpreted as u64
            let addr_value = signer::address_to_u64(addr);
            if (addr_value % 2 == 0) {
                vector::push_back(&mut result, addr);
            };
            i = i + 1;
        };
        result
    }

    // Static analysis check: dummy bytecode validation (simulate)
    public fun static_bytecode_check(): bool {
        // In real scenario, would invoke bytecode verifier
        true
    }

    // Functions to test first-class function handling
    public fun assign_and_invoke_function() {
        let func_var: fn(u8) -> u8 = call(0xDEAD::TestAdvancedFeatures::increment);
        let result = func_var(10);
        result
    }

    public fun call_generic_function<T: copy + drop + std::ops::Add<Output = T> + From<u8>>(f: fn(T) -> T, arg: T): T {
        f(arg)
    }

    // A sample generic function
    public fun generic_increment<T: copy + drop + std::ops::Add<Output = T> + From<u8>>(arg: T): T {
        arg + T::from(1u8)
    }

    // Entry points (scripts) to facilitate testing from outside
    public fun run_takes_66_args(): u8 {
        let args_vec = vector::empty<u8>();
        let total_args = 66;
        let i = 0;
        while (i < total_args) {
            vector::push_back(&mut args_vec, 1u8);
            i = i + 1;
        };
        takes_66_args(args_vec)
    }

    public fun run_abort_then_succeed(abort_times: u64, start_counter: u64): u64 {
        abort_then_succeed(abort_times, start_counter)
    }

    public fun run_conditional_abort(flag: bool): u64 {
        test_conditional_abort(flag)
    }

    public fun run_module_filter(addresses: vector<address>): vector<address> {
        filter_modules(addresses)
    }

    public fun run_static_check(): bool {
        static_bytecode_check()
    }

    public fun run_assign_invoke(): u8 {
        assign_and_invoke_function()
    }

    pub fun run_generic_invoke(arg: u8): u8 {
        call_generic_function(generic_increment, arg)
    }
}



//# run 0xDEAD::TestAdvancedFeatures::run_takes_66_args


//# run 0xDEAD::TestAdvancedFeatures::run_abort_then_succeed --args 3u64 0u64


//# run 0xDEAD::TestAdvancedFeatures::run_conditional_abort --args false


//# run 0xDEAD::TestAdvancedFeatures::run_conditional_abort --args true


//# run 0xDEAD::TestAdvancedFeatures::run_module_filter --args [@0x1, @0x2, @0x3, @0x4]


//# run 0xDEAD::TestAdvancedFeatures::run_static_check


//# run 0xDEAD::TestAdvancedFeatures::run_assign_invoke


//# run 0xDEAD::TestAdvancedFeatures::run_generic_invoke --args 10u8
