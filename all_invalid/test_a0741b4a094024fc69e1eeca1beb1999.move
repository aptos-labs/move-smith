//# publish
module 0xABC::conditional_closures {

    // A helper function that returns 1 if the condition is true, otherwise returns 0
    fun check_condition(c: bool): u64 {
        if (c) 1 else 0
    }

    // Function with nested closures and conditional logic to test currying behavior
    public fun run(): bool {
        // Closure that adds 5 if the input is true, otherwise adds 10
        let closure_one = |x: bool| {
            if (x) { 5 } else { 10 }
        };

        // Closure that takes a boolean and a number, adds value depending on boolean
        let closure_two = |c: bool, num: u64| {
            if (c) { num + 100 } else { num + 200 }
        };

        // Closure that computes based on nested conditions
        let complex_closure = |c1: bool, c2: bool, val: u64| {
            if (c1) {
                if (c2) { val + 50 } else { val + 150 }
            } else {
                val
            }
        };

        // Call closure_one with true and false
        assert!(closure_one(true) == 5);
        assert!(closure_one(false) == 10);

        // Call closure_two with varying booleans and numbers
        assert!(closure_two(true, 20) == 120);
        assert!(closure_two(false, 30) == 230);

        // Call complex_closure with different boolean combinations
        assert!(complex_closure(true, true, 10) == 60);
        assert!(complex_closure(true, false, 10) == 160);
        assert!(complex_closure(false, true, 10) == 10);
        assert!(complex_closure(false, false, 10) == 10);

        true
    }
}

//# run 0xABC::conditional_closures::run
