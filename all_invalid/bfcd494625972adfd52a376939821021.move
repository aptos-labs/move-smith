//# publish
module 0xCAFE::TestModule {
    use std::error;
    use std::signer;

    // Property with literal values assigned
    // Assigning literal values to some pragma properties as a mock/test
    #[addr = 0x1]
    const SOME_ADDRESS: address = @0x1;

    #[flag = true]
    const SOME_FLAG: bool = true;

    #[num = 42u8]
    const SOME_NUMBER: u8 = 42;

    #[bytes = b"\x01\x02"]
    const SOME_BYTES: vector<u8> = b"\x01\x02";

    resource struct Data has store {
        _y: u64,
    }

    public fun create_data(): Data {
        Data { _y: 10 }
    }

    // Function foo will return _y and then reassign _y to 0
    public fun foo(data: &mut Data): u64 {
        let old_y = data._y;
        data._y = 0;
        old_y
    }

    // Runner function to run 'foo' and demonstrate proper behavior
    public fun run_foo(): u64 {
        let mut data = create_data();
        foo(&mut data)
    }
}
//# run 0xCAFE::TestModule::run_foo

//# publish
module 0xCAFE::ErrorHandling {
    use std::error;

    /// Simulates an error for unresolved or invalid address/name patterns
    public fun check_name_pattern(name: &vector<u8>): bool acquires error::Error {
        // For simplicity, let's simulate unresolved/invalid by checking if name contains byte 0xFF
        let mut i = 0;
        while (i < Vector::length(name)) {
            let byte = *Vector::borrow(name, i);
            if (byte == 0xFF) {
                // Simulated error trigger for invalid pattern
                abort error::invalid_argument_2_code();
            };
            i = i + 1;
        };
        true
    }

    // Runner: a function that calls with valid and invalid patterns to test error handling
    public fun runner() {
        let valid_name = b"valid_name";
        check_name_pattern(&valid_name);

        let invalid_name = b"invalid\xFF";
        // The following call will abort due to invalid name pattern
        check_name_pattern(&invalid_name);
    }
}
//# run 0xCAFE::ErrorHandling::runner

//# run
script {
    use 0xCAFE::TestModule;
    use std::debug;

    fun main() {
        let x = TestModule::run_foo();
        debug::print(&"TestModule::foo returned:");
        debug::print(&x);

        // The next run invoking ErrorHandling::runner will abort due to invalid pattern
        // We catch this implicitly as test VM would show abort.

        // We call the runner in ErrorHandling module to trigger error on invalid pattern.
        0xCAFE::ErrorHandling::runner();
    }
}