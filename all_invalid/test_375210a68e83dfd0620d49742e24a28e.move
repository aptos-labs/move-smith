//# publish
module 0xAB::NestedInlineFunctionTest {
    public inline fun f3(x: u64): u64 {
        x + 10
    }

    public inline fun f4(y: u64): u64 {
        y * 2
    }
}

//# publish
module 0xAB::NestedInlineTestMain {
    use 0xAB::NestedInlineFunctionTest;

    public fun compute_final(): u64 {
        // Apply f4 to 5, then pass the result to f3
        NestedInlineFunctionTest::f3(NestedInlineFunctionTest::f4(5))
    }

    public fun main(): u64 {
        compute_final()
    }
}

//# run 0xAB::NestedInlineTestMain::main

//# publish
module 0xAB::VectorAggregate {
    use std::vector;

    public inline fun accumulate_sum(v: &vector<u64>): u64 {
        let total = 0;
        let i = 0;
        while (i < vector::length(v)) {
            total = total + *vector::borrow(v, i);
            i = i + 1;
        }
        total
    }

    public fun test_vector(): u64 {
        let v = vector[4u64, 7, 1, 3, 6];
        accumulate_sum(&v)
    }
}

//# run 0xAB::VectorAggregate::test_vector