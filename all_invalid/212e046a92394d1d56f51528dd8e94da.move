
//# publish
module 0xCAFE::InlineRefAndDestructuringTest {
    use std::vector;
    use 0xCAFE::MyModule;

    // Define a global resource with a field that is a reference
    struct GlobalResource has store, key {
        value: u64,
    }

    // Initialize the global resource with a specific value
    public fun init_global_resource(account: &signer, val: u64) {
        move_to<GlobalResource>(account, GlobalResource { value: val });
    }

    // Inline function returning reference to the GlobalResource
    public inline fun get_global_ref(): &mut GlobalResource {
        borrow_global_mut<GlobalResource>(0xCAFE)
    }

    // Function to update the global resource using the inline reference
    public fun update_global_resource(new_value: u64) {
        let global_ref = get_global_ref();
        global_ref.value = new_value;
    }

    // Function that reads the value from the global resource
    public fun read_global_value(): u64 {
        let global_ref = borrow_global<GlobalResource>(0xCAFE);
        global_ref.value
    }

    // Function demonstrating struct pattern destructuring
    public fun destructure_struct() {
        // Initialize a resource with fields
        let _res = MyModule::S { x: 42, y: 99 };
        // Pattern destructuring with renaming and reordering
        let MyModule::S { y: a, x: b } = _res;
        // Use the destructured variables; they should hold respective values
        let _ = a;
        let _ = b;
    }

    // Function that writes to a resource based on destructuring
    public fun write_destructured(x_val: u32, y_val: u32) {
        // Create resource with initial values
        let res = MyModule::S { x: x_val, y: y_val };
        // Pattern destructure with reordering and renaming
        let MyModule::S { x: new_x, y: new_y } = res;
        // Update the global resource based on destructured values
        let global_ref = get_global_ref();
        global_ref.value = (new_x + new_y) as u64;
    }
}


//# run 0xCAFE::InlineRefAndDestructuringTest::init_global_resource --signers 0xBEEF --args 10u64


//# run 0xCAFE::InlineRefAndDestructuringTest::update_global_resource --args 20u64


//# run 0xCAFE::InlineRefAndDestructuringTest::read_global_value


//# run 0xCAFE::InlineRefAndDestructuringTest::destructure_struct


//# run 0xCAFE::InlineRefAndDestructuringTest::write_destructured --args 7u32 8u32

// Featurres:
// cb8b7c46d94cdcabd3fc213fee198091: Test that an inline function returning a reference to a global resource works correctly within a function that both publishes and reads that resource.
// 453f85e1e8934b0eb47d02c4140d0b7c: Test that struct pattern destructuring with local lets (including variable renaming and reordering of fields) correctly assigns values in Move functions.
// 0b3188b910069a5f4cc923ef2dc33263: Include nested function bodies within spec blocks for detailed specifications.
