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
        let mut i = 0u8;
        loop {
            if (i == 5) {
                return; // exit the script successfully in loop
            }
            i = i + 1;
        }
    }
}