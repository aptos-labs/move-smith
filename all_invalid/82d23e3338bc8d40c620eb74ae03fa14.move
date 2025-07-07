//# publish
module 0xCAFE::Calculator {
    use std::signer;
    use std::option;

    // Store state at signer address representing previous number and possibly unfinished operation
    struct State has store, key {
        prev: u64,
        // Optionally hold an unfinished operation as continuation (function pointer and right operand)
        // We store operation as an enum to simulate a function continuation in a storable way.
        operation: option::Option<Operation>,
    }

    // Enum representing possible binary operations
    enum Operation has copy, drop {
        Add,
        Sub,
        Mul,
        Div,
    }

    // Helper to apply operation and produce result
    fun apply_operation(op: &Operation, left: u64, right: u64): u64 {
        match *op {
            Operation::Add => left + right,
            Operation::Sub => left - right,
            Operation::Mul => left * right,
            Operation::Div => {
                // To avoid division by zero, just return 0
                if (right == 0) {
                    0
                } else {
                    left / right
                }
            }
        }
    }

    // Initialize state at signer address
    public fun initialize(s: signer) {
        let state = State {
            prev: 0,
            operation: option::none<Operation>(),
        };
        move_to<State>(&s, state);
    }

    // Input number - either starts or completes operation
    public fun input_number(s: signer, n: u64) {
        let addr = signer::address_of(&s);
        // If no state exists, initialize first
        if (!exists<State>(addr)) {
            Self::initialize(s);
        };
        let state_ref: &mut State = borrow_global_mut<State>(addr);
        let opt_op = &state_ref.operation;
        if (option::is_none(opt_op)) {
            // No unfinished operation, just set prev to n
            state_ref.prev = n;
        } else {
            // Unfinished operation present - apply it to prev and n, then clear operation
            let op = option::borrow(opt_op);
            let result = apply_operation(op, state_ref.prev, n);
            state_ref.prev = result;
            state_ref.operation = option::none<Operation>();
        };
    }

    // Input operation - if operation is unfinished, override it (simulate overwrite)
    public fun input_operation(s: signer, op_code: u8) {
        let addr = signer::address_of(&s);
        if (!exists<State>(addr)) {
            Self::initialize(s);
        };
        let state_ref: &mut State = borrow_global_mut<State>(addr);
        let op = match op_code {
            0 => Operation::Add,
            1 => Operation::Sub,
            2 => Operation::Mul,
            3 => Operation::Div,
            _ => {
                // default Add if invalid code (simulate error recovery)
                Operation::Add
            }
        };
        state_ref.operation = option::some<Operation>(op);
    }

    // Retrieve current result
    public fun get_result(s: signer): u64 {
        let addr = signer::address_of(&s);
        if (!exists<State>(addr)) {
            0
        } else {
            let state_ref: &State = borrow_global<State>(addr);
            state_ref.prev
        }
    }

    // Runner function to do a sequence: 5 + 3 * 2
    public fun runner(s: signer) {
        // input 5
        Self::input_number(s, 5);
        // input +
        Self::input_operation(s, 0);
        // input 3  => 5+3=8
        Self::input_number(s, 3);
        // input *
        Self::input_operation(s, 2);
        // input 2  => 8*2=16
        Self::input_number(s, 2);
        let _ = Self::get_result(s);
    }

    // Another runner for unfinished operation (input number but no second number yet)
    public fun runner_unfinished(s: signer) {
        Self::input_number(s, 10);
        Self::input_operation(s, 1);
        // leave operation unfinished to test
    }

    // Leaf expression and pure call test
    public fun pure_expression_test(): u64 {
        let a = 5u64;
        let b = 10u64;
        let c = a * b;
        let d = a + b + c;
        // Return composited pure expression result
        d
    }
}

//# run 0xCAFE::Calculator::initialize --signers 0xBEEF

//# run 0xCAFE::Calculator::input_number --signers 0xBEEF --args 7u64

//# run 0xCAFE::Calculator::input_operation --signers 0xBEEF --args 0u8

//# run 0xCAFE::Calculator::input_number --signers 0xBEEF --args 8u64

//# run 0xCAFE::Calculator::get_result --signers 0xBEEF

//# run 0xCAFE::Calculator::runner --signers 0xBEEF

//# run 0xCAFE::Calculator::runner_unfinished --signers 0xBEEF

//# run 0xCAFE::Calculator::pure_expression_test

// Featurres:
// 105240eba999fba383357bd97206f301: Test that the calculator correctly handles sequential number and operation inputs stored as stateful transactions, including intermediate unfinished operations using storable function continuations.
// e0857c203b7fb353aa193912b35ecaf7: Write Move expressions that are guaranteed to be free of side effects by using only leaf expressions or pure calls.
// fdb7f6ecdbc852ab25ffb09c061d4cd5: Receive diagnostic reports for errors and warnings during compilation
