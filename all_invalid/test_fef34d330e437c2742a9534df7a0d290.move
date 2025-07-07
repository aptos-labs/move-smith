//# publish
module 0x99::Parity {

    /// Recursive function to determine if a number is odd.
    fun odd(x: u64): bool {
        if (x == 0) {
            false
        } else {
            even(x - 1)
        }
    }

    /// Recursive function to determine if a number is even.
    fun even(x: u64): bool {
        if (x == 0) {
            true
        } else {
            odd(x - 1)
        }
    }

    /// Function to check that parity functions produce expected results for 5 and 4.
    public fun parity_check() {
        assert!(odd(5), 0);
        assert!(!odd(4), 0);
        assert!(even(4), 0);
        assert!(!even(5), 0);
    }

}

//# run 0x99::Parity::parity_check

//# publish
module 0x88::ArithmeticSeq {

    /// This module tests the correct processing of a sequence of addition and subtraction commands,
    /// maintaining the calculator state across multiple operations.
    use 0x1::signer::address_of;

    /// States for the calculator
    enum CalcState has key {
        Empty,
        Value(u64),
        PendingOp(char), // '+' or '-'
    }

    /// Initialize the calculator state to empty.
    public fun init(s: &signer) {
        move_to(s, CalcState::Empty)
    }

    /// Process number input, considering current state.
    fun input_number(s: &signer, num: u64) {
        let addr = address_of(s);
        match (&mut move_from<CalcState>(addr)) {
            // If empty, set value
            Empty => move_to(s, CalcState::Value(num)),
            // If pending operation, perform it
            PendingOp(op) => {
                let current_value = match (&move_from<CalcState>(addr)) {
                    Value(v) => *v,
                    _ => abort(0),
                };
                let new_value = if (*op == '+') {
                    storable_add(current_value, num)
                } else {
                    storable_sub(current_value, num)
                };
                move_to(s, CalcState::Value(new_value))
            },
            // If value exists without pending op, replace value.
            Value(_) => move_to(s, CalcState::Value(num)),
        }
    }

    /// Process addition command.
    fun add(s: &signer) {
        let addr = address_of(s);
        move_to(s, CalcState::PendingOp('+'))
    }

    /// Process subtraction command.
    fun sub(s: &signer) {
        let addr = address_of(s);
        move_to(s, CalcState::PendingOp('-'))
    }

    /// View current calculator value.
    fun view(s: &signer): u64 {
        let state = &State::0x88::ArithmeticSeq::CalcState::at(address_of(s));
        match (state) {
            &CalcState::Value(v) => v,
            _ => abort(0),
        }
    }

    #[persistent]
    fun storable_add(x: u64, y: u64): u64 {
        x + y
    }

    #[persistent]
    fun storable_sub(x: u64, y: u64): u64 {
        x - y
    }
}

//# run 0x88::ArithmeticSeq::init --signers 0x88

//# run 0x88::ArithmeticSeq::input_number --signers 0x88 --args 10

//# run 0x88::ArithmeticSeq::add --signers 0x88

//# run 0x88::ArithmeticSeq::input_number --signers 0x88 --args 20

//# run 0x88::ArithmeticSeq::sub --signers 0x88

//# run 0x88::ArithmeticSeq::input_number --signers 0x88 --args 5

//# run 0x88::ArithmeticSeq::view --signers 0x88