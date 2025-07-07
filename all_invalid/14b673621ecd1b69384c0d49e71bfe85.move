
//# publish
module 0xCAFE::ConditionalEvents {
    use std::signer;
    use std::event;

    struct ConditionalEvent has store, drop, copy {
        id: u64,
        flag: bool,
    }

    struct EventHolder has key {
        counter: u64,
    }

    // Declare an event handle for ConditionalEvent
    struct EventHandleHolder has key {
        event_handle: event::EventHandle<ConditionalEvent>,
    }

    public fun create_holder(s: signer) {
        let addr = signer::address_of(&s);
        assert!(!exists<EventHolder>(addr), 1);
        move_to<EventHolder>(&s, EventHolder { counter: 0 });
        move_to<EventHandleHolder>(&s, EventHandleHolder { event_handle: event::new_event_handle<ConditionalEvent>(s) });
    }

    // Emit event if condition true
    public fun emit_if_true(s: signer, flag: bool) acquires EventHolder, EventHandleHolder {
        let addr = signer::address_of(&s);
        let holder_ref: &mut EventHolder = borrow_global_mut<EventHolder>(addr);
        let events_ref: &mut EventHandleHolder = borrow_global_mut<EventHandleHolder>(addr);

        let id = holder_ref.counter;
        holder_ref.counter = holder_ref.counter + 1;

        // Use Self alias
        let event = Self::ConditionalEvent {id, flag};

        // Emit only if flag is true, using if-else expression
        if (flag) {
            event::emit_event(&mut events_ref.event_handle, event);
        } else {
            // do nothing otherwise
        };
    }

    // Emit event with emits specification that has an if condition expression
    // emits(ConditionalEvent if flag)]
    public fun conditional_emit(s: signer, flag: bool) acquires EventHolder, EventHandleHolder {
        let addr = signer::address_of(&s);
        let holder_ref: &mut EventHolder = borrow_global_mut<EventHolder>(addr);
        let events_ref: &mut EventHandleHolder = borrow_global_mut<EventHandleHolder>(addr);

        let id = holder_ref.counter;
        holder_ref.counter = holder_ref.counter + 1;

        let event = ConditionalEvent {id, flag};

        if (flag) {
            event::emit_event(&mut events_ref.event_handle, event);
        } else {
            // no event emitted here
        };
    }

    // Runner function that executes some conditional emits
    public fun runner(s: signer) acquires EventHolder, EventHandleHolder {
        Self::emit_if_true(s, true);
        Self::emit_if_true(s, false);
        Self::conditional_emit(s, true);
        Self::conditional_emit(s, false);
    }
}



//# run 0xCAFE::ConditionalEvents::create_holder --signers 0xB0B0



//# run 0xCAFE::ConditionalEvents::runner --signers 0xB0B0


// Features:
// f020765f96160effa4351ae0e6b2c22f: Create conditional expressions with 'if-else' branches.
// 7688cafabb76f60e6773ae8d43c5b5b0: Use 'emits' specifications to specify events emitted and optionally conditional on expressions.
// a60015dc7c487510d19962daab6340cd: Refer to the current module using the special alias 'Self' within the module's own code.
