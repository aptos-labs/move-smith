
//# publish
module 0xCAFE::FilteredSpecAndNaming {
    use std::signer;

    struct Data has store {
        value: u8,
    }

    public fun create_data(s: signer, v: u8) {
        let data = Data { value: v };
        move_to<Data>(&s, data);
    }

    public fun update_value(s: signer, new_value: u8) {
        let data_ref: &mut Data = borrow_global_mut<Data>(signer::address_of(&s));
        data_ref.value = new_value;
    }

    public fun get_value(s: signer): u8 {
        let data_ref: &Data = borrow_global<Data>(signer::address_of(&s));
        data_ref.value
    }

    // Spec block associated with field `value` - should be excluded if filtered out.
    spec data_value {
        phantom byte: u8;
    }

    // Test function with identifier names not colliding with keywords
    public fun count_to_five() {
        let counter = 0u8;
        while (counter <= 5) {
            // increment counter by 1
            counter = counter + 1;
        };
        // When the while loop completes, counter == 6, we test that the count was done
        assert!(counter == 6, 1000);
    }
}


//# run 0xCAFE::FilteredSpecAndNaming::count_to_five


//# run 0xCAFE::FilteredSpecAndNaming::create_data --signers 0xD00D --args 10u8


//# run 0xCAFE::FilteredSpecAndNaming::get_value --signers 0xD00D


//# run 0xCAFE::FilteredSpecAndNaming::update_value --signers 0xD00D --args 20u8


//# run 0xCAFE::FilteredSpecAndNaming::get_value --signers 0xD00D


// Featurres:
// 944c71e0a34ef5d7ebaf41b064209326: Exclude spec blocks associated with filtered-out members from the module.
// 2405661452d0059721ed6e84ace71488: Use identifiers for naming variables, functions, modules, and other Move constructs that do not conflict with reserved keywords.
// 8904a4822b34c829900e121b1fdae630: Test that a `while` loop correctly counts from 0 to 5 and that the assertion passes when the loop terminates.
