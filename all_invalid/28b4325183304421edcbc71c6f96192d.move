//# publish
module 0xA550C0FFEC0DE::SpecAndUseFeatures {
    use std::error;
    use std::vector;

    // 1. Module with Spec and Use annotations
    // (In actual code, these would be comments or annotations, but for this test,
    //  we simulate by including comments that might be parsed by the Move compiler or conventions)

    // Spec annotation (simulated)
    // Spec
    // Use annotation (simulated)
    // Spec

    // 2. Struct with optional visibility modifier, only allowed in language v2
    // Note: We include a visibility modifier here intentionally
    public struct VisibilityTest {
        id: u64,
        data: vector<u8>,
    }

    // Implementation of the module
    public fun new_visibility_test(id: u64, data: vector<u8>): VisibilityTest {
        VisibilityTest { id, data }
    }

    // 3. Configuration for error reporting
    // We define a function that outputs error messages to a specified writer (simulate)
    public fun report_error(writer: &mut error::Error): bool {
        // Normally, error reporting logic would go here
        // For the purposes of this test, simulate success
        true
    }

    // 4. Specification functions with names prefixed by '$'
    // These functions are for special purposes
    public fun $check_condition(condition: bool): bool {
        condition
    }

    public fun $assert_positive(value: u64): bool {
        value > 0
    }

    // 5. Defining behavior for list parsing with closure functions (simulate)
    // Since Move does not support passing closures as first-class citizens in this way,
    // we simulate this concept with function pointers or inline functions
    // For this test, define a function that simulates list parsing with continuation
    public fun parse_list_continue(list: &vector<u64>, continue_fn: fn(&u64) -> bool): bool {
        let mut success = true;
        let len = vector::length(list);
        let mut i = 0;
        while (i < len) {
            let item_ref = vector:: borrow(list, i);
            if (!continue_fn(item_ref)) {
                success = false;
                break;
            }
            i = i + 1;
        }
        success
    }

    // Simulate a continuation function that continues if item is less than 10
    public fun continue_if_less_than_10(item: &u64): bool {
        *item < 10
    }

    // Simulate a termination function (for completeness)
    public fun terminate_parse(_item: &u64): bool {
        // Always return false to terminate parsing
        false
    }
}

//# run 0xA550C0FFEC0DE::SpecAndUseFeatures::new_visibility_test --signers 0xA550C0FFEC0DE --args 1234u64 vector[1, 2, 3]