//# publish
module 0xabc::conditional_reassignment {
    fun consume(val: u64) {
        val;
    }

    //# run
    fun test_conditional(a: u64, condition: bool) {
        let b = move a;
        if (condition) {
            consume(b);
        } else {
            a = 100;
            let c = b;
            c = c + 10;
        }
    }

    public fun run_tests() {
        test_conditional(55, true);
        test_conditional(55, false);
    }
}

//# run 0xabc::conditional_reassignment::run_tests

//# publish
module 0xabc::loop_variable_test {
    #[error_codes]
    public fun main() {
        // loop variable reassignment attempt - should cause validation error if uncommented
        // for (i in 0..5) {
        //     i = 10; // Invalid reassignment, but here for illustrative purposes
        //     break;
        // };

        // Correct loop
        let mut sum = 0;
        for (i in 0..3) {
            sum = sum + i;
        }
        // Further logic or assertions could be here
    }
}

//# run 0xabc::loop_variable_test::main

//# publish
module 0xabc::resource_storage {
    use 0x1::signer;

    struct ConfigResource has store, key {
        counter: u64,
        message: vector<u8>,
    }

    #[persistent]
    fun default_config(): ConfigResource {
        ConfigResource {
            counter: 0,
            message: b"initial".to_vec(),
        }
    }

    entry fun initialize(s: &signer) {
        move_to(s, default_config());
    }

    entry fun update_counter(s: &signer, inc: u64) acquires ConfigResource {
        let config = move_from<ConfigResource>(signer::address_of(s));
        let new_counter = config.counter + inc;
        move_to(s, ConfigResource {
            counter: new_counter,
            message: config.message,
        });
    }

    entry fun get_counter(s: &signer): u64 acquires ConfigResource {
        let config = borrow_global<ConfigResource>(signer::address_of(s));
        config.counter
    }
}

//# run 0xabc::resource_storage::initialize --signers 0xabc

//# run 0xabc::resource_storage::update_counter --signers 0xabc --args 5

//# run 0xabc::resource_storage::get_counter --signers 0xabc