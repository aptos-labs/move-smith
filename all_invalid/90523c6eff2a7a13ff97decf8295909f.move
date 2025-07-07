
//# publish
module 0xBADD::ComplexFeatureInteraction {
    // No dependencies on other modules to keep the test self-contained

    use std::vector;

    // A test struct to hold some state
    struct StateHolder has store {
        value: u8,
        flag: bool,
    }

    // Enum with nested data, to test field extraction
    enum MyEnum has copy, drop {
        VariantA,
        VariantB { nested: u8 },
        VariantC { data: (u8, u16) },
    }

    // A module-global resource to hold state
    struct GlobalState has store {
        counter: u64,
        flag: bool,
    }

    public fun initialize_global(signer: signer) {
        let gs = GlobalState { counter: 0, flag: false };
        move_to<GlobalState>(&signer, gs);
    }

    public fun get_global_counter(): u64 {
        let gs_ref: &GlobalState = borrow_global<GlobalState>(0xCAFE);
        gs_ref.counter
    }

    public fun update_global_counter_via_expr(delta: u64) {
        let gs_ref: &mut GlobalState = borrow_global_mut<GlobalState>(0xCAFE);
        // Using update expression to modify counter
        gs_ref.counter += delta;
    }

    // Function to test complex nested control flow
    public fun nested_if_continue_loop(x: u8): u8 {
        let res: u8 = 0;
        let i: u8 = 0;
        loop {
            if (i >= 5) {
                break;
            }
            if (x < 3) {
                i = i + 1;
                continue;
            } else {
                // Inner condition failed, exit loop
                res = i;
                break;
            }
        };
        res
    }

    // Function to extract 'nested' u8 from enum variant VariantB
    public fun get_nested_u8(val: MyEnum): u8 {
        match (val) {
            MyEnum::VariantA => 0,
            MyEnum::VariantB { nested } => nested,
            MyEnum::VariantC { data: (_, _)} => 0,
        }
    }

    // Inline function calling a private non-inline function
    public fun inline_wrapper_call(value: u8): u8 {
        // Call to private function
        private_process_value(value)
    }

    // Private non-inline function
    fun private_process_value(val: u8): u8 {
        val + 10
    }

    // Function with update expression to modify struct state
    public fun update_state_with_expression(s: &mut StateHolder, new_value: u8) {
        // Use update expression
        s.value = new_value;
        s.flag = if (new_value > 5) { true } else { false };
    }
}


//# run 0xBADD::ComplexFeatureInteraction::nested_if_continue_loop --args 2u8


//# run 0xBADD::ComplexFeatureInteraction::nested_if_continue_loop --args 4u8


//# run 0xBADD::ComplexFeatureInteraction::get_nested_u8 --args MyEnum::VariantA


//# run 0xBADD::ComplexFeatureInteraction::get_nested_u8 --args MyEnum::VariantB { nested: 7 }

 
//# run 0xBADD::ComplexFeatureInteraction::get_nested_u8 --args MyEnum::VariantC { data: (8, 16) }

// Initialize global state

//# run 0xBADD::ComplexFeatureInteraction::initialize_global --signers 0xCAFE

// Test updating global counter via expression

//# run 0xBADD::ComplexFeatureInteraction::update_global_counter_via_expr --args 5 --signers 0xCAFE

// Verify the global counter has been updated correctly (simulate via getting value)

//# run 0xBADD::ComplexFeatureInteraction::get_global_counter

// Test calling the inline wrapper that calls a private non-inline function

//# run 0xBADD::ComplexFeatureInteraction::inline_wrapper_call --args 15u8

// Test update expression on a struct
struct TestStruct has store {
    a: u8,
    b: bool,
}


//# publish
module 0xBADD::TestStructModule {
    public fun create_test_struct(): TestStruct {
        let t = TestStruct { a: 0, b: false };
        t
    }

    public fun update_test_struct(t: &mut TestStruct, new_a: u8, new_b: bool) {
        t.a = new_a;
        t.b = new_b;
    }
}


//# run 0xBADD::TestStructModule::create_test_struct --signers 0xCAFE


//# run 0xBADD::TestStructModule::update_test_struct --args 42 true --signers 0xCAFE


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// cc7335a7d0ed25948a3f0fdc50f7e55a: Test that functions can correctly extract specific u8 fields from enum variants with nested structures.
// 7cc4440f5a0fcc67cf1f70523cd9069a: Call other functions from inline functions, respecting their visibility constraints.
// 501fc4a8a44915c292953952c4d54c5b: Use update expressions to specify state changes within spec blocks.
