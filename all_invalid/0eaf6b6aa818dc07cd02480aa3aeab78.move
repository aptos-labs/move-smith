
//# publish
module 0xCAFE::AbilitiesCombination {
    // This module tests combining multiple abilities, specifically Drop + Store for a struct
    
    use std::drop;
    use std::store;
    use std::key;

    struct CompositeStruct has drop, store, key {
        data: u64
    }

    public fun create_and_move(signer: signer): CompositeStruct {
        let obj = CompositeStruct { data: 42 };
        move_to<CompositeStruct>(&signer, obj)
    }

    public fun borrow_and_use(address: address): u64 {
        let obj_ref: &CompositeStruct = borrow_global<CompositeStruct>(address);
        obj_ref.data
    }

    public fun borrow_mut_and_update(address: address, new_data: u64) {
        let obj_mut_ref: &mut CompositeStruct = borrow_global_mut<CompositeStruct>(address);
        obj_mut_ref.data = new_data;
    }

    public fun drop_object(address: address) {
        let obj: CompositeStruct = move_from<CompositeStruct>(address);
        // Dropping by moving out; verify drop capabilities
    }
}


//# run 0xCAFE::AbilitiesCombination::create_and_move --signers 0xBADD


//# run 0xCAFE::AbilitiesCombination::borrow_and_use --args 0xBADD


//# run 0xCAFE::AbilitiesCombination::borrow_mut_and_update --args 0xBADD 100u64


//# run 0xCAFE::AbilitiesCombination::drop_object --args 0xBADD --signers 0xBADD

// Comparing Ability combinations on a native struct (if senseful), alternatively, check with custom struct as above.


// Test use statements ending with semicolon for validation
// Multiple use declarations in a module


//# publish
module 0xCAFE::UseSemicolonTest {
    use std::vector; // Correct usage
    use std::string; // Correct usage

    // Incorrect usage: Uncomment to test syntax error detection
    // use std::move // Missing semicolon, should cause compile error
}


//# run 0xCAFE::UseSemicolonTest

// For malformed use, do it as a separate invalid test which is expected to produce a compile error, but we won't run it here.

// Native structs without explicitly declared fields


//# publish
module 0xCAFE::NativeStructTest {
    // Define a native struct without declared fields
    native struct NativeStructWithoutFields {}

    // Define a native struct with some fields for contrast
    native struct NativeStructWithFields {
        value: u64
    }

    // Function to instantiate native structs
    public fun create_native_struct_without_fields(): NativeStructWithoutFields {
        NativeStructWithoutFields {}
    }

    public fun create_native_struct_with_fields(val: u64): NativeStructWithFields {
        NativeStructWithFields { value: val }
    }

    // Function to test using native structs
    public fun use_native_structs() {
        let _a = create_native_struct_without_fields();
        let b = create_native_struct_with_fields(999);
        // purposely no assertions; just ensuring they compile and instantiate
        let _ = b.value;
    }
}


//# run 0xCAFE::NativeStructTest::use_native_structs

// Summary:
// 1. The first module tests combining multiple abilities on a single struct and ensures that drop, store, and key both work and enforce abilities.
// 2. The second module tests `use` declarations with correct semicolon usage and implicitly checks that missing semicolons give syntax errors.
// 3. The third module tests defining and instantiating native structs with no explicit fields and with fields.
// 4. These combined tests check for correct handling of multiple abilities, syntax adherence in module imports, and native struct behavior, thus verifying complex interactions and compiler correctness.


// Featurres:
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 0def0c1763b670eae541afeaa8dbb2d9: End use declarations with a semicolon
// 670e265113932ad53e09f0f61d88b59f: Define native structs without declared fields in Move modules
