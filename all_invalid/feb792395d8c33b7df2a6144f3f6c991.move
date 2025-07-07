
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


//# run 0xCAFE::TestModule::setup_logging_for_testing

//# run 0xCAFE::TestModule::match_color --args 0xCAFE::TestModule::Color::Green

//# run 0xCAFE::TestModule::mutate_counter --signers 0xCAFE --args 10u64

// Featurres:
// 0233277df011affba57cf78b41a239aa: Call setup_logging_for_testing to configure logging during testing.
// 2db1da29c6dc859b43fbb2209a123301: Match on enum types only within the module that defines the enum.
// 53ca1536bb4c4ff8df59f8b8a3f64323: Test mutating a struct field through a mutable reference in a loop and verify the updated value on each iteration.
