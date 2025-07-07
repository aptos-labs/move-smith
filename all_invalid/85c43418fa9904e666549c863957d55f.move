// Transactional test for Move compiler and VM
// Tests:
// 1. Script early return prevents assertion
// 2. Specification functions (fun & native)
// 3. Use of current_token_loc for source location introspection

//# publish
module 0x1::SpecFunTest {
    // Specification function implemented in Move
    spec fun spec_sum(x: u64, y: u64): u64 {
        x + y
    }

    // A native specification function declaration
    spec native fun native_spec_f(x: u64): u64;

    // Entry function to allow function call in test
    public fun runner() {
        // Use the specification function (only available to specs, but here for test syntax)
        let _x = 2u64;
        let _y = 3u64;
        // Spec functions cannot be called in bytecode, so just to exercise parser:
        //let _sum = spec_sum(_x, _y);
        //let _nat = native_spec_f(_y);
        // Function body for completeness
        1+1;
    }
}

//# run 0x1::SpecFunTest::runner --signers 0x1

//# publish
module 0x2::TokenLocTest {
    use std::token::current_token_loc;
    use std::token::{TokenLoc};

    // Stores a TokenLoc in a resource for test
    resource struct LocData { loc: TokenLoc }

    public fun store_location(s: &signer) {
        // Get the location of this usage
        let loc = current_token_loc();
        move_to(s, LocData { loc });
    }

    public fun runner(s: &signer) {
        Self::store_location(s);
    }
}

//# run 0x2::TokenLocTest::runner --signers 0x2

//# run 0x2::TokenLocTest::store_location --signers 0x2

//# run
script {
    fun main() {
        // Test early return prevents assertion
        let x = 0;
        if (true) {
            return;
        };
        assert!(false, 1); // This should never execute
    }
}