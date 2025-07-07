//# publish
module 0xCAFE::TestModule {
    // 1: Function parameters separated by commas within parentheses
    public fun add_two_numbers(a: u64, b: u64): u64 {
        a + b
    }
    
    // Public runner to expose add_two_numbers for test
    public fun runner_add() : u64 {
        Self::add_two_numbers(5, 7)
    }

    // 3: The function and constant in the spec module will be merged into this implementation module via the compiler.
    // We'll access these in a function.
    public fun use_spec_members(): u64 {
        let x = Self::SPEC_CONSTANT;           // from spec module
        let y = Self::spec_add(10, 5);         // from spec module
        x + y
    }
}

//# run 0xCAFE::TestModule::runner_add
//# run 0xCAFE::TestModule::use_spec_members

spec module 0xCAFE::TestModule {
    const SPEC_CONSTANT: u64 = 42;

    fun spec_add(a: u64, b: u64): u64 {
        a + b
    }
}

//# run
script {
    use 0xCAFE::TestModule;

    // 2: loop with return in a script
    fun main() {
        let i = 0u8;
        loop {
            if (i == 5) {
                return; // exit the script successfully in loop
            }
            let i = i + 1;
        }
    }
}

// Featurres:
// cd6efccaaa22ee0f4bc4a974802d383c: Specify function parameters separated by commas within parentheses.
// 3785cb86f5fee2e959911bb4f800ad4b: Test that the `loop` expression can be used with a `return` statement in a script.
// 349826f2910b79212c4299c7a9c71329: Add members such as constants or functions to modules via spec modules and have those members merged into the implementation module.
