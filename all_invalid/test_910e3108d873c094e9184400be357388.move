//# publish
module 0xxyz::nested_match_control_flow {
    enum Status has drop {
        Active,
        Inactive { reason: u64 },
        Suspended { duration: u64, detail: Option<u64> }
    }

    enum ResponseCode {
        Success,
        Error(u64),
        Retry { attempts: u64 }
    }

    // Function with nested matches to test edge cases and control flow
    inline fun get_status_code(status: &Status): u64 {
        match (status) {
            Status::Active => 1,
            Status::Inactive { reason } => match (reason) {
                0 => 10,
                r if *r > 0 => match (status) {
                    Status::Inactive { reason: r2 } if *r2 == *reason => 20,
                    _ => 30,
                },
            },
            Status::Suspended { duration, detail } => match (detail) {
                Option::Some(d) if *d == 42 => match (duration) {
                    d if *d > 100 => 40,
                    _ => 50,
                },
                Option::None => 60,
                _ => 70,
            },
        }
    }

    // Function to test nested match control flow with different status scenarios
    public fun test_status_scenarios(): u64 {
        let s1 = Status::Active;
        let s2 = Status::Inactive { reason: 0 };
        let s3 = Status::Inactive { reason: 99 };
        let s4 = Status::Suspended { duration: 150, detail: Option::Some(42) };
        let s5 = Status::Suspended { duration: 50, detail: Option::Some(42) };
        let s6 = Status::Suspended { duration: 200, detail: Option::None };

        get_status_code(&s1) + get_status_code(&s2) + get_status_code(&s3) + get_status_code(&s4) + get_status_code(&s5) + get_status_code(&s6)
    }

    // Function with nested loops involving complex control flow and break conditions
    public fun nested_loops_with_breaks(flag: bool): u64 {
        let mut counter = 0;

        loop {
            let mut inner_counter = 0;
            loop {
                if (flag && inner_counter >= 3) {
                    break;
                };
                // Some dummy operation
                counter = counter + 1;
                inner_counter = inner_counter + 1;
            }
            if (flag && counter >= 10) {
                break;
            };
            counter = counter + 1;
        }
        counter
    }
}

//# run 0xxyz::nested_match_control_flow::test_status_scenarios

//# run 0xxyz::nested_match_control_flow::nested_loops_with_breaks --args true