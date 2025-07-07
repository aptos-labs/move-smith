
//# publish
module 0xDEAD::SpecPatternTest {
    use std::vector;
    use std::string;

    // Mock specification block for testing apply patterns
    struct SpecBlock has copy, drop {
        exclude_patterns: vector<string>,
        include_patterns: vector<string>,
        // Additional fields can be added if needed
    }

    // Function to apply patterns with optional exclusion
    public fun apply_patterns_with_exclusion(
        blocks: vector<SpecBlock>,
        apply_exclude: bool,
        exclude_patterns: vector<string>,
        include_patterns: vector<string>
    ): vector<SpecBlock> {
        // filter blocks based on exclusion pattern
        let result: vector<SpecBlock> = vector::empty<SpecBlock>();
        let len = vector::length(&blocks);
        let i = 0;
        while (i < len) {
            let block_ref = vector::borrow(&blocks, i);
            let should_include = true; // changed 'let' to 'var' to allow mutation
            if (apply_exclude) {
                let patterns = &block_ref.exclude_patterns;
                let patterns_len = vector::length(patterns);
                let j = 0; // Use mutable variable for loop index
                let k = 0; // 'k' must be mutable
                // Create an inner scope for 'k' declaration to mutate
                // But Move doesn't support nested 'let' scopes, so instead declare outside
                let included_in_list = false;
                // Loop 'j' variable
                let j_mut = 0;
                while (j_mut < patterns_len) {
                    let pattern = vector::borrow(patterns, j_mut);
                    // Loop 'k'
                    k = 0;
                    included_in_list = false;
                    let include_patterns_len = vector::length(&include_patterns);
                    while (k < include_patterns_len) {
                        let include_pattern = vector::borrow(&include_patterns, k);
                        if (string::eq(&pattern, &include_pattern)) {
                            included_in_list = true;
                            break;
                        }
                        k = k + 1;
                    }
                    if (included_in_list) {
                        should_include = false;
                        break;
                    }
                    j_mut = j_mut + 1;
                }
            }
            if (should_include) {
                vector::push_back(&mut result, *block_ref);
            }
            i = i + 1;
        }
        result
    }

    // Function to convert vector of spec blocks with a custom translation function
    public fun convert_spec_blocks(
        blocks: vector<SpecBlock>,
        translation_fn: &function(vector<SpecBlock>): vector<SpecBlock>
    ): vector<SpecBlock> {
        translation_fn(blocks)
    }

    // Attribute preservation example: keep attributes after filtering
    struct AttrHolder has copy, drop {
        attribute: string,
        value: u64,
    }

    // filter attributes based on attribute name pattern
    public fun filter_attributes(
        attrs: vector<AttrHolder>,
        pattern: string
    ): vector<AttrHolder> {
        let result: vector<AttrHolder> = vector::empty<AttrHolder>();
        let len = vector::length(&attrs);
        let i = 0;
        while (i < len) {
            let attr_ref = vector::borrow(&attrs, i);
            if (string::index_of(&attr_ref.attribute, &pattern) >= 0) {
                vector::push_back(&mut result, *attr_ref);
            }
            i = i + 1;
        }
        result
    }
}



//# run 0xDEAD::SpecPatternTest::apply_patterns_with_exclusion --args
// (empty args as function is test setup style)



//# run 0xDEAD::SpecPatternTest::convert_spec_blocks --args
// (No args needed, just static calls within test scripts)



//# run 0xDEAD::SpecPatternTest::filter_attributes --args
// (No args needed, just static calls within test scripts)

// Features:
// 19307183f78d0f73889e34477e9b7c8c: Apply patterns to spec expressions using apply in spec blocks, with optional exclusion patterns.
// 3799c6bfdbc4b15df5c296f602bbe4e3: Convert a vector of specification blocks into a vector of processed specification blocks with a custom translation function.
// 4b6d40e28a7a904547acce22c6d33d0c: Preserve attributes, location, address, name, and specification module status of the module after filtering.