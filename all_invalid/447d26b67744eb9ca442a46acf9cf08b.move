module 0x1::transactional_test {
    use std::vector;
    use std::signer;

    struct GenericContainer<T> has copy, drop, store {
        items: vector<T>,
    }

    public fun create_container<T: copy + drop + store>(items: vector<T>): GenericContainer<T> {
        GenericContainer { items }
    }

    public fun add_item<T: copy + drop + store>(container: &mut GenericContainer<T>, item: T) {
        vector::push_back(&mut container.items, item);
    }

    public fun length<T: copy + drop + store>(container: &GenericContainer<T>): u64 {
        vector::length(&container.items)
    }

    #[test]
    public fun test_generic_jumps_and_coalescing(s: &signer) {
        // 1. Generic container usage
        let mut container = create_container(vector::empty<u64>());
        add_item(&mut container, 1);
        add_item(&mut container, 2);
        add_item(&mut container, 3);
        assert!(length(&container) == 3, 100);

        // 2. Jump instructions via loop and break (unconditional jump)
        let mut sum = 0;
        let mut i = 0;
        loop {
            if (i == 2) {
                // Break simulates a jump to outside loop
                break;
            }
            sum = sum + i;
            i = i + 1;
        }
        assert!(sum == 1, 101);

        // 3. Variable coalescing (reusing variables non-overlapping)
        let x = 10;
        assert!(x == 10, 102);

        // x out of scope, reuse same name x
        let x = 20;
        assert!(x == 20, 103);

        let x = x + 5;
        assert!(x == 25, 104);

        assert!(true, 200);
    }
}

// Featurres:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 58144f80ecfcc1a7f6b3597c62ec21d2: Create jump instructions to transfer control unconditionally to a label.
// 3ecc15b09258b7a28f92aafc27f53516: Perform variable coalescing to reduce register pressure and improve performance.
