//# publish
module 0x1::TestModule {
    // Optional spec annotation for the module
    //@ spec
    struct DataHolder has key {
        value: u64,
    }

    // Example of an invariant within module
    //@ invariant
    fun check_invariant(holder: &DataHolder) {
        assert!(holder.value >= 0, 0);
    }

    fun initialize(value: u64): DataHolder {
        let holder = DataHolder { value };
        // Call invariant check
        check_invariant(&holder);
        holder
    }

    // Runner function to test variable bindings and module functions
    public fun run_tests() {
        // Local variable binding
        let local_value = 10u64;

        // Bind as module access expression
        let module_ref = &mut Self;
        // Accessing DataHolder through module
        let data = initialize(local_value);

        // Updating internal state via mutable reference
        // (even though in this example DataHolder is not stored, just for testing access)
        let mut data_mut = data;
        data_mut.value = 20;
        // Re-check invariants after modification
        check_invariant(&data_mut);
    }
}

//# run 0x1::TestModule::run_tests

//# publish
module 0x2::SpecModule {
    // Spec designation for the module
    //@ spec
    struct Counter has key {
        count: u64,
    }

    // Defining a specification
    //@ invariant
    fun counter_non_negative(counter: &Counter) {
        assert!(counter.count >= 0, 0);
    }

    fun create_counter(start: u64): Counter {
        let counter = Counter { count: start };
        // Verify invariant
        counter_non_negative(&counter);
        counter
    }

    // Function to increment counter
    fun increment(counter: &mut Counter) {
        counter.count = counter.count + 1;
        counter_non_negative(counter);
    }

    // Runner function to test spec and invariants
    public fun run_specs() {
        let mut cnt = create_counter(0);
        // Call increment multiple times
        increment(&mut cnt);
        increment(&mut cnt);
        // After increments, invariants should hold
        counter_non_negative(&cnt);
    }
}

//# run 0x2::SpecModule::run_specs

//# publish
module 0x3::AdvancedModule {
    //@ spec
    struct ResourceHolder has key {
        resources: vector<u64>,
    }

    // Specification: invariant that resources vector length is always non-negative (trivially true)
    //@ invariant
    fun resources_length_non_negative(holder: &ResourceHolder) {
        assert!(holder.resources.len() >= 0, 0);
    }

    fun new_holder(): ResourceHolder {
        let holder = ResourceHolder { resources: vec![] };
        resources_length_non_negative(&holder);
        holder
    }

    fun add_resource(holder: &mut ResourceHolder, resource: u64) {
        holder.resources.push(resource);
        resources_length_non_negative(&holder);
    }

    // Runner function to test invariants and variable bindings
    public fun run_resource_tests() {
        let mut holder = new_holder();
        let res1 = 100u64;
        add_resource(&mut holder, res1);
        // Bind local variable to the last added resource
        let last_resource = *holder.resources.last().unwrap();
        // Use module access to verify the count
        let length = holder.resources.len();
        assert!(length >= 1, 0);
        // Add more resources
        add_resource(&mut holder, 200);
        // Check updated length
        let new_length = holder.resources.len();
        assert!(new_length >= 2, 0);
    }
}

//# run 0x3::AdvancedModule::run_resource_tests