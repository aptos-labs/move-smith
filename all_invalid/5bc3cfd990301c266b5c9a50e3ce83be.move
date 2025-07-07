
//# publish
module 0xCAFE::AddressUtils {
    use std::vector;

    const FILTER_VALUE_1: u8 = 10;
    const FILTER_VALUE_2: u8 = 20;
    const FILTER_VALUE_3: u8 = 30;

    // Return different filtered constants based on the input argument
    public fun filter_constants(input: u8): vector<u8> {
        let result = vector::empty<u8>();
        if (input < FILTER_VALUE_1) {
            vector::push_back(&mut result, FILTER_VALUE_1);
        };
        if (input < FILTER_VALUE_2) {
            vector::push_back(&mut result, FILTER_VALUE_2);
        };
        if (input < FILTER_VALUE_3) {
            vector::push_back(&mut result, FILTER_VALUE_3);
        };
        result
    }

    struct SpannedAddress has copy, drop, store {
        addr: address,
        loc_start: u64,
        loc_end: u64,
    }

    // Return a spanned (location-aware) NumericalAddress struct
    public fun create_spanned_address(addr: address): SpannedAddress {
        // For testing, assume loc_start = 100, loc_end = 108 representing the span
        SpannedAddress {
            addr,
            loc_start: 100,
            loc_end: 108,
        }
    }

    struct FieldInfo has copy, drop, store {
        name: vector<u8>,
        loc_start: u64,
        loc_end: u64,
    }

    struct DiagnosticError has copy, drop, store {
        duplicate_field: FieldInfo,
        message: vector<u8>,
    }

    // Check duplicate fields and return DiagnosticError if found, else abort with 0
    public fun check_duplicate_fields(): DiagnosticError {
        let field1 = FieldInfo {name: b"field1", loc_start: 10, loc_end: 15};
        let field2 = FieldInfo {name: b"field2", loc_start: 20, loc_end: 25};
        let field_duplicate = FieldInfo {name: b"field1", loc_start: 30, loc_end: 35};

        // Simulating detection of duplicate field with associated diagnostic info
        if (field1.name == field_duplicate.name) {
            let msg = b"Duplicate field name detected";
            let error = DiagnosticError {
                duplicate_field: field_duplicate,
                message: msg
            };
            // Return error to simulate reporting diagnostic
            error
        } else {
            abort 0;
        }
    }
}



//# run 0xCAFE::AddressUtils::filter_constants --args 5u8



//# run 0xCAFE::AddressUtils::filter_constants --args 15u8



//# run 0xCAFE::AddressUtils::create_spanned_address --args 0xCAFE



//# run 0xCAFE::AddressUtils::check_duplicate_fields
