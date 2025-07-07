
//# publish
module 0xCAFE::TestModule {
    public fun runner() {
        // No-op, used to invoke the module if needed
    }
}



//# run 0xCAFE::TestModule::runner



//# run
script {
    fun main() {
        // 1. Test variable assignment within if-else and its value after
        let x = 0;
        if (true) {
            let y = 42;
            x = y; // Assign within if branch
        } else {
            let y = 99;
            x = y; // Assign within else branch
        }
        // At this point, x should be 42, from the if branch

        // 2. Test loop with unconditional return
        let res = 0;
        loop {
            // simulate a condition that causes return
            return;
            // subsequent code should not be executed
            res = 1;
        };
        // code beyond loop (if any) is not reached
    }
}


//# run

// Features:
// c33a429a40f19f299f04ce6f4fed9a08: Test that variables can be assigned within an if-else statement and retain the correct value after the conditional branch.
// 650b6e522bbae7e7f11a9e9311ad53c4: Test that a loop with an unconditional return inside its body correctly exits the loop and the function without executing subsequent code.
// bce76d7eb4e4a72455e298b5a2a97100: Write boolean literals 'true' and 'false'.
