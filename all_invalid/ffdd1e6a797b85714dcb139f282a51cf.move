//# publish
module 0xCAFE::SpecConditions {
    use std::error;
    use std::event;
    use std::signer;

    struct E has store, drop, key {
        id: u64,
        message: vector<u8>,
    }

    struct EventHandle has store, drop {
        counter: u64,
        guid: u64,
    }

    struct Holder has store {
        value: u8,
        event_handle: event::EventHandle<E>,
    }

    public fun init_holder(s: &signer): Holder {
        let event_handle = event::new_event_handle<E>(s);
        Holder {
            value: 0,
            event_handle,
        }
    }

    #[aborts]
    public fun abort_on_even(x: u8) {
        assert!(x > 0, 1);
        if (x % 2 == 0) {
            abort 100;
        };
    }

    #[aborts_with(200u64)]
    public fun aborts_with_code(x: u8) {
        if (x == 0) {
            abort 200;
        };
    }

    #[requires(x > 0)]
    #[ensures(result > x)]
    #[modifies(holder)]
    #[emits<E>(holder.event_handle)]
    public fun modify_and_emit(holder: &mut Holder, x: u8): u8 {
        holder.value = x + 1;
        event::emit_event<E>(&mut holder.event_handle, E {id: 42, message: b"Hi"});
        holder.value
    }

    #[assume (result >= 0)]
    #[decreases(x)]
    public fun recursive_countdown(x: u8): u8 {
        if (x == 0) {
            0
        } else {
            recursive_countdown(x - 1)
        }
    }

    #[succeeds_if(holder.value > 0)]
    public fun verify_value_positive(holder: &Holder) {
        assert!(holder.value > 0, error::invalid_argument(123));
    }

}

//# run 0xCAFE::SpecConditions::abort_on_even --args 3u8

//# run 0xCAFE::SpecConditions::aborts_with_code --args 1u8

//# run 0xCAFE::SpecConditions::modify_and_emit --args 5u8 --signers 0xCAFE

//# run 0xCAFE::SpecConditions::recursive_countdown --args 3u8

//# run 0xCAFE::SpecConditions::verify_value_positive --signers 0xCAFE

// Duplicate module definition to test error on duplicate module names
//# publish
module 0xCAFE::SpecConditions {
    public fun dummy() {
    }
}

// We're intentionally not running this duplicate module publish because the previous line should fail compilation.

//# publish
module 0xCAFE::SourceMapTest {
    public fun dummy_fun(x: u8): u8 {
        if (x > 10) {
            x - 10
        } else {
            x + 10
        }
    }
}

//# run 0xCAFE::SourceMapTest::dummy_fun --args 15u8

// The source map serialization is a compiler feature and cannot be tested from Move script itself
// but compiling this module with source map enabled will associate source code accordingly.

// Featurres:
// 9b723eefafdc3c44a323bc61b31a9c2c: Attach different specification condition kinds such as assert, assume, decreases, aborts, aborts with, succeeds if, modifies, emits, ensures, and requires to your Move code to specify behavior.
// b624817f176acbc46aef772f9a0cdaed: Receive an error when defining two modules with the same name in a Move package.
// 0425835c5696d42eaaf7333cc1c87345: Serialize source maps when requested, associating source code with compiled units.
