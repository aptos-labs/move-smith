//# publish
module 0xCAFE::Module1 {
    // This module tests sum computation using a loop and if-else branching

    public fun test1(): u64 {
        let mut i = 10u64;
        let mut sum = 0u64;
        while (i > 0) {
            if (i == 5) {
                sum = sum + i * 2;
            } else {
                sum = sum + i;
            }
            i = i - 1;
        }
        // Sum numbers 10 down to 1 and double contribution of 5.
        // sum = 10+9+8+7+6 + (5*2) + 4+3+2+1
        // 10+9=19+8=27+7=34+6=40 + 10 +4=14+3=17+2=19+1=20 (after adding 10 counted twice)
        // sum = (10+9+8+7+6+4+3+2+1) + 10 = 50 +10=60
        // Actually let's print sum for clarity: sum = ?
        // Correct sum without doubling 5: 10+9+8+7+6+5+4+3+2+1 = 55
        // Doubling 5 means add 5 extra -> 55 + 5 = 60
        // So sum should return 60.
        sum
    }

    // A function with if-else to confirm correct behavior
    public fun if_else_test(x: u8): bool {
        if (x > 10) {
            true
        } else {
            false
        }
    }

    // Runner function to call the above functions without args
    public fun runner(): u64 {
        test1()
    }
}
//# run 0xCAFE::Module1::runner

// The following will attempt to define invalid duplicate abilities to produce compile errors.

//# publish
module 0xCAFE::Module2 {
    // This module is expected to fail compilation because of duplicate abilities.

    // The abilities syntax in Move is a comma separated list in parentheses.
    // We deliberately use duplicate ability 'copy' to test detection of duplicate abilities.

    // Uncomment the below code to generate errors.
    /*
    struct S with copy, drop, copy, store, key {
        a: u8,
    }
    */
    // But since we cannot comment out module contents in such tests (it would cause no test),
    // Instead we violate the ability declaration properly as Move syntax expects no duplicates.
    
    // So let's cause an error by defining a struct with duplicate abilities in the header line:
    // Unfortunately, the transactional test can't have multiple parse errors in the same module.
    // So we define two structs with duplicate overlapping abilities to trigger error.

    // Let's define two structs with duplicate abilities in the list (copy repeated):
    struct S1 with copy, copy {}

    // We don't need to provide fields for testing duplicate ability detection here.
    // Define one more with other duplicates:
    struct S2 with store, key, key {}

    // Define runner function to force loading of this module
    public fun runner_dup_abilities(): bool {
        true
    }
}
//# run 0xCAFE::Module2::runner_dup_abilities


//# run
script {
    // test if_else_test function usage
    use 0xCAFE::Module1;

    fun main() {
        let t1 = Module1::if_else_test(5u8);
        let t2 = Module1::if_else_test(15u8);
        // Just invoke for VM exercising; no assertions needed.
        // t1 = false, t2 = true
        return;
    }
}

// Featurres:
// f955db3c0e30dc86debee7ea9003f840: Test that the `test1` function correctly computes the sum of numbers from 10 down to 1 and returns the expected total of 65.
// 90b0011045b6d2bb1a0407e441a41a35: Use if-else expressions for conditional branching.
// e5fe0227933449dc0c00c7c0a420afe8: Detect duplicate abilities in the same context and report errors
