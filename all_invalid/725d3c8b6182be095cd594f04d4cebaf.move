
//# publish
module 0xCAFE::UpdateSpecTest {
    use std::vector;

    struct Counter has copy, drop, store {
        value: u64,
    }

    spec module {
        update counters;
    }

    public fun initialize(): vector<Counter> {
        let counters = vector::empty<Counter>();
        let c1 = Counter { value: 0 };
        let c2 = Counter { value: 10 };
        vector::push_back(&mut counters, c1);
        vector::push_back(&mut counters, c2);
        counters
    }

    spec initialize {
        update counters;
    }

    public fun increment(counters: &mut vector<Counter>, idx: u64) {
        let len = vector::length(counters) as u64;
        if (idx < len) {
            let c = vector::borrow_mut(counters, idx as u64);
            c.value = c.value + 1;
        };
    }

    spec increment {
        update counters;
    }

    public inline fun f2(a: u16): (u16, u16) {
        (a + 3, a + 7)
    }

    public fun f1(x: u8, y: bool): u8 {
        if (y) {
            let _a = 10;
        } else {
            let _b = 20;
        };
        // simple loop to add 2 to x three times
        let result = x;
        let i = 0;
        while (i < 3) {
            result = result + 2;
            i = i + 1;
        };
        result
    }

    // The main function that calls f2 and f1 and returns sum of results
    public fun compute_and_sum(x: u8, y: bool, a: u16): u64 {
        let (f2_a, f2_b) = f2(a);
        let f1_result = f1(x, y);

        // sum all results as u64
        let sum = (f2_a as u64) + (f2_b as u64) + (f1_result as u64);
        sum
    }

    // test]
    public fun test_compute_and_sum_1() {
        let sum = compute_and_sum(1u8, true, 10u16);
        let expected = (10u16 + 3 + 10u16 + 7) as u64 + (1u8 + 2 + 2 + 2) as u64;
        assert!(sum == expected, 1001);
    }

    // test]
    public fun test_compute_and_sum_2() {
        let sum = compute_and_sum(5u8, false, 0u16);
        let expected = (0u16 + 3 + 0u16 + 7) as u64 + (5u8 + 2 + 2 + 2) as u64;
        assert!(sum == expected, 1002);
    }

    // test]
    public fun test_increment_counter() {
        let counters = initialize();
        increment(&mut counters, 0);
        increment(&mut counters, 1);
        assert!(vector::borrow(&counters, 0).value == 1, 2001);
        assert!(vector::borrow(&counters, 1).value == 11, 2002);
    }
}



//# run 0xCAFE::UpdateSpecTest::test_compute_and_sum_1



//# run 0xCAFE::UpdateSpecTest::test_compute_and_sum_2



//# run 0xCAFE::UpdateSpecTest::test_increment_counter
