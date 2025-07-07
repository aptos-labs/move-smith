
//# publish
module 0xCAFE::PositionalFieldsAndReturnTypes {
    use std::signer;

    struct PositionalStruct has copy, drop, store, key {
        // Positional fields means we just access by order, not by names
        _0: u8,
        _1: u16,
        _2: bool,
    }

    public fun new_positional_struct(x: u8, y: u16, z: bool): PositionalStruct {
        PositionalStruct {_0: x, _1: y, _2: z}
    }

    public fun get_first_field(s: &PositionalStruct): u8 {
        // access positional field by 0
        s._0
    }

    public fun get_second_field(s: &PositionalStruct): u16 {
        s._1
    }

    public fun get_third_field(s: &PositionalStruct): bool {
        s._2
    }

    // Return type specified with colon, returning tuple type
    public fun tuple_return(): (u8, bool) {
        (7u8, true)
    }

    // Unit return type (omission of return type)
    public fun unit_return() {
        let _ = 42u64;
        // nothing returned explicitly
    }

    // Function to verify compliance with some compiler rules and documentation
    public fun verify(x: u8, y: u16): u16 {
        let sum = (x as u16) + y;
        sum
    }
}


//# run 0xCAFE::PositionalFieldsAndReturnTypes::new_positional_struct --args 10u8 20u16 true


//# run 0xCAFE::PositionalFieldsAndReturnTypes::get_first_field --args 10u8 20u16 true


//# run 0xCAFE::PositionalFieldsAndReturnTypes::get_second_field --args 10u8 20u16 true


//# run 0xCAFE::PositionalFieldsAndReturnTypes::get_third_field --args 10u8 20u16 true


//# run 0xCAFE::PositionalFieldsAndReturnTypes::tuple_return


//# run 0xCAFE::PositionalFieldsAndReturnTypes::unit_return


//# run 0xCAFE::PositionalFieldsAndReturnTypes::verify --args 25u8 100u16


// Featurres:
// d33af1270290100b7874ecb16a74dc89: Specify a return type with a colon, or omit it for unit type.
// fb945d0ba577a3bb19b24dce900e88ac: Use positional fields represented by numeric literals (`0`, `1`, etc.) in your Move code when referring to positional data.
// 3b40bd96aea75ce70537ab293569a98b: Define functions that should be verified for compliance with module documentation and compiler rules.
