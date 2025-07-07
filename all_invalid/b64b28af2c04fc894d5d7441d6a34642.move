// #publish
module 0xCAFE::AbilityTest {
    use std::signer;

    // Struct with generic type parameter T constrained to have 'copy' ability
    struct CopyType<T: copy> has copy, drop, store, key {
        val: T,
    }

    // Struct with generic type parameter T constrained to have 'drop' ability
    struct DropType<T: drop> has store {
        val: T,
    }

    // Struct with generic type parameter T constrained to have 'store' ability
    struct StoreType<T: store> has store {
        val: T,
    }

    // Function to test creating CopyType and DropType and updating val within local block
    public fun test_abilities(s: &signer) {
        // instantiate CopyType with u8 (u8 is copy+drop by default)
        let mut c = CopyType<u8> { val: 1 };

        // instantiate DropType with vector<u8> (vector is drop by default)
        let mut d = DropType<vector<u8>> { val: b"abc" };

        // bind to local variable and modify inside sequence
        let mut sum = 0u64;

        // update sum inside a block and rebind mutably to sum
        {
            let temp = 5u64;
            sum = sum + temp;
        }

        // update c.val using a local block to test side-effects in evaluation
        {
            c.val = (c.val + 10);
            sum = sum + (c.val as u64);
        }

        // update d.val by assigning a new vector (simulate mutation)
        {
            d.val = b"xyz";
            sum = sum + (b"xyz"[0] as u64); // first byte of vector
        }
    }

    // Runner function that calls test_abilities with no arguments (signer must be provided in run command)
    public fun runner(s: &signer) {
        test_abilities(s);
    }
}
// # run 0xCAFE::AbilityTest::runner --signers 0xCAFE

// # run
script {
    use std::signer;
    use 0xCAFE::AbilityTest;

    fun main(account: signer) {
        // The script binds multiple values locally in sequence to test local binding
        let a = 1u64;
        let b = 2u64;
        let c = {
            let x = a + b;
            x * 2
        };

        let d = {
            let mut local_var = 0u64;
            local_var = local_var + c;
            local_var
        };

        // Run the module's runner function to test generic struct abilities and side effects
        AbilityTest::runner(&account);
    }
}

// Featurres:
// 92ccf2b0791602d9eccb6618862cfa12: Test that the `test` function correctly evaluates and sums multiple expressions with side effects, ensuring that variable assignments within blocks update the variable as expected during evaluation.
// 8212f57517317a04d52ee13b80e49762: Apply ability constraints (like 'copy', 'drop', etc.) to struct type parameters in Move.
// 3719a4bf4284b0a7fb591d83313b0aca: Bind values to local variables within a sequence.
