//# publish
module 0xA11C::AddressAttributes {
    // Define address attributes as annotation for testing
    use std::string;
    use std::vector;

    // Address attribute data structure
    struct Attr has copy, drop, store {
        key: string::String,
        value: string::String,
    }

    // Store attributes for an address
    resource struct AddressAttrs {
        attrs: vector<Attr>,
    }

    public fun init_attrs(account: &signer) {
        let attrs = vector::empty<Attr>();
        // Initialize with some attributes
        vector::push_back(&mut attrs, Attr { key: string::utf8(b"role"), value: string::utf8(b"admin") });
        vector::push_back(&mut attrs, Attr { key: string::utf8(b"department"), value: string::utf8(b"engineering") });
        move_to(account, AddressAttrs { attrs });
    }

    // Function to get attributes
    public fun get_attrs(addr: address): vector<Attr> acquires AddressAttrs {
        if (exists<AddressAttrs>(addr)) {
            let attrs_ref = borrow_global<AddressAttrs>(addr);
            attrs_ref.attrs
        } else {
            vector::empty<Attr>()
        }
    }
}

//# publish
module 0xA11C::UseDeclarations {
    use 0xA11C::AddressAttributes::{Attr, get_attrs};
    use std::vector;

    public fun process_address_types(addr: address) {
        let attrs = get_attrs(addr);
        // process types in the attrs vector
        let types_vec = vector::map(&attrs, |attr: &Attr| {
            type_(attr.key)::string::String
        });
        // For testing, just loop (no assertions)
        let length = vector::length(&types_vec);
        let mut i = 0;
        while (i < length) {
            // process each type (parsed from key)
            let _current_type = vector::borrow(&types_vec, i);
            i = i + 1;
        }
    }

    // Helper function to process each type
    fun type_(type_str: string::String) {
        // dummy function to process types
        // could be extended
    }
}

//# publish
module 0xA11C::TypeProcessing {
    use std::vector;
    use std::string;

    // Function to process a collection of types
    public fun process_types(types: vector::Vector<string::String>) {
        let len = vector::length(&types);
        let mut i = 0;
        while (i < len) {
            type_(vector::borrow(&types, i));
            i = i + 1;
        }
    }

    fun type_(type_value: &string::String) {
        // Dummy processing, e.g., print or evaluate
    }
}

//# run 0xA11C::AddressAttributes::init_attrs --signers 0x1
//# run 0xA11C::UseDeclarations::process_address_types --signers 0x1 --args 0x1
//# run 0xA11C::TypeProcessing::process_types --signers 0x1 --args "" "" ""

// Featurres:
// 418d21af27824d7d28f4fb5f19bde171: Use attributes on address blocks to annotate them.
// 199796f4552b1774c1782b9505db02af: Use use declarations to include other modules or items.
// b775aa116e612f165d2c157d886f2f1a: Use the 'types' function to process each type in a collection by applying the 'type_' function to it.
