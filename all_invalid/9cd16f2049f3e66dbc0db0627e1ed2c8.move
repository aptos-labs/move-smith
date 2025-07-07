//# publish
module 0xCAFE::TestAttachSpecs {
    public inline fun inline_with_spec() {
        //#[spec]
        // The inline function should be recognized with a specification block
    }

    public fun call_inline_with_spec() {
        inline_with_spec(); // Call inline function with attached spec
    }

    // This function is used to test binding in range lists
    fun bind_unbound_variables_in_range(start: u64, end: u64): vector<u64> {
        let vec = vector::empty<u64>();
        let i = start;
        while (i < end) {
            vector::push_back(&mut vec, i);
            i = i + 1;
        }
        vec
    }

    // Define a resource struct with the resource keyword
    resource struct DataResource {
        value: u64,
    }
}

//# run 0xCAFE::TestAttachSpecs::call_inline_with_spec
//# run 0xCAFE::TestAttachSpecs::bind_unbound_variables_in_range --args 10 15

//# publish
module 0xCAFE::TestResourceDeclaration {
    // Declare the resource without the 'resource' keyword
    struct Counter {
        count: u64,
    }

    public fun create_counter(): Counter {
        let counter = Counter { count: 0 };
        counter
    }

    public fun increment_counter(c: &mut Counter) {
        c.count = c.count + 1;
    }

    public fun get_counter_value(c: &Counter): u64 {
        c.count
    }
}

//# run 0xCAFE::TestResourceDeclaration::create_counter --signers 0xCAFE
//# run 0xCAFE::TestResourceDeclaration::increment_counter --signers 0xCAFE --args <counter_address>
// To test this, you would need to move the resource into global storage and then borrow it mutably to modify and read its value, but here is a simple invocation setup.

// Featurres:
// f3a7035384ac791c9ac3118b6c3076ba: Attach specification blocks to functions during inlining to include behavior specifications in the generated inline functions.
// 9307d7438b19976eb40b2b26e0dd31d9: Bind names to unbound variables within a range list during move code translation.
// 6ab8797b66a06348f368b697382c1c80: Declare resources as 'resource struct StructName' instead of 'resource StructName'.
