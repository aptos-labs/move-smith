//# publish
module 0x1::RModule {
    use std::signer;

    struct R has key, store {
        value: u64,
    }

    public fun create_r(account: &signer, init_value: u64): R {
        R { value: init_value }
    }

    public fun modify_r(r: &mut R, delta: u64) {
        r.value = r.value + delta;
    }

    public fun read_r(r: &R): u64 {
        r.value
    }
}

//# publish
module 0x1::TestModule {
    use std::signer;
    use 0x1::RModule;

    #[skip(lint_arithmetic, lint_unused)]
    struct Container has key {
        r: RModule::R,
    }

    public fun create_container(account: &signer, init_val: u64): Container {
        let r = RModule::create_r(account, init_val);
        Container { r }
    }

    public fun do(c: &mut Container, v: u64) {
        if (v % 2 == 0) {
            RModule::modify_r(&mut c.r, v);
        } else {
            // Just read, no modification.
            let _ = RModule::read_r(&c.r);
        }
    }

    public fun runner(account: &signer) {
        let mut cont = create_container(account, 10);
        // Perform with even v, should modify
        do(&mut cont, 4);
        // Perform with odd v, should only read
        do(&mut cont, 3);
    }
}

//# run 0x1::TestModule::runner --signers 0x1

//# run
script {
    use 0x1::TestModule;

    fun main(account: &signer) {
        // Setup a container
        TestModule::runner(account);
    }
}

//# publish
module 0x1::EnvLogger {
    use std::string;
    use std::option;

    #[skip(lint_unused)]
    struct Logger has store {
        filename: string::String,
    }

    public fun create_logger_from_env(): Logger acquires std::address {
        // In Move we can't really read env variables,
        // simulate by a hardcoded string as if read from env
        // (In real environment the framework would inject this)
        let filename = string::utf8(b"transaction_log.txt");
        Logger { filename }
    }

    public fun log_message(logger: &Logger, msg: &string::String) {
        // Here we just simulate logging by no-op, 
        // since Move has no file I/O in VM
        let _ = &logger.filename;
        let _ = msg;
    }

    public fun test_logger() {
        let logger = create_logger_from_env();
        let msg = string::utf8(b"Test log message");
        log_message(&logger, &msg);
    }
}

//# run 0x1::EnvLogger::test_logger