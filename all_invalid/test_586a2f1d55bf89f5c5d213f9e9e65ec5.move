//# publish
module 0xA11::counter_module {
    use 0x1::signer::address_of;

    const EINVALID_STATE: u64 = 2;

    /// Counter states
    enum CounterState has key {
        Initialized,
        Count(u64),
        Reset,
    }

    /// Initializes counter to zero
    fun init_counter(s: &signer) {
        move_to(s, CounterState::Initialized)
    }

    /// Increment the counter by 1
    fun increment(s: &signer) acquires CounterState {
        let addr = address_of(s);
        match (&mut move_from<CounterState>(addr)) {
            (Initialized | Reset) => {
                move_to(s, CounterState::Count(1))
            },
            (Count(current)) => {
                *current = *current + 1;
                move_to(s, CounterState::Count(*current))
            },
            _ => abort EINVALID_STATE,
        }
    }

    /// Decrement the counter by 1
    fun decrement(s: &signer) acquires CounterState {
        let addr = address_of(s);
        match (&mut move_from<CounterState>(addr)) {
            (Count(current)) => {
                if (*current > 0) {
                    *current = *current - 1;
                    move_to(s, CounterState::Count(*current))
                } else {
                    abort EINVALID_STATE;
                }
            },
            (Initialized | Reset) => abort EINVALID_STATE,
        }
    }

    /// Reset the counter
    fun reset(s: &signer) acquires CounterState {
        move_to(s, CounterState::Reset)
    }

    /// View current counter value
    fun view(s: &signer): u64 acquires CounterState {
        match (&State[address_of(s)]) {
            Count(x) => *x,
            _ => abort EINVALID_STATE,
        }
    }
}

//# run 0xA11::counter_module::init_counter --signers 0xA11

//# run 0xA11::counter_module::increment --signers 0xA11

//# run 0xA11::counter_module::view --signers 0xA11

//# run 0xA11::counter_module::increment --signers 0xA11

//# run 0xA11::counter_module::view --signers 0xA11

//# run 0xA11::counter_module::reset --signers 0xA11

//# run 0xA11::counter_module::view --signers 0xA11

//# run 0xA11::counter_module::decrement --signers 0xA11

//# run 0xA11::counter_module::view --signers 0xA11