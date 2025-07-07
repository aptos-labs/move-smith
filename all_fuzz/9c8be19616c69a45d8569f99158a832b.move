
//# publish
module 0xCAFE::Queue {
    use std::vector;

    // Added `drop` ability so Queue can be dropped safely
    struct Queue<Item> has store, drop {
        items: vector<Item>,
        start: u64,
    }

    public fun new_queue<Item>(): Queue<Item> {
        Queue {
            items: vector::empty<Item>(),
            start: 0,
        }
    }

    public fun enqueue<Item>(q: &mut Queue<Item>, item: Item) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<Item>(q: &mut Queue<Item>): Item {
        // Instead of copying the item, consume it by removing from vector and unpack
        // This avoids needing the copy ability on Item
        let item = vector::remove(&mut q.items, q.start);
        q.start = q.start + 1;
        item
    }

    public fun length<Item>(q: &Queue<Item>): u64 {
        let len = vector::length(&q.items);
        len - q.start
    }

    // runner that enqueues some values then dequeues all of them to check FIFO
    public fun runner() {
        let q = new_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);
        let d1 = dequeue(&mut q);
        let d2 = dequeue(&mut q);
        let d3 = dequeue(&mut q);
        // No assertions needed per instructions
        let _ = d1;
        let _ = d2;
        let _ = d3;
    }
}




//# run 0xCAFE::Queue::runner




//# publish
module 0xCAFE::AbilityUtils {
    use std::vector;

    // Define a representation of an ability
    const ABILITY_COPY: u8 = 1;
    const ABILITY_DROP: u8 = 2;
    const ABILITY_STORE: u8 = 4;
    const ABILITY_KEY: u8 = 8;

    // Define a struct to represent type parameters with abilities as bits
    struct TypeParamAbility has copy, drop {
        name: vector<u8>, // type parameter name as bytes
        abilities: u8,
    }

    // Use struct instead of tuple, because tuple types are not allowed as vector elements
    struct NameAbility has copy, drop {
        name: vector<u8>,
        ability_bits: u8,
    }

    // Converts a list of NameAbility to a vector of TypeParamAbility
    public fun make_set_based(abilities: vector<NameAbility>): vector<TypeParamAbility> {
        let result = vector::empty<TypeParamAbility>();
        let len = vector::length(&abilities);
        let i = 0;
        while (i < len) {
            let na = *vector::borrow(&abilities, i);
            let tpa = TypeParamAbility {
                name: na.name,
                abilities: na.ability_bits,
            };
            vector::push_back(&mut result, tpa);
            i = i + 1;
        };
        result
    }

    // Combine multiple abilities using '+' operator (here just sum bits)
    public fun combine_abilities(a: u8, b: u8): u8 {
        a + b
    }

    // runner function that shows usage
    public fun runner() {
        // Compose a list with NameAbility structs instead of tuples
        let list = vector[
            NameAbility { name: b"T1", ability_bits: ABILITY_COPY + ABILITY_DROP },
            NameAbility { name: b"T2", ability_bits: ABILITY_STORE + ABILITY_KEY },
            NameAbility { name: b"T3", ability_bits: ABILITY_COPY + ABILITY_STORE },
        ];
        let set_based = make_set_based(list);
        let combined = combine_abilities(ABILITY_COPY, ABILITY_STORE);
        let _ = set_based;
        let _ = combined;
    }
}




//# run 0xCAFE::AbilityUtils::runner
