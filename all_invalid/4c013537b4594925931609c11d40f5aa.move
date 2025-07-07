
//# publish
module 0xCAFE::SpecBlockTest {
    use std::vector;
    use std::signer;

    // A spec_block like structure with members of various kinds
    struct MemberData has copy, drop, store {
        name: vector<u8>,
        kind: u8, // 0: function, 1: constant, 2: struct
        value_u8: u8,
    }

    struct SpecBlock has key {
        members: vector<MemberData>
    }

    // Constants to use as member kinds
    const KIND_FUNCTION: u8 = 0;
    const KIND_CONSTANT: u8 = 1;
    const KIND_STRUCT: u8 = 2;

    // A constant member
    const CONSTANT_VALUE: u8 = 77;

    // A struct member to be referenced
    struct StructMember has copy, drop, store {
        val: u8,
    }

    // A pure function member, no side effects at all
    public fun pure_function(x: u8): u8 {
        // Just a pure computation, no global access or writes
        let y = x * 2;
        y + 1
    }

    // Build a SpecBlock with members of different kinds
    public fun new_spec_block(): SpecBlock {
        let members = vector::empty<MemberData>();
        let m1 = MemberData {
            name: b"pure_function",
            kind: KIND_FUNCTION,
            value_u8: 0,
        };
        let m2 = MemberData {
            name: b"CONSTANT_VALUE",
            kind: KIND_CONSTANT,
            value_u8: CONSTANT_VALUE,
        };
        let m3 = MemberData {
            name: b"StructMember",
            kind: KIND_STRUCT,
            value_u8: 99,
        };
        vector::push_back(&mut (members), m1);
        vector::push_back(&mut (members), m2);
        vector::push_back(&mut (members), m3);

        SpecBlock {members}
    }

    // Iterate and validate spec block member data
    public fun validate_members(sb_: &SpecBlock): u8 {
        let sum: u8 = 0;
        let len = vector::length(&sb_.members);
        let i = 0;
        while (i < len) {
            let member_ref = vector::borrow(&sb_.members, i);
            if (member_ref.kind == KIND_FUNCTION) {
                let r = Self::pure_function(i as u8);
                // add function call result and index
                sum = sum + r + (i as u8);
            } else if (member_ref.kind == KIND_CONSTANT) {
                sum = sum + member_ref.value_u8;
            } else if (member_ref.kind == KIND_STRUCT) {
                // Create StructMember and add val
                let sm = StructMember {val: member_ref.value_u8};
                sum = sum + sm.val;
            };
            i = i + 1;
        };
        sum
    }

    // A pure function that calls pure_function and uses constants
    public fun combined_pure(x: u8): u8 {
        let a = Self::pure_function(x);
        let b = CONSTANT_VALUE;
        let c = StructMember {val: b};
        a + c.val
    }

    // A helper function that returns pure_function output as wrapper (for run args)
    public fun pure_function_wrapper(x: u8): u8 {
        Self::pure_function(x)
    }
}

//# run 0xCAFE::SpecBlockTest::new_spec_block


//# run 0xCAFE::SpecBlockTest::validate_members --args  // will call below wrapper to get SpecBlock first

// To test validate_members, we create wrapper script below


//# run 0xCAFE::SpecBlockTest::combined_pure --args 10u8


//# run 0xCAFE::SpecBlockTest::pure_function_wrapper --args 13u8



//# publish
module 0xCAFE::AddressModuleTest {
    use std::vector;

    // A struct under a module to test referencing with full Module:: and Address:: syntax
    struct Data has copy, drop, store {
        val: u8,
    }

    /// Returns value in Data + input param
    public fun combine(data: &Data, x: u8): u8 {
        data.val + x
    }

    public fun create_data(val: u8): Data {
        Data {val}
    }
}

//# run 0xCAFE::AddressModuleTest::combine --args


//# run 0xCAFE::AddressModuleTest::create_data --args 5u8



//# run
script {
    use 0xCAFE::SpecBlockTest;
    use 0xCAFE::AddressModuleTest;

    fun main() {
        // Create spec block
        let sb = SpecBlockTest::new_spec_block();

        // Validate members: iteration and checking different kinds
        let sum = SpecBlockTest::validate_members(&sb);
        // ignore assertions; just call

        // Call combined pure function
        let _res = SpecBlockTest::combined_pure(20u8);

        // Call AddressModuleTest functions referencing via Module:: and Address::
        let data = AddressModuleTest::create_data(7u8);
        let result = AddressModuleTest::combine(&data, 8u8);

        // We also call pure_function_wrapper to verify correctness
        let pf = SpecBlockTest::pure_function_wrapper(50u8);
    }
}


// Featurres:
// 5150380481275eda980218b36d0571f8: Include individual specification block members by iterating through `sb_.members` within a `spec_block`.
// 81a18a867fbc5a86269fd5f8795a2b71: Write move functions without side effects to ensure purity.
// fa7aeaedb78b1deb3914ab164798b74e: Refer to modules or addresses with 'Module::' or 'Address::' instead of 'Module.' or 'Address.'.
