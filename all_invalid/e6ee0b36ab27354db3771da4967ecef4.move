
//# publish
module 0xBADA::TestInteraction {
    use std::signer;
    use std::vector;

    // Internal struct for shadowing tests
    struct ShadowStruct has copy, drop, store {
        value: u64,
    }

    // Public struct for struct field modification test
    struct DataStruct has store, key {
        counter: u64,
        flag: bool,
    }

    // Enum for control flow testing
    enum ControlEnum has copy, drop {
        Variant1,
        Variant2(u8),
        Variant3 { done: bool }
    }

    // Internal function that is only callable within this module
    fun internal_compute(x: u64, y: u64): u64 {
        x + y
    }

    // Function to test variable assignment outside and inside while loop
    public fun variable_scoping_test(init_value: u64): u64 {
        let total = init_value;
        let temp = 0u64; // Declare outside loop, mutable

        // outer loop for multiple iterations
        while (total < 100) {
            // Shadowing: declare variable with same name inside the block
            let total = total + 10;
            // Block inside while to modify struct
            let data = DataStruct { counter: total, flag: false };
            {
                // Mutable reference to struct field
                let data_ref: &mut DataStruct = &mut data;
                // Modify counter
                data_ref.counter = data_ref.counter + 1;
            };
            // Update total with data.counter value
            total = data.counter;
            // Assign to temp variable inside loop
            temp = total;
        };
        // After loop, total should be at least 100 or more
        total + temp
    }

    // Function to test conditional logic with IfElse
    public fun conditional_logic(x: u8): u8 {
        let result = if (x % 2 == 0) {
            // True branch
            x + 1
        } else {
            // Else branch
            x + 2
        }; // End of if expression
        result
    }

    // Function to test shadowing and control flow with enum pattern match
    public fun enum_control_flow(val: u8): u64 {
        let enum_val = if (val % 3 == 0) {
            ControlEnum::Variant1
        } else if (val % 3 == 1) {
            ControlEnum::Variant2(val)
        } else {
            ControlEnum::Variant3 { done: true }
        }; // End of if-else expression
        let result = match enum_val {
            ControlEnum::Variant1 => 1,
            ControlEnum::Variant2(n) => n as u64,
            ControlEnum::Variant3 { done } => if (done) { 99 } else { 0 },
        };
        result
    }

    // Function to test internal visibility and access restrictions
    public fun internal_test(s: signer): u64 {
        // Call an internal function
        let sum = internal_compute(5, 10);
        // Use struct
        let obj = DataStruct { counter: sum, flag: true };
        // borrow the struct mutably
        let obj_ref: &mut DataStruct = &mut obj;
        obj_ref.counter = obj_ref.counter + 100;
        obj_ref.counter
    }

    // Function to test while loop with inline block modifying struct field
    public fun modify_struct_in_loop(s: signer): u64 {
        let s_obj = DataStruct { counter: 0, flag: false };
        let i: u64 = 0u64;

        while (i < 5) {
            {
                // Inline block modifying struct
                let s_ref: &mut DataStruct = &mut s_obj;
                s_ref.counter = s_ref.counter + i;
            };
            i = i + 1;
        };
        s_obj.counter
    }
}



//# run 0xBADA::TestInteraction::variable_scoping_test --signers 0xDEAD --args 0u64



//# run 0xBADA::TestInteraction::conditional_logic --args 3u8



//# run 0xBADA::TestInteraction::enum_control_flow --args 3u8



//# run 0xBADA::TestInteraction::internal_test --signers 0xFEED



//# run 0xBADA::TestInteraction::modify_struct_in_loop --signers 0xC0FF
