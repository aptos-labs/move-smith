
//# publish
module 0xBADD::SequentialCalculator {
    use std::vector;
    use std::signer;
    use std::option;

    struct Calculator has store {
        total: u64,
        last_op: option::Option<u8>,
        buffer: vector<u64>,
    }

    public fun init(): Calculator {
        Calculator { total: 0, last_op: option::none(), buffer: vector::empty<u64>() }
    }

    public fun input_number(calculator: &mut Calculator, num: u64) {
        vector::push_back(&mut calculator.buffer, num);
    }

    public fun set_operation(calculator: &mut Calculator, op: u8) {
        calculator.last_op = option::some(op);
        if (vector::length(&calculator.buffer) >= 2) {
            // Correctly assign the popped values
            let _b = vector::pop(&mut calculator.buffer);
            let _a = vector::pop(&mut calculator.buffer);
            let result = match (calculator.last_op) {
                option::some(op_code) => inline (op_code) {
                    if (op_code == 1u8) { _a + _b }
                    else if (op_code == 2u8) { _a - _b }
                    else if (op_code == 3u8) { _a * _b }
                    else { _a }
                },
                option::none() => _a,
            };
            calculator.total = result;
            // Reset buffer after operation, optional
            vector::push_back(&mut calculator.buffer, result);
        }
    }

    public fun get_total(calculator: &Calculator): u64 {
        calculator.total
    }

    public fun get_buffer_sum(calculator: &Calculator): u64 {
        let sum = 0u64;
        let length = vector::length(&calculator.buffer);
        let i = 0;
        while (i < length) {
            let val = vector::borrow(&calculator.buffer, i);
            sum = sum + *val;
            i = i + 1;
        };
        sum
    }
}



//# run 0xBADD::SequentialCalculator::init



//# run 0xBADD::SequentialCalculator::input_number --args 10u64



//# run 0xBADD::SequentialCalculator::set_operation --args 1u8



//# run 0xBADD::SequentialCalculator::input_number --args 20u64



//# run 0xBADD::SequentialCalculator::set_operation --args 3u8



//# run 0xBADD::SequentialCalculator::get_total



//# run 0xBADD::SequentialCalculator::get_buffer_sum



//# publish
module 0xBADD::UniqueMapSimulation {
    use std::vector;
    use std::signer;
    use std::key_cloned_iter;

    struct UniqueMap<K, V> has store {
        map: vector<(K, V)>,
    }

    public fun new<K, V>(): UniqueMap<K, V> {
        UniqueMap { map: vector::empty<(K, V)>() }
    }

    public fun insert<K: copy + drop + store + key, V: store>(umap: &mut UniqueMap<K, V>, key: K, value: V) {
        let len = vector::length(&umap.map);
        let i = 0;
        let found = false;
        while (i < len) {
            let (k, _v) = vector::borrow(&umap.map, i);
            if (k == key) {
                // Replace existing
                // Use swap: swap the existing with new
                let (_k, _old_v) = vector::swap(&mut umap.map, i, (key, value));
                found = true;
                break;
            }
            i = i + 1;
        };
        if (!found) {
            vector::push_back(&mut umap.map, (key, value));
        }
    }

    public fun delete<K: copy + drop + store + key, V: store>(umap: &mut UniqueMap<K, V>, key: K) {
        let len = vector::length(&umap.map);
        let i = 0;
        while (i < len) {
            let (k, _) = vector::borrow(&umap.map, i);
            if (k == key) {
                vector::swap_remove(&mut umap.map, i);
                break;
            }
            i = i + 1;
        }
    }

    public fun for_each<K: copy + store, V: store>(umap: &UniqueMap<K, V>, f: &|K, V|) {
        key_cloned_iter::key_cloned_iter(&umap.map).for_each(f);
    }

    public fun key_cloned_iter<K: copy + store, V: store>(umap: &vector<(K, V)>): key_cloned_iter::KeyClonedIter<K> {
        key_cloned_iter::new(umap)
    }
}



//# run 0xBADD::UniqueMapSimulation::new



//# run 0xBADD::UniqueMapSimulation::insert --args 0u64 100u8



//# run 0xBADD::UniqueMapSimulation::insert --args 1u64 200u8



//# run 0xBADD::UniqueMapSimulation::for_each --signers 0xBADD
