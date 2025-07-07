
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;
    use std::vector;

    // Script entry point that calls an internal function
    public fun script_entry_point(s: signer) {
        internal_process(signer::address_of(&s));
    }

    // Internal function that's private (only accessible within this module)
    fun internal_process(addr: address) {
        // Dummy internal process for testing
        let _ = addr;
    }

    // Function involving nested loops with variable shadowing and assignments
    public fun loop_shadowing_test() {
        let a = 0;
        let a = {
            let a_inner = 5;
            a_inner
        };
        // a should still be 0 outside the inner block, a_inner is shadowed
        let count = 0;
        while (count < 3) {
            let count_shad = count + 1; // Shadowed variable
            count = count_shad;
        };
        // count should be 3 after the loop
        let final_a = a;
        // The value of final_a remains 0, testing variable shadowing
        assert!(final_a == 0, 999);
    }

    // A public function that calls a private, internal function
    public fun call_internal(s: signer) {
        internal_nested(signer::address_of(&s));
    }

    // Internal nested function; accessible within the module
    fun internal_nested(addr: address) {
        let _ = addr;
    }

    // Function that should only be called internally, testing visibility
    fun internal_only_function() {
        // do nothing, testing internal access
    }

    // Function to test module filtering by having a different address
    public fun filter_test() {
        // purposely empty to act as a marker
    }

    // Function implementing a list parsing with switch/case logic (simulate parser)
    public fun parse_list<T>(
        list: vector<T>,
        continue_fn: (vector<T>, T, bool) => bool,
        item_fn: (vector<T>, T) => vector<T>,
        parser_fn: (vector<T>) => (vector<T>, bool)
    ): vector<T> {
        let index = 0;
        let len = vector::length(&list);
        let remaining = list;
        let parsed_list = vector::empty<T>();
        while (index < len) {
            // process current item
            let item_ref = vector::borrow(&remaining, index);
            let item = *item_ref;
            // invoke continue_fn to decide continuation
            if (!continue_fn(remaining, item, false)) {
                break;
            }
            // process item with item_fn
            parsed_list = item_fn(parsed_list, item);
            index = index + 1;
        };
        // process with parser_fn at the end
        let (rest, success) = parser_fn(remaining);
        if (success) {
            parsed_list = vector::append(parsed_list, rest);
        }
        parsed_list
    }
}



//# run 0xCAFE::FeatureTest::script_entry_point --signers [0xDAVE]



//# run 0xCAFE::FeatureTest::loop_shadowing_test



//# run 0xCAFE::FeatureTest::call_internal --signers [0xDAVE]



//# run 0xCAFE::FeatureTest::filter_test



//# run 0xCAFE::FeatureTest::parse_list --args [1u8, 2u8, 3u8]


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// aea0924f9167959f01edde6ae806553e: Filter modules, scripts, or addresses based on specific criteria during compilation.
// bf49700cf955331be956ada40e195684: Create functions that parse lists of items with customizable continuation and item parsing logic.
