//# publish
module 0xCAFE::Module1 {
    // This module tests sum computation using a loop and if-else branching

    public fun test1(): u64 {
        let i = 10u64;
        let sum = 0u64;
        test1_loop(i, sum)
    }

    fun test1_loop(i: u64, sum: u64): u64 {
        if (i == 0) {
            sum
        } else {
            let sum = if (i == 5) {
                sum + i * 2
            } else {
                sum + i
            };
            test1_loop(i - 1, sum)
        }
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

    // Move doesn't allow duplicate abilities, so define structs with duplicates to produce error.
    // The syntax must be correct for the compiler to parse 'with' keyword.

    struct S1 with copy, copy { 
        dummy_field: u8,
    }

    struct S2 with store, key, key {
        dummy2: u8,
    }

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