//# publish
module 0x1::UnitTypeModule {
    use std::signer;

    // Define some unit structs (unit types)
    struct UnitTypeA has copy, drop, store {}
    struct UnitTypeB has copy, drop, store {}

    // Function that returns a UnitTypeA instance
    public fun make_unit_a(): UnitTypeA {
        UnitTypeA {}
    }

    // Function that accepts UnitTypeB reference - testing ref safety
    public fun consume_unit_b_ref(_ref: &UnitTypeB) {
        // no-op, just takes reference to test ref safety
    }

    // Function that creates & uses references to test safety analysis
    public fun ref_safety_test(): UnitTypeA {
        let a = make_unit_a();
        let a_ref = &a;
        // Pass reference to a dummy consume function
        // This checks the compiler safety checks on references
        consume_unit_b_ref(&(UnitTypeB {}));
        // Return the original unit type object
        a
    }

    // Runner function to exercise the above
    public fun runner() {
        let _ = ref_safety_test();
    }
}
//# run 0x1::UnitTypeModule::runner

//# publish
module 0x1::BytecodeAttachment {
    use std::vector;
    use std::signer;

    /// Struct that holds raw bytecode vector (to simulate bytecode attachment)
    struct BytecodeHolder has store {
        code: vector<u8>,
    }

    // Function to create a BytecodeHolder with some dummy bytecode
    public fun create_and_store(): BytecodeHolder {
        // Dummy bytecode: e.g. a vector of some u8 bytes that might represent bytecode
        let bytes = vector::empty<u8>();
        vector::push_back(&mut bytes, 0x01);
        vector::push_back(&mut bytes, 0x02);
        vector::push_back(&mut bytes, 0x03);
        BytecodeHolder { code: bytes }
    }

    // Runner function that creates a bytecode holder and returns it (just to run some code)
    public fun runner() {
        let _holder = create_and_store();
    }
}
//# run 0x1::BytecodeAttachment::runner

//# run
script {
    use 0x1::UnitTypeModule;
    use 0x1::BytecodeAttachment;
    fun main(s: signer) {
        // Run functions from UnitTypeModule, testing unit types and reference safety 
        UnitTypeModule::runner();

        // Run BytecodeAttachment runner to attach dummy bytecode vector
        BytecodeAttachment::runner();
    }
}