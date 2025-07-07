//# publish
module 0x1::test_module {
    public fun get_value_if(input: bool): u64 {
        let result: u64;
        if (input)
            result = 10;
        else
            result = 20;
        result
    }

    public fun run_if() {
        let val_true = Self::get_value_if(true);
        let val_false = Self::get_value_if(false);
        // No assertion needed, just testing variable assignment within if-else
    }
}

//# run
script {
fun main() {
    // Call the test function which tests variable assignment within if
    move_call(0x1::test_module::run_if);
}
}