//# publish
module 0x1::TestModule {
    use std::debug;

    // Function to compute sum of three local variables and assert correctness
    public fun main() {
        let a = 10;
        let b = 20;
        let c = 30;
        let sum = a + b + c; // sum should be 60
        assert(sum == 60, 0); // assertion passes
        
        // Demonstrate pattern matching with '..' in destructuring
        let (x, y, ..) = (1, 2, 3, 4); // ignore remaining values
        debug::print(&x); // should print 1
        debug::print(&y); // should print 2

        // Test dot notation: variable assignment via dot
        let mut obj = {
            value: 5,
            ..Default::default()
        };
        // access and assign via dot
        obj.value = obj.value + 5; // should be 10
        debug::print(&obj.value);
    }

    // Function to apply a provided function repeatedly
    public fun apply_repeatedly<T>(
        initial: T, 
        times: u64, 
        func: &fn(T) -> T
    ): T {
        let mut result = initial;
        let mut count = 0;
        while (count < times) {
            result = func(result);
            count = count + 1;
        }
        result
    }

    // Runner function for apply_repeatedly
    public fun run_apply() {
        // Define a simple increment function
        fun increment(x: u64): u64 {
            x + 1
        }
        let initial_value = 0u64;
        let times = 5;
        let final_value = apply_repeatedly(initial_value, times, &increment);
        debug::print(&final_value); // should print 5
    }
}

//# run 0x1::TestModule::main
//# run 0x1::TestModule::run_apply