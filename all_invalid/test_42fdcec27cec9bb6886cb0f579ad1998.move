//# publish
module 0xabcde::cyclic_test_module {
    fun cyclic(p: u64): u64 {
        // Simply return the input value to verify function correctness
        p
    }

    public fun run_cyclic_test(input: u64): u64 {
        cyclic(input)
    }
}

//# run 0xabcde::cyclic_test_module::run_cyclic_test --args 99

//# publish
module 0x12345::sum_and_assert {
    fun sum_three(a: u64, b: u64, c: u64): u64 {
        a + b + c
    }

    public fun main() {
        let total = sum_three(10, 20, 30);
        assert!(total == 60, 0);
    }
}

//# run 0x12345::sum_and_assert::main

//# publish
module 0x67890::addition {
    public inline fun add(x: u64, y: u64): u64 {
        x + y
    }

    public fun compute() {
        let a = 55;
        let b = 45;
        let result = add(a, b);
        // store or manipulate result if needed (here just for coverage)
        assert!(result == 100, 1);
    }
}

//# run 0x67890::addition::compute --signers 0x1 --args