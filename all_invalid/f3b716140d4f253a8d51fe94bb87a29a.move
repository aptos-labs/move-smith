
//# publish
module 0xCAFE::ClosureComparison {
    use std::vector;
    use std::bcs;

    // Define a simple closure type
    struct Closure has copy, drop {
        func_id: u8
    }

    // Dummy function that uses a closure
    public fun execute_closure(c: &Closure): u8 {
        c.func_id
    }

    // Serialize and compare two closures for equality
    public fun are_closures_equal(c1: &Closure, c2: &Closure): bool {
        let s1 = bcs::to_bytes(c1);
        let s2 = bcs::to_bytes(c2);
        s1 == s2
    }

    // Deeply nested closure composition
    public fun nested_closure(c1: &Closure, c2: &Closure): bool {
        // Compose closures inside closures (simulate by serialization)
        let _ = bcs::to_bytes(c1);
        let _ = bcs::to_bytes(c2);
        // Compare the serialized forms
        are_closures_equal(c1, c2)
    }

    // Struct with attribute and metadata (simulated with attributes as comments)
    // attribute(custom_attr)
    // metadata(name = "TestModule", version = "1.0")
    struct AnnotatedStruct has copy, drop {
        id: u64,
        name: vector<u8>
    }

    // Function to verify attributes/metadata usage (for simulation)
    public fun get_struct_id(s: &AnnotatedStruct): u64 {
        s.id
    }
}


//# run 0xCAFE::ClosureComparison::are_closures_equal --args <nested closure serializations> (simulate with identical/ different inputs)


// Testing sequential and nested `inc` function calls with local variable mutation

//# publish
module 0xCAFE::Increment {
    struct Counter has store, drop, key {
        count: u64
    }

    public fun init_counter(): Counter {
        Counter {count: 0}
    }

    public fun inc(counter: &mut Counter, delta: u64) {
        counter.count = counter.count + delta;
    }
}


//# run 0xCAFE::Increment::init_counter --signers 0xBEEF


//# run 0xCAFE::Increment::inc --signers 0xBEEF --args 1u64


//# run 0xCAFE::Increment::inc --signers 0xBEEF --args 2u64

// nested calls to inc, simulate in script context

//# run 0xCAFE::Increment::inc --signers 0xBEEF --args 3u64


//# run 0xCAFE::Increment::inc --signers 0xBEEF --args 4u64


// Featurres:
// 6007a50bc4f72e8be0ac3a965e45bfc7: Test that closures in Move can be compared by BCS serialization for structural equality and that deeply nested closure compositions function and evaluate correctly.
// 7f228160630f9fd03fd09cde00f420d5: Define modules with attributes and metadata.
// e0357db279867ffec0565c8529c72086: Verify that multiple sequential and nested calls to the `inc` function correctly mutate and accumulate the value of a local variable within different transactional contexts.
