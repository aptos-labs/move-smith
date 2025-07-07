
//# publish
module 0xCAFE TestModule {
    use std::debug;

    // Define an enum with multiple variants for matching
    enum Color {
        Red,
        Green,
        Blue,
        Custom(u8, u8, u8),
    }

    // Struct with a mutable field
    struct Counter {
        value: u64,
    }

    // Initialize the enum and struct for testing
    public fun setup_testing(): (Color, Counter) {
        let color = Color::Red;
        let counter = Counter { value: 0 };
        (color, counter)
    }

    // Function to test matching on enum only within this module
    public fun match_color(color: &Color): u8 {
        match *color {
            Color::Red => 1,
            Color::Green => 2,
            Color::Blue => 3,
            Color::Custom(r, g, b) => (r + g + b),
        }
    }

    // Function to mutate the struct field in a loop
    public fun mutate_counter(counter: &mut Counter, times: u64): u64 {
        let i = 0;
        while (i < times) {
            counter.value = counter.value + 1;
            i = i + 1;
        }
        counter.value
    }
}


//# run 0xCAFE::TestModule::setup_testing


//# run 0xCAFE::TestModule::match_color --args 0xCAFE::TestModule::Color::Green


//# run 0xCAFE::TestModule::mutate_counter --signers 0xCAFE --args 10u64