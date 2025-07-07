// # publish
module 0xCAFE::SpecModule {
    spec module {
        // Spec-only function for testing merging of spec and source modules
        spec fun spec_only_function(): bool {
            true
        }
    }
}

// # publish
module 0xCAFE::MainModule {
    use std::option;

    spec module {
        // Merge spec from SpecModule
        include 0xCAFE::SpecModule;

        // Define a global invariant that the stored value is always less than 100
        global invariant GlobalInvariant {
            forall addr: address where exists<0xCAFE::MainModule::Counter>(addr) : 
                (borrow_global<Counter>(addr).value < 100)
        }
    }

    struct Counter has store {
        value: u8,
    }

    public fun new_counter(): Counter {
        Counter { value: 0 }
    }

    public fun increment(counter: &mut Counter) {
        // Use variant in constructing enum value
        // We will define a helper enum here to test variant usage context
        enum Result {
            Success,
            Overflow,
        }
        // Construct Success variant
        let _res = Result::Success;

        if (counter.value == 99) {
            // This branch will "overflow"
            // Construct Overflow variant inside match expression context
            let result = match counter.value {
                99 => Result::Overflow,
                _ => Result::Success,
            };
            // Just ignore result for test
            result;
        } else {
            counter.value = counter.value + 1;
        }
    }

    #[test_only]
    public fun runner() {
        let mut c = new_counter();
        let mut i = 0;
        while (i < 10) {
            increment(&mut c);
            i = i + 1;
        }
    }
}
// # run 0xCAFE::MainModule::runner


// # run 0xCAFE::MainModule::increment --args 0x0 --signers 0xCAFE
// Actually, increment requires &mut Counter, so cannot be directly called with args or signers. Using runner above instead.

// # publish
module 0xCAFE::GlobalInvariantModule {
    // This module demonstrates GlobalInvariantUpdate usage for a counter resource.

    struct Counter has key, store {
        value: u64,
    }

    public fun create_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    public fun increment(account: &signer) {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        counter_ref.value = counter_ref.value + 1;
    }

    spec module {
        // Define a global invariant update: the counter value always increases or stays the same
        global invariant update GlobalInvariantUpdate {
            forall addr: address where exists<0xCAFE::GlobalInvariantModule::Counter>(addr):
                let c = borrow_global<Counter>(addr);
                c.value >= 0
        }
    }

    #[test_only]
    public fun test_runner(account: &signer) {
        create_counter(account);
        increment(account);
        increment(account);
    }
}
// # run 0xCAFE::GlobalInvariantModule::test_runner --signers 0xCAFE

// # publish
module 0xCAFE::EnumTest {
    enum Color {
        Red,
        Green,
        Blue,
    }

    public fun color_to_u8(color: Color): u8 {
        match color {
            Color::Red => 1,
            Color::Green => 2,
            Color::Blue => 3,
        }
    }

    #[test_only]
    public fun runner() {
        let r = color_to_u8(Color::Red);
        let g = color_to_u8(Color::Green);
        let b = color_to_u8(Color::Blue);
        // no assertion required, just test variant name usage in match and construction
        r;
        g;
        b;
    }
}
// # run 0xCAFE::EnumTest::runner


// Featurres:
// 9b8f665dbc9945450e25d345bd7379ba: Use variant names only in contexts where they are expected, such as inside match expressions or when constructing enum values
// df4601aaf1ac2edfdff685a439ef28c6: Define spec modules separately and have them merged into their corresponding source modules during compilation.
// 11cd210cb22875e7781aba2a76b1f857: Define global invariants in your Move modules using specification conditions with the GlobalInvariant or GlobalInvariantUpdate kinds.
