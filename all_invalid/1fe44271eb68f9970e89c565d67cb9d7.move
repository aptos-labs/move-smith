//# publish
module 0x1::TargetModule {
    use std::string;
    use std::vector;

    #[skip(lint_unused_functions, lint_shadowing)]
    struct R has key {
        v: u64,
    }

    const CONST_ONE: u8 = 1;
    const CONST_HELLO: vector<u8> = b"Hello, Aptos!\n";

    public fun new_r(value: u64): R {
        R { v: value }
    }

    // Function parsing target and dep files with address mapping simulated by args
    public fun parse_programs(
        target: &vector<u8>,
        deps: &vector<vector<u8>>,
        address_mapping: vector<(address, vector<u8>)>
    ) {
        // No real parsing logic, just simulates input usage
        let _ = target;
        let _ = deps;
        let _ = address_mapping;
    }

    /// Applies modification on R depending on v.
    public fun do(r: &mut R) {
        if (r.v % 2 == 0) {
            r.v = r.v * 2;  // Double if even
        } else {
            r.v = r.v + 1;  // Increment if odd
        }
    }

    // Calculate length of string literal with escape sequences
    public fun escape_string_length(): u64 {
        let s = b"Line1\nLine2\tTabbed\\Backslash\"Quote";
        // The expected length is the byte length of the literal including escape sequences interpreted
        vector::length(&s) as u64
    }

    /// Inline lambda test: apply a lambda function that returns input + 1
    public fun inline_lambda(v: u64): u64 {
        // Inline lambda syntax in Move is start with `move |arg| { ... }`
        let f = move |x: u64| { x + 1 };
        f(v)
    }

    /// Runner function to test do() on R
    public fun runner() {
        let mut r = new_r(3);
        do(&mut r);
        let _ = r;

        let mut r2 = new_r(4);
        do(&mut r2);
        let _ = r2;

        let _len = escape_string_length();

        let _lambda_res = inline_lambda(41);
    }
}
//# run 0x1::TargetModule::runner --signers 0x1


//# run
script {
    use 0x1::TargetModule;

    fun main() {
        // Create R with odd value 5
        let mut r = TargetModule::new_r(5);
        // Modify r by do()
        TargetModule::do(&mut r);
        // Expected: r.v == 6 (odd -> +1)

        // Create R with even value 10
        let mut r2 = TargetModule::new_r(10);
        TargetModule::do(&mut r2);
        // Expected: r2.v == 20 (even -> *2)

        // Test escape_string_length returns expected length
        let len = TargetModule::escape_string_length();
        // Just forcing call to VM execution, no assertions

        // Test inline_lambda
        let val = TargetModule::inline_lambda(100);
        // Expected val == 101

        // Simulate parsing programs (dummy params)
        let target = b"target.program.bytes";
        let deps = vector::empty<vector<u8>>();
        let mapping = vector::empty<(address, vector<u8>)>();
        TargetModule::parse_programs(&target, &deps, mapping);
    }
}