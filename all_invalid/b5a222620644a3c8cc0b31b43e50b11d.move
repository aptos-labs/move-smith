//# publish
module 0xCAFE::LabelReplace {
    use std::string;

    // A simple struct to hold a label
    struct LabelHolder has store {
        label: vector<u8>,
    }

    /// Replace the label in LabelHolder if it matches old_label.
    public fun replace_label_if_match(holder: &mut LabelHolder, old_label: vector<u8>, new_label: vector<u8>) {
        if (vector::length(&holder.label) == vector::length(&old_label)) {
            let mut i = 0;
            let mut matched = true;
            while (i < vector::length(&old_label)) {
                if (*vector::borrow(&holder.label, i) != *vector::borrow(&old_label, i)) {
                    matched = false;
                    break;
                };
                i = i + 1;
            };
            if (matched) {
                holder.label = new_label;
            };
        };
    }

    /// Initialize a LabelHolder with a label
    public fun init_holder(label_bytes: vector<u8>): LabelHolder {
        LabelHolder { label: label_bytes }
    }

    /// Expose a function to get label bytes
    public fun get_label(holder: &LabelHolder): vector<u8> {
        holder.label
    }

    /// Runner function that replaces a label from "old" to "new"
    public fun runner() {
        let mut holder = init_holder(b"old_label");
        let old_label = b"old_label";
        let new_label = b"new_label";
        replace_label_if_match(&mut holder, old_label, new_label);

        // dummy usage of get_label to return unit
        let _current_label = get_label(&holder);
    }
}

//# run 0xCAFE::LabelReplace::runner


//# publish
module 0xCAFE::UnitValue {
    /// Function demonstrating unit type as a value.
    /// Returns unit type ()
    public fun return_unit(): () {
        ();
    }

    /// A function that takes unit value as argument and returns unit
    public fun accept_and_return_unit(u: ()): () {
        // do nothing
        u;
    }

    /// Runner function to test unit usage
    public fun runner() {
        let u = return_unit();
        accept_and_return_unit(u);
        ();
    }
}

//# run 0xCAFE::UnitValue::runner


//# publish
module 0xCAFE::EventEmitExample {
    use std::event;
    use std::signer;

    // Event handle to emit example events
    struct ExampleEventHolder has key {
        handle: event::EventHandle<ExampleEvent>,
    }

    struct ExampleEvent has copy, drop, store {
        id: u64,
        message: vector<u8>,
    }

    /// Initialize the event handle resource at address
    public fun init(s: signer) {
        let handle = event::new_event_handle<ExampleEvent>(&s);
        move_to<ExampleEventHolder>(&s, ExampleEventHolder { handle });
    }

    /// Emit an event unconditionally
    public fun emit_always_event(s: &signer, id: u64, message: vector<u8>) {
        let addr = signer::address_of(s);
        let holder_ref = borrow_global_mut<ExampleEventHolder>(addr);
        event::emit_event(&mut holder_ref.handle, ExampleEvent { id, message });
    }

    /// Emit an event only if condition is true
    public fun emit_conditional_event(s: &signer, id: u64, message: vector<u8>, should_emit: bool) {
        if (should_emit) {
            let addr = signer::address_of(s);
            let holder_ref = borrow_global_mut<ExampleEventHolder>(addr);
            event::emit_event(&mut holder_ref.handle, ExampleEvent { id, message });
        };
    }

    /// Emit events targeting optionally specific addresses (simulate "to")
    /// For demonstration, pass a vector of signers and emit events to those addresses.
    public fun emit_events_to(sources: vector<&signer>, ids: vector<u64>, messages: vector<vector<u8>>) {
        let length = vector::length(&sources);
        let mut i = 0;
        while (i < length) {
            let s_ref = *vector::borrow(&sources, i);
            let id = *vector::borrow(&ids, i);
            let message = vector::borrow(&messages, i);
            let addr = signer::address_of(&s_ref);
            if (!exists<ExampleEventHolder>(addr)) {
                let handle = event::new_event_handle<ExampleEvent>(&s_ref);
                move_to<ExampleEventHolder>(&s_ref, ExampleEventHolder { handle });
            };
            let holder_ref = borrow_global_mut<ExampleEventHolder>(addr);
            event::emit_event(&mut holder_ref.handle, ExampleEvent { id, message: vector::copy(message) });
            i = i + 1;
        };
    }

    public fun runner(s: signer, s2: signer) {
        init(s);
        emit_always_event(&s, 1, b"always");

        init(s2);
        emit_conditional_event(&s2, 2, b"conditional_true", true);
        emit_conditional_event(&s2, 3, b"conditional_false", false);

        let sources = vector[$&s, $&s2];
        let ids = vector[10u64, 20u64];
        let messages = vector[b"to_s", b"to_s2"];
        emit_events_to(sources, ids, messages);
    }
}

//# run 0xCAFE::EventEmitExample::runner --signers 0xB0B0 0xB0B1

// Featurres:
// 1c096f88d168928afa3141f36fa77b81: Replace labels with a new label if they match a specified label
// 59d0366e034fa8533bb30a594ea89ad2: Use unit type as a value.
// 38fafb719aeb13b8c89946422b7507a2: Declare 'emits' conditions with optional 'to' and 'if' clauses to specify event emissions and associated conditions.
