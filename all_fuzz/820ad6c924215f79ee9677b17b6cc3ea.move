
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let _sum = a + b;
        // Return 42 regardless of sum, but sum is computed to test addition
        42u8
    }

    public fun lambda_test(): u8 {
        let f: |u8| u8 has copy+drop = |x: u8| {
            x + 2u8
        };
        f(10u8)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1u8
    }

    // Package visibility function (no public or public(entry))
    public(crate) fun package_visible_double(x: u8): u8 {
        x * 2u8
    }
}



//# run 0xCAFE::AddModule::add_and_return_42 --args 10u8 32u8



//# run 0xCAFE::AddModule::lambda_test



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_package(x: u8): u8 {
        let incr = AddModule::inline_increment(x);
        let doubled = AddModule::package_visible_double(incr);
        incr + doubled
    }
}



//# run 0xCAFE::CallerModule::call_inline_and_package --args 20u8



//# publish
module 0xCAFE::MapKeysModule {
    use std::vector;

    struct Map<K: copy + drop + store + key, V> has store {
        keys: vector<K>,
        values: vector<V>,
    }

    public fun new_map<K: copy + drop + store + key, V>(): Map<K, V> {
        Map {keys: vector::empty<K>(), values: vector::empty<V>()}
    }

    public fun insert<K: copy + drop + store + key, V>(m: &mut Map<K, V>, k: K, v: V) {
        vector::push_back(&mut m.keys, k);
        vector::push_back(&mut m.values, v);
    }

    public fun keys<K: copy + drop + store + key, V>(m: &Map<K, V>): vector<K> {
        vector::borrow(&m.keys).clone()
    }

    // To test a generic map returning keys with a mapping function over a vector
    public fun map_keys_plus_one(m: &Map<u8, u8>): vector<u8> {
        let keys = keys<u8, u8>(m);
        let result = vector::empty<u8>();
        let len = vector::length(&keys);
        let i = 0;
        while (i < len) {
            let key = *vector::borrow(&keys, i);
            vector::push_back(&mut result, key + 1u8);
            i = i + 1;
        };
        result
    }
}



//# run 0xCAFE::MapKeysModule::new_map



//# run 0xCAFE::MapKeysModule::map_keys_plus_one



//# publish
module 0xCAFE::OperatorTest {
    public fun test_logical_and_comparison_arithmetic(x: u8, y: u8): bool {
        let cond1 = x < y;
        let _cond2 = x <= y;
        let _cond3 = x == y;
        let cond4 = x != y;
        let cond5 = x >= y;
        let _cond6 = x > y;

        let and_result = cond1 && true;
        let or_result = cond4 || false;
        let not_result = !cond4;

        let sum = x + y;
        let diff = if (x > y) { x - y } else { y - x };
        let prod = x * y;
        let div = if (y != 0u8) { x / y } else { 0u8 };
        let rem = if (y != 0u8) { x % y } else { 0u8 };

        and_result && or_result && not_result && cond5 && (sum >= diff) && (prod >= sum) && (div >= 0u8) && (rem >= 0u8)
    }
}



//# run 0xCAFE::OperatorTest::test_logical_and_comparison_arithmetic --args 10u8 5u8
