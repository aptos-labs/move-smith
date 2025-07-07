
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Define a generic struct with a type parameter
    struct Container<T> has copy, drop, store, key {
        value: T,
        label: vector<u8>,
    }

    // Function to create a Container instance
    public fun create_container<T: copy + drop + store>(v: T, lbl: vector<u8>): Container<T> {
        Container { value: v, label: lbl }
    }

    // Function to get the value of a Container
    public fun get_value<T: copy + drop + store>(c: &Container<T>): T {
        c.value
    }

    // Function to update the value inside Container
    public fun update_value<T: copy + drop + store>(c: &mut Container<T>, new_value: T) {
        c.value = new_value;
    }

    // Test for type parameters in struct fields
    public fun test_type_params() {
        let c_u8 = create_container(42u8, b"uint8");
        let c_u64 = create_container(1000u64, b"uint64");

        let val_u8 = get_value(&c_u8);
        let val_u64 = get_value(&c_u64);

        // These are just to prevent optimization (not assertions)
        let _ = val_u8;
        let _ = val_u64;

        // Update values
        update_value(&mut c_u8, 55u8);
        update_value(&mut c_u64, 2000u64);
    }

    // Spec block to specify invariants related to Containers
    spec {
        // Invariant: for any container c of type Container<u8>, the value is always in [0, 255]
        invariant forall c: Container<u8> {
            c.value <= 255
        };
        // For Container<u64>, value should always be in [0, 2^64 -1], which always holds for u64
        invariant true;
    }

    // Function that has an infinite loop to exhaust gas
    public fun infinite_loop() {
        loop {
            // infinite loop consuming gas
        }
    }
}


//# run 0xDEAD::TestModule::test_type_params


//# run 0xDEAD::TestModule::infinite_loop


// Featurres:
// fa09991c70ad2489dd408fee816518bc: Use type parameters in the types of struct fields.
// d2481eaa11a9e5dd99ed461357bcfa99: Declare 'update' invariants in spec blocks to specify conditions that must hold after updates.
// 2b95d63253347d971b7a478f76be295d: Test that executing an infinite loop consumes gas until it runs out and causes a transaction failure.
