//# publish
module 0x1::TestModule {
    use std::option;

    /// Function to run a loop that breaks when a specific counter is reached
    public fun loop_with_break(limit: u64): () {
        let mut counter = 0;
        loop {
            if (counter >= limit) {
                break;
            } else {
                counter = counter + 1;
            }
        }
        // The loop should terminate once counter reaches limit
    }

    /// Function to test map over option with a side-effect
    public fun map_option_with_side_effect(opt_in: option::Option<u64>): u64 {
        // Define a mapping function that adds 5
        let result_opt = map_extension(opt_in, |e| e + 5);
        // Extract the value for verification
        if (option::is_some(&result_opt)) {
            option::extract(&mut result_opt)
        } else {
            0
        }
    }

    /// Helper function: map extension to transform option::Option<T> to Option<U>
    public fun map_extension<Element, U>(opt: option::Option<Element>, f: |Element| U): option::Option<U> {
        if (option::is_some(&opt)) {
            option::some(f(option::extract(&mut opt)))
        } else {
            option::none()
        }
    }
}

//# run
script {
    fun main() {
        // Call loop_with_break with a limit and ensure it terminates
        0x1::TestModule::loop_with_break(10);

        // Test map_option_with_side_effect with some value
        let opt_value = option::some(100);
        let result = 0x1::TestModule::map_option_with_side_effect(opt_value);
        // expect result to be 105
    }
}

//# run 0x1::TestModule::main