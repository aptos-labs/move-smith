//# publish
module 0xABCD::interaction_tests {

    // Resource with a simple value
    struct Counter has key {
        count: u64,
    }

    // Function to initialize a counter
    public fun init_counter(addr: address): Counter {
        Counter { count: 0 }
    }

    // Resource that interacts with Counter resource
    struct InteractionResource has key {
        interacted: bool,
    }

    public fun do_interaction(addr: address) acquires Counter, InteractionResource {
        let counter_ref = borrow_global_mut<Counter>(addr);
        let interaction_ref = borrow_global_mut<InteractionResource>(addr);
        // If count > 5, reset to 0, else increment
        if (*counter_ref).count > 5 {
            (*counter_ref).count = 0;
        } else {
            (*counter_ref).count = (*counter_ref).count + 1;
        }

        // Mark interaction as occurred
        *interaction_ref = InteractionResource { interacted: true };
    }

    // Helper to create resources for testing
    public fun setup(addr: address) {
        move_to<Counter>(addr, Counter { count: 3 });
        move_to<InteractionResource>(addr, InteractionResource { interacted: false });
    }

    // Function that exercises do_interaction with various counts
    public fun run_sequence(addr: address, steps: u64) {
        let i = 0;
        while (i < steps) {
            do_interaction(addr);
            i = i + 1;
        }
    }

    // Function to check interaction result
    public fun check_interaction(addr: address): bool acquires InteractionResource {
        let interaction_ref = borrow_global<InteractionResource>(addr);
        interaction_ref.interacted
    }
}

//# run 0xABCD::interaction_tests::setup --signers 0xUSER

//# run 0xABCD::interaction_tests::run_sequence --signers 0xUSER --args 10u64

//# run 0xABCD::interaction_tests::check_interaction --signers 0xUSER

//# publish
module 0x1234::multifunc_tests {

    // Enum with various function types
    enum FuncVariants has copy, drop {
        NoParam(||u64),
        OneParam(|u64|u64),
        TwoParam(|u64, u64|u64),
        MultipleParams(|u64, u64, u64|u64),
    }

    // Runner that executes a FuncVariants with matching pattern
    fun execute(f: FuncVariants): u64 {
        match (f) {
            FuncVariants::NoParam(func) => func(),
            FuncVariants::OneParam(func) => func(10),
            FuncVariants::TwoParam(func) => func(5, 7),
            FuncVariants::MultipleParams(func) => func(1, 2, 3),
        }
    }

    // Tests for different function variants
    public fun test_variants() {
        let f1 = FuncVariants::NoParam(|| 42);
        assert!(execute(f1) == 42);

        let f2 = FuncVariants::OneParam(|x| x + 5);
        assert!(execute(f2) == 15);

        let f3 = FuncVariants::TwoParam(|x, y| x * y);
        assert!(execute(f3) == 35);

        let f4 = FuncVariants::MultipleParams(|x, y, z| x + y + z);
        assert!(execute(f4) == 6);
    }

    // Additional runner refactoring
    fun run_with_closure(f: FuncVariants): u64 {
        let to_call = match (f) {
            FuncVariants::NoParam(func) => || func(),
            FuncVariants::OneParam(func) => || func(10),
            FuncVariants::TwoParam(func) => || func(5, 7),
            FuncVariants::MultipleParams(func) => || func(1, 2, 3),
        };
        to_call()
    }

    public fun test_run_with_closure() {
        let f1 = FuncVariants::NoParam(|| 100);
        assert!(run_with_closure(f1) == 100);

        let f2 = FuncVariants::OneParam(|x| x * 2);
        assert!(run_with_closure(f2) == 20);

        let f3 = FuncVariants::TwoParam(|x, y| x - y);
        assert!(run_with_closure(f3) == -2);

        let f4 = FuncVariants::MultipleParams(|x, y, z| x * y + z);
        assert!(run_with_closure(f4) == 13);
    }

    // Recursive function to get first function in nested enums
    fun extract_func(f: FuncVariants): &||u64 {
        match (f) {
            FuncVariants::NoParam(func) => &func,
            FuncVariants::OneParam(_) => abort 100,
            FuncVariants::TwoParam(_) => abort 101,
            FuncVariants::MultipleParams(_) => abort 102,
        }
    }

    fun call_extracted_func(f: &FuncVariants): u64 {
        match (f) {
            FuncVariants::NoParam(func) => func(),
            _ => abort 103,
        }
    }

    public fun test_extract() {
        let f1 = FuncVariants::NoParam(|| 777);
        assert!(call_extracted_func(&f1) == 777);
    }
}

//# run 0x1234::multifunc_tests::test_variants

//# run 0x1234::multifunc_tests::test_run_with_closure

//# run 0x1234::multifunc_tests::test_extract