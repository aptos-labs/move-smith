//# publish
module 0xCAFE::Calculator {
    resource struct Calc {
        value: u64,
    }

    public fun new(): Calc {
        Calc { value: 0 }
    }

    public fun add(calc: &mut Calc, operand: u64) {
        calc.value = calc.value + operand;
    }

    public fun subtract(calc: &mut Calc, operand: u64) {
        calc.value = calc.value - operand;
    }

    public fun get_value(calc: &Calc): u64 {
        calc.value
    }
}

//# publish
module 0xCAFE::Diagnostics {
    // A simple diagnostic collector
    resource struct Diag {
        diagnostics: vector<vector<u8>>, // storing messages as byte vectors
    }

    public fun new(): Diag {
        Diag { diagnostics: vector::empty<vector<u8>>() }
    }

    public fun add_diag(diag: &mut Diag, message: vector<u8>) {
        vector::push_back(&mut diag.diagnostics, message);
    }

    public fun get_diagnostics(diag: &Diag): &vector<vector<u8>> {
        &diag.diagnostics
    }

    // Helper to render diagnostics in a combined string
    public fun render(diag: &Diag): vector<u8> {
        let output = vector::empty<u8>();
        let diags = &diag.diagnostics;

        let len = vector::length(diags);
        let mut i = 0;
        while (i < len) {
            let msg = vector::borrow(diags, i);
            let _ = vector::append(&mut output, msg);
            let _ = vector::push_back(&mut output, 10); // newline
            i = i + 1;
        }
        output
    }
}

//# run 0xCAFE::Calculator::new --signers 0xCAFE
//# run 0xCAFE::Calculator::add --signers 0xCAFE --args 10u64
//# run 0xCAFE::Calculator::add --signers 0xCAFE --args 20u64
//# run 0xCAFE::Calculator::subtract --signers 0xCAFE --args 5u64
//# run 0xCAFE::Calculator::get_value --signers 0xCAFE
//# run 0xCAFE::Diagnostics::new --signers 0xCAFE
//# run 0xCAFE::Diagnostics::add_diag --signers 0xCAFE --args b"Sequential calculation test completed.\n"
//# run 0xCAFE::Diagnostics::render --signers 0xCAFE
//# run 0xCAFE::Calculator::add --signers 0xCAFE --args 100u64
//# run 0xCAFE::Calculator::subtract --signers 0xCAFE --args 50u64
//# run 0xCAFE::Calculator::get_value --signers 0xCAFE

// Define a module to test control flow features
//# publish
module 0xCAFE::FlowTest {
    resource struct State {
        count: u64,
    }

    public fun new(): State {
        State { count: 0 }
    }

    // Function to detect control flow: loops and returns
    public fun process_with_control_flow(state: &mut State, limit: u64): bool acquires State {
        let mut i = 0;
        while (i < limit) {
            if (i == limit / 2) {
                // simulate an abort
                abort 999;
            };
            // increment the count
            state.count = state.count + 1;
            i = i + 1;
        }
        // after loop completes, return true
        true
    }

    // Function that uses conditional redirection
    public fun redirect_example(flag: bool): u64 {
        let mut result = 0;
        if (flag) {
            result = 42;
        } else {
            // mimic a loop with a return to test control flow detection
            let mut i = 0;
            while (i < 3) {
                if (i == 2) {
                    return 100;
                }
                // simulate some computation
                result = result + i;
                i = i + 1;
            }
        }
        result
    }
}

//# run 0xCAFE::FlowTest::new --signers 0xCAFE
//# run 0xCAFE::FlowTest::process_with_control_flow --signers 0xCAFE --args 10u64
//# run 0xCAFE::FlowTest::redirect_example --signers 0xCAFE --args true
//# run 0xCAFE::FlowTest::redirect_example --signers 0xCAFE --args false