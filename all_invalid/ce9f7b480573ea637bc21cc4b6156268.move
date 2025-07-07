
//# publish
module 0xCAFE::ControlFlowTest {
    use std::vector;

    // A simple structure to hold test data
    struct TestData has store, key {
        total: u32,
        count: u32,
        threshold: u32,
    }

    // Function to simulate a condition where control flow rules are exercised
    public fun process_value(x: u32, threshold: u32): bool {
        if (x > threshold) {
            true
        } else {
            false
        }
    }

    // Function to test control flow inside move function
    public fun control_flow_branch(x: u32, threshold: u32): u32 {
        let sum = 0u32; // Make sum mutable
        if (x % 2 == 0) {
            if (x > threshold) {
                sum = sum + x;
            } else {
                sum = sum + threshold;
            };
        } else {
            sum = sum + x;
        };
        // Use while loop to increment sum until a condition is met
        while (sum < 100) {
            sum = sum + 10;
        };
        // Loop exercising break condition
        loop {
            if (sum >= 200) {
                break;
            };
            sum = sum + 5;
        };
        sum
    }

    // Run function to initialize and exercise control flow
    public fun run_control_flow_tests() {
        let result1 = control_flow_branch(25, 20);
        let result2 = control_flow_branch(15, 30);
        let data = TestData {total: result1, count: 0, threshold: result2};
        // Consume data by unpacking since data is not used afterward and does not have 'drop'
        let TestData {total: _temp_total, count: current_count, threshold: _temp_threshold} = data;

        // Re-create data with updated count, since previous data was moved
        let data = TestData {total: result1, count: current_count, threshold: result2};
        // Update data to add count based on control flow result
        if (data.total > 150) {
            let data_mut = &mut data;
            data_mut.count = data_mut.count + 1;
        } else {
            let data_mut = &mut data;
            data_mut.count = data_mut.count + 2;
        };
        // A simple assertion to complete the test
        assert!(data.count >= 0, 999);
    }
}



//# run 0xCAFE::ControlFlowTest::run_control_flow_tests
