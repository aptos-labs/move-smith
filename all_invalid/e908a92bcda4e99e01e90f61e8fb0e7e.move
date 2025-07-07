//# publish
module 0x1::StateFormatter {
    use std::string;
    use std::vector;

    struct StateInfo has copy, drop, store {
        address: address,
        value: u64,
        flag: bool,
    }

    /// Format a single StateInfo to human-readable string
    public fun format_state(state: &StateInfo): string::String {
        let add_str = string::utf8(address_to_bytes(state.address));
        let val_str = u64_to_string(state.value);
        let flag_str = if (state.flag) { "true" } else { "false" };
        string::concat(
            &string::concat(
                &string::concat(&add_str, ":"),
                &string::concat(&val_str, ",")
            ),
            &flag_str
        )
    }

    /// Format vector of StateInfo before a code offset
    public fun format_before(states: &vector<StateInfo>, offset: u64): string::String {
        let len = vector::length(states);
        let mut res = string::utf8(b"Before Offset ");
        res = string::concat(&res, &u64_to_string(offset));
        res = string::concat(&res, b": ");
        let mut i = 0;
        while (i < len) {
            let s = format_state(&vector::borrow(states, i));
            res = if (i == 0) { s } else { string::concat(&res, &string::concat(b"; ", &s)) };
            i = i + 1;
        }
        res
    }

    /// Format vector of StateInfo after a code offset
    public fun format_after(states: &vector<StateInfo>, offset: u64): string::String {
        let len = vector::length(states);
        let mut res = string::utf8(b"After Offset ");
        res = string::concat(&res, &u64_to_string(offset));
        res = string::concat(&res, b": ");
        let mut i = 0;
        while (i < len) {
            let s = format_state(&vector::borrow(states, i));
            res = if (i == 0) { s } else { string::concat(&res, &string::concat(b"; ", &s)) };
            i = i + 1;
        }
        res
    }

    /// Helper u64 to string function (simple, no decimals)
    fun u64_to_string(u: u64): string::String {
        // A simple u64 to string assuming basic decimal conversion
        // For brevity using std::string::utf8 with just dummy conversion (normally require own implementation)
        // (NOTE: Here we simulate conversion by just using b"number" placeholder since no standard fmt in Move.)
        string::utf8(b"u64_value")
    }

    /// Helper to convert address to bytes vector
    fun address_to_bytes(addr: address): vector<u8> {
        // Convert to vector<u8> for string concat
        // addr is 16 bytes, but we will just represent as hex string bytes, 
        // here simplifying to just some bytes to simulate.
        vector::empty<u8>()
    }

    /// A runner function to test formatting with sample data
    public fun runner(): string::String {
        let state1 = StateInfo { address: @0x1, value: 100, flag: true };
        let state2 = StateInfo { address: @0x2, value: 200, flag: false };
        let before = vector::empty<StateInfo>();
        vector::push_back(&mut before, state1);
        vector::push_back(&mut before, state2);
        let after = vector::empty<StateInfo>();
        vector::push_back(&mut after, state2);
        let state3 = StateInfo { address: @0x3, value: 300, flag: true };
        vector::push_back(&mut after, state3);
        let before_str = format_before(&before, 123);
        let after_str = format_after(&after, 123);
        let res = string::concat(&before_str, &string::concat(b" | ", &after_str));
        res
    }
}


//# run 0x1::StateFormatter::runner


//# publish
module 0x1::NestedBindingsTest {

    /// Test nested block-scoped bindings, swaps, and additive computations
    public fun test_nested(): u64 {
        let mut total = 0;

        let mut a = 10;
        let mut b = 20;
        {
            // Inner block 1
            let mut a = a + 5;       // 15
            let mut b = b + 10;      // 30
            total = total + a + b;   // 45
            {
                // Inner block 2
                let temp = a;
                let a = b;
                let b = temp;
                total = total + a + b; // swap effect: total += 30 + 15 = 45 + previous = 90
            }
            total = total + a + b;   // unchanged within this block: 15 + 30 = 45 + 90 = 135
        }
        // Outer variables unchanged
        total = total + a + b;       // 10 + 20 = 30 + 135 = 165

        total
    }
}

//# run 0x1::NestedBindingsTest::test_nested


//# publish
module 0x1::ModTracking {

    use std::string;
    use std::vector;

    struct Data has store, copy, drop {
        x: u64,
        y: u64,
    }

    struct ParamVars has store, copy, drop {
        a: u64,
        b: u64,
    }

    struct FreeVars has store, copy, drop {
        f1: u64,
        f2: u64,
    }

    struct ModificationTracker has store {
        original: Data,
        modified: Data,
        params: ParamVars,
        frees: FreeVars,
    }

    /// Initialize the tracker with data, params, frees
    public fun init_tracker(data: Data, params: ParamVars, frees: FreeVars): ModificationTracker {
        ModificationTracker {
            original: data,
            modified: data,
            params,
            frees,
        }
    }

    /// Modify the tracked data by adding params and frees to original, store in modified
    public fun modify(tracker: &mut ModificationTracker) {
        tracker.modified.x = tracker.original.x + tracker.params.a + tracker.frees.f1;
        tracker.modified.y = tracker.original.y + tracker.params.b + tracker.frees.f2;
    }

    /// Runner test function that initializes, modifies, and returns sum of modified values
    public fun runner(): u64 {
        let data = Data { x: 10, y: 20 };
        let params = ParamVars { a: 1, b: 2 };
        let frees = FreeVars { f1: 100, f2: 200 };
        let mut tracker = init_tracker(data, params, frees);
        modify(&mut tracker);
        tracker.modified.x + tracker.modified.y
    }
}

//# run 0x1::ModTracking::runner