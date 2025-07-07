//# publish
module 0x1::InteractionTest {
    // A helper module with a function that returns 100 if a condition is true
    public fun get_value(flag: bool): u64 {
        if (flag) {
            return 100;
        }
        0
    }

    // A function that calls get_value internally and adds 50 if the returned value is 100
    public fun combined_function(flag: bool): u64 {
        let val = get_value(flag);
        if (val == 100) {
            return val + 50;
        }
        val
    }
}

//# run
script {
use 0x1::InteractionTest;

fun main() {
    // Call with true to test the branch where get_value returns 100
    assert!(InteractionTest::combined_function(true) == 150, 1);
    // Call with false to test the branch where get_value returns 0
    assert!(InteractionTest::combined_function(false) == 0, 2);
}
}