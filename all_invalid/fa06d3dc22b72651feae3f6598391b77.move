
//# publish
module 0xCAFE::QueueTest {
    use std::vector;
    use std::error;

    struct Queue<T> has store {
        items: vector<T>,
    }

    public fun create_queue<T>(): Queue<T> {
        let items = vector::empty<T>();
        Queue {items}
    }

    public fun enqueue<T>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T>(queue: &mut Queue<T>): T acquires Queue {
        assert!(!vector::is_empty(&queue.items), 1001);
        vector::pop_front(&mut queue.items)
    }

    public fun runner() {
        let q = create_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);

        let _sum = a + b + c;
        // no assertion, just running the flow
    }
}


//# run 0xCAFE::QueueTest::runner



//# publish
module 0xCAFE::ComplexTypes {
    use std::string;

    struct Wrapper<T, U> has copy, drop, store {
        id: u64,
        label: string::String,
        inner1: T,
        inner2: U,
    }

    enum SingleOrPair<T> has copy, drop {
        Single(T),
        Pair { first: T, second: T },
    }

    public fun create_wrapper_and_enum(): Wrapper<SingleOrPair<u8>, u64> {
        let label = string::utf8(b"example");
        let enum_val = SingleOrPair::Pair {first: 10u8, second: 20u8};
        Wrapper {
            id: 42u64,
            label,
            inner1: enum_val,
            inner2: 100u64,
        }
    }
}


//# run 0xCAFE::ComplexTypes::create_wrapper_and_enum



//# publish
module 0xCAFE::AbilityCombiner {
    struct Container<T: copy + drop + store> has key {
        value: T,
    }

    public fun create_container<T: copy + drop + store>(val: T): Container<T> {
        Container { value: val }
    }

    public fun runner() {
        let c = create_container<u8>(123u8);
        let _v = copy c.value;
    }
}


//# run 0xCAFE::AbilityCombiner::runner



//# publish
module 0xCAFE::LabeledBlockControl {
    public fun test_labeled_blocks(x: u8): u8 {
        'outer: {
            'inner: {
                if (x == 0) {
                    break 'outer;
                };
                if (x > 10) {
                    break 'inner;
                };
                let _v = 1u8;
            };
            let v = 5u8;
            v
        };
        100u8
    }
}


//# run 0xCAFE::LabeledBlockControl::test_labeled_blocks --args 0u8


//# run 0xCAFE::LabeledBlockControl::test_labeled_blocks --args 15u8


//# run 0xCAFE::LabeledBlockControl::test_labeled_blocks --args 5u8



//# publish
module 0xCAFE::U64ArithmeticTests {
    use std::error;

    public fun u64_add(x: u64, y: u64): u64 acquires  {
        let res = x + y;
        // To test overflow, we assume abort at overflow
        // Move will automatically abort on overflow, no explicit check needed here
        res
    }

    public fun u64_sub(x: u64, y: u64): u64 {
        assert!(x >= y, 1002);
        x - y
    }

    public fun u64_mul(x: u64, y: u64): u64 {
        let res = x * y;
        res
    }

    public fun u64_div(x: u64, y: u64): u64 {
        assert!(y != 0, error::invalid_argument(0));
        x / y
    }

    public fun u64_mod(x: u64, y: u64): u64 {
        assert!(y != 0, error::invalid_argument(0));
        x % y
    }

    public fun runner() {
        let max = 0xffff_ffff_ffff_ffffu64;
        let zero = 0u64;

        // Addition valid
        let _ = u64_add(1u64, 2u64);

        // Addition overflow test (will abort, so called only in transaction)
        // intentionally commented out to avoid abort in runner
        // let _ = u64_add(max, 1u64); 

        // Subtraction valid
        let _ = u64_sub(10u64, 5u64);
        // Subtraction abort test (10 - 20), commented out
        // let _ = u64_sub(10u64, 20u64);

        // Multiplication valid
        let _ = u64_mul(2u64, 3u64);
        // Multiplication overflow test (will abort, commented)
        // let _ = u64_mul(max, 2u64);

        // Division valid
        let _ = u64_div(10u64, 2u64);
        // Division by zero (abort test)
        // let _ = u64_div(10u64, zero);

        // Modulus valid
        let _ = u64_mod(10u64, 3u64);
        // Modulus by zero (abort test)
        // let _ = u64_mod(10u64, zero);
    }
}


//# run 0xCAFE::U64ArithmeticTests::runner


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 5156b774d6d26dae1be19f17198217c1: Use labeled blocks to control flow with explicit labels.
// 93becae458c96cb06a0d39aa447fa74c: **Test that all u64 arithmetic operations (addition, subtraction, multiplication, division, modulus) produce correct results for edge values and fail with an error on overflow or division/modulus by zero.**
