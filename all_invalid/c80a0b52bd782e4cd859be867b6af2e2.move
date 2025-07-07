//# publish
module 0xA550C18::RModule {
    use std::signer;

    #[skip(lint_condition_deprecated, lint_unused_variable)]
    resource struct R {
        value: u64,
    }

    public fun create_r(account: &signer, v: u64): R {
        R { value: v }
    }

    public fun do(r: &mut R) {
        // If value is even, increment it, otherwise decrement it
        if (r.value % 2 == 0) {
            r.value = r.value + 1;
        } else {
            r.value = r.value - 1;
        }
    }

    /// A runner function that creates R with 10, runs do(), returns the final value
    public fun runner(): u64 {
        let mut r = create_r(&signer::spec_address(), 10);
        do(&mut r);
        r.value
    }
}
//# run 0xA550C18::RModule::runner

//# publish
module 0xA550C18::ProgramParser {
    use std::vector;
    use std::string;
    use std::option;

    #[skip(lint_unused_imports)]
    struct MoveProgram has copy, drop, store {
        name: string::String,
        target_code: vector<u8>,
        dependencies: vector<vector<u8>>,
        address_map_keys: vector<string::String>,
        address_map_values: vector<u8>,
    }

    public fun parse_program(
        target: vector<u8>,
        dependencies: vector<vector<u8>>,
        addrs_keys: vector<string::String>,
        addrs_values: vector<u8>
    ): MoveProgram {
        MoveProgram {
            name: string::utf8(b"TestProgram"),
            target_code: target,
            dependencies,
            address_map_keys: addrs_keys,
            address_map_values: addrs_values,
        }
    }

    // A runner function that just parses a dummy program with dummy deps and addr map
    public fun runner() {
        let target = vector::empty<u8>();
        let deps = vector::empty<vector<u8>>();
        let keys = vector::empty<string::String>();
        let values = vector::empty<u8>();
        let _program = parse_program(target, deps, keys, values);
    }
}
//# run 0xA550C18::ProgramParser::runner

//# run
script {
    use 0xA550C18::RModule;

    fun main() {
        // Create an R resource with value 5
        let mut r = RModule::create_r(&signer::spec_address(), 5);
        // call do() to test interaction with R and verify no errors in VM
        RModule::do(&mut r);
    }
}