//# publish
module 0x1::WhitespaceUtil {
    public fun trim_leading_spaces(s: vector<u8>): vector<u8> {
        let mut index = 0;
        let len = vector::length(&s);
        while (index < len) {
            let c = *vector::borrow(&s, index);
            if (c == 0x20u8 || c == 0x09u8 || c == 0x0au8 || c == 0x0du8) { // whitespace chars
                index = index + 1;
            } else {
                break;
            }
        };
        vector::slice(&s, index, len - index)
    }
}

//# publish
module 0x1::TestFeatures {
    use 0x1::WhitespaceUtil;

    // An empty struct with no fields
    struct EmptyStruct {}

    // Function to test whitespace trimming
    public fun test_trim_whitespace(s: vector<u8>): vector<u8> {
        WhitespaceUtil::trim_leading_spaces(s)
    }

    // Function to test addition
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    // Function to create an instance of EmptyStruct
    public fun create_empty_struct(): EmptyStruct {
        EmptyStruct {}
    }

    // Function to test control flow with if
    public fun check_even(n: u64): bool {
        if (n % 2 == 0) {
            true
        } else {
            false
        }
    }

    // Function to test while loop
    public fun count_down(mut start: u64): u64 {
        let mut sum = 0;
        while (start > 0) {
            sum = sum + start;
            start = start - 1;
        }
        sum
    }

    // Function to test loop and break
    public fun loop_break(limit: u64): u64 {
        let mut total = 0;
        let mut i = 0;
        loop {
            if (i >= limit) {
                break;
            }
            total = total + i;
            i = i + 1;
        }
        total
    }

    // Function to transform a script function - just a dummy here
    public fun run_script_filter(): bool {
        // Simulate some filtering conditions
        true
    }

    // Runner function to test various features
    public fun run_all(): bool {
        // Call add
        let sum = add(10, 20);
        if (sum != 30) { return false; }

        // Create empty struct
        let _instance = create_empty_struct();

        // Test whitespace trim
        let s = b"   \t\nHello World".to_vector();
        let trimmed = test_trim_whitespace(s);
        // The trimmed string should start with 'H' (ASCII 72)
        if (vector::length(&trimmed) == 0 || *vector::borrow(&trimmed, 0) != 72u8) {
            return false;
        }

        // Test control flow - check even
        if (!check_even(4) || check_even(5)) {
            return false;
        }

        // Test while loop sum
        let total_sum = count_down(5);
        if (total_sum != 15) {
            return false;
        }

        // Test loop and break
        let total_loop = loop_break(3);
        if (total_loop != 0 + 1 + 2) {
            return false;
        }

        // Test script filter
        if (!run_script_filter()) {
            return false;
        }

        true
    }
}

//# run 0x1::TestFeatures::run_all --signers 0x1