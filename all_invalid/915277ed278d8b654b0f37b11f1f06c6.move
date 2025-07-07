// Example fixed transactional test for Aptos Move

public script {
    fun main() {
        // Initialize a local variable outside the loop
        let counter: u64 = 0;

        while (counter < 5) {
            // Shadowing the previous variable inside the loop
            let counter: u64 = counter + 1;

            // Perform some operation (for example, log or assertions)
            // For testing purposes, we can assume some dummy operation
            // assert!(counter <= 5);
        }

        // After loop, ensure the counter is as expected
        // counter should still refer to the outer variable
        // But in Move, shadowing a variable inside a block does not affect outer variable
        assert!(counter == 0); // initial value remains unchanged
    }
}
