
//# publish
module 0xCAFE::InlineRefAndDestructuringTest {
    use std::vector;

    // The module used for struct definition must be actual existing in the codebase.
    // Here, we assume the user wants to reference a struct 'S' defined elsewhere,
    // but since the error indicates 'MyModule' is not defined, and we cannot import
    // or assume it exists, we need to define the struct locally.
    // Alternatively, if the struct 'S' is supposed to be in some existing module, 
    // the user should give the correct module address and name.
    //
    // For demonstration, define struct 'S' directly here:
    //
    // Note: The instructions specify we cannot reference modules that don't exist,
    // so we will define the struct locally instead of importing.

    // Define a local struct for usage in destructuring
    struct S has copy, drop, store {
        x: u32,
        y: u32,
    }

    // Define a global resource with a field that is a reference
    struct GlobalResource has store, key {
        value: u64,
    }

    // Initialize the global resource with a specific value
    public fun init_global_resource(account: &signer, val: u64) {
        move_to<GlobalResource>(account, GlobalResource { value: val });
    }

    // Inline function returning mutable reference to the global resource
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
        let res = S { x: 42, y: 99 };
        // Pattern destructuring with renaming and reordering
        let S { y: a, x: b } = res;
        // Use the destructured variables; they should hold respective values
        let _ = a;
        let _ = b;
    }

    // Function that writes to a resource based on destructuring
    public fun write_destructured(x_val: u32, y_val: u32) {
        // Create resource with initial values
        let res = S { x: x_val, y: y_val };
        // Pattern destructure with reordering and renaming
        let S { x: new_x, y: new_y } = res;
        // Update the global resource based on destructured values
        let global_ref = get_global_ref();
        global_ref.value = (new_x + new_y) as u64;
    }
}