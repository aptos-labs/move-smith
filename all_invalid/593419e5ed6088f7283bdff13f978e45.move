//# publish
module 0xCAFE::DisplayTest {
    use std::vector;
    use std::string;

    // Public function to test formatting a list of displayable items
    public fun test_format_list(items: vector<u8>): vector<u8> {
        let result: vector<u8> = vector::empty<u8>();
        let len = vector::length(&items);
        let i: u64 = 0;

        while (i < len) {
            let item = *vector::borrow(&items, i);
            // Convert item to string (simulate formatting)
            // Note: In actual Move, string concatenation is not straightforward,
            // so we simulate by pushing bytes for demonstration
            vector::push_back(&mut result, item);
            if (i + 1 < len) {
                // Append comma separator
                vector::push_back(&mut result, b','); // Fixed character syntax
            }
            i = i + 1;
        };
        result
    }

    // Public function to test usage of a name fragment in specifications
    public fun test_name_fragment(id: u64): u64 {
        // Use the identifier as part of a dummy specification
        // In Move, string concatenation isn't supported directly.
        // For demonstration, we just return the id.
        id
    }

    // Public function to use 'match' as a function call
    public fun match_as_function(val: u8): u8 {
        // 'match' as a function call, with pattern matching inside
        match (val, {
            0 => 100,
            1 => 200,
            _ => 300
        })
    }
}


//# run 0xCAFE::DisplayTest::test_format_list --args 10u8 20u8 30u8


//# run 0xCAFE::DisplayTest::test_name_fragment --args 42u64


//# run 0xCAFE::DisplayTest::match_as_function --args 0u8

// Featurres:
// eb777228a1668300b377b91da334f529: Format a list of displayable items as a comma-separated string.
// 3b35c629153b1215c0701fa31658c767: Use a name fragment in specifications by specifying an identifier.
// e11ee14141353863d01f9dc6bd4c5061: Use 'match' as a function call 'match()' with arguments separated by commas inside parentheses.
