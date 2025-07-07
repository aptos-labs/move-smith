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
    // Declare the struct without the 'resource' keyword
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
//# run 0xCAFE::TestResourceDeclaration::increment_counter --signers 0xCAFE --args 0xCAFE::TestResourceDeclaration::create_counter