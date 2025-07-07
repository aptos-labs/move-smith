//# publish
module 0xabc::multi_update {

    fun update_accumulator(acc: &mut u64, delta: u64) {
        *acc = *acc + delta;
    }

    fun perform_multiple_updates(): u64 {
        let total = 0;
        let mut total_ref = &mut total;
        update_accumulator(total_ref, 10);
        update_accumulator(total_ref, 20);
        update_accumulator(total_ref, 30);
        total
    }

    public fun run(): u64 {
        perform_multiple_updates()
    }

}

//# run 0xabc::multi_update::run

//# publish
module 0xdef::closures_test {

    fun conditional_closure(flag: bool): (|u64| -> u64) {
        if (flag) {
            |x| x + 1
        } else {
            |x| x * 2
        }
    }

    fun evaluate_closures(): bool {
        let incr = conditional_closure(true);
        let dbl = conditional_closure(false);
        let result1 = incr(5);
        let result2 = dbl(5);
        result1 == 6 && result2 == 10
    }

    public fun run(): bool {
        evaluate_closures()
    }
}

//# run 0xdef::closures_test::run

//# publish
module 0x123::enum_pattern {

    enum Status has drop {
        Success { code: u64 },
        Error { message: string },
        Pending
    }

    fun check_success(status: Status): bool {
        (status is Success)
    }

    fun test_multiple_variants(): bool {
        let s1 = Status::Success { code: 0 };
        let s2 = Status::Error { message: "fail".to_string() };
        let s3 = Status::Pending;
        (s1 is Success) && (s2 is Error) && (s3 is Pending)
    }

}

//# run 0x123::enum_pattern::check_success
//# run 0x123::enum_pattern::test_multiple_variants