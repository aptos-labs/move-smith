
//# publish
module 0xCAFE::TypeAndLiteralTest {
    use std::vector;

    struct Label has copy, drop, store {
        id: u8,
        active: bool,
        data: vector<u8>,
    }

    public fun create_label(id: u8): Label {
        let active: bool = true;
        let data: vector<u8> = b"data_bytes";
        Label { id, active, data }
    }

    public fun get_label_id(label: &Label): u8 {
        let Label { id: id_var, active: _active_var, data: _data_var }: Label = *label;
        id_var
    }

    public fun run_no_args() {
        let num: u64 = 1234u64;
        let flag: bool = false;
        let bytes: vector<u8> = b"hello";

        let label: Label = create_label(7u8);
        let id: u8 = get_label_id(&label);

        // Use literals in expressions
        let sum: u64 = num + 10u64;
        let cond: bool = (flag || true);
        let byte_zero: u8 = bytes[0];

        // Just do all operations for coverage
        if (cond) {
            let _ = sum + (id as u64) + (byte_zero as u64);
        } else {
            let _ = 0u64;
        };
    }
}


//# run 0xCAFE::TypeAndLiteralTest::run_no_args


//# publish
module 0xCAFE::CyclicA {
    use 0xCAFE::CyclicB;

    public fun get_b_value(): u8 {
        CyclicB::get_a_value() + 1u8
    }
}


//# publish
module 0xCAFE::CyclicB {
    use 0xCAFE::CyclicA;

    public fun get_a_value(): u8 {
        CyclicA::get_b_value() + 1u8
    }
}


//# run 0xCAFE::CyclicA::get_b_value


//# run 0xCAFE::CyclicB::get_a_value


// Featurres:
// d0b098ad8683852699d7cda3649455e4: Specify the type of a variable using a colon followed by the type after the variable name.
// d52e9087944003edc064087a8ad86564: Use literals in expressions, including numbers, booleans, and byte strings.
// b87d274b57a078e136b459f4ce173e13: Detect shortest cyclic dependencies among Move modules or scripts
