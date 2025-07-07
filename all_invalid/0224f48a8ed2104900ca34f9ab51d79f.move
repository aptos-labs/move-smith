
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::option;

    // A simple FIFO queue of u64
    struct Queue has store {
        items: vector<u64>,
        start: u64,
        end: u64,
    }

    public fun new_queue(): Queue {
        Queue {
            items: vector::empty<u64>(),
            start: 0,
            end: 0,
        }
    }

    public fun enqueue(queue: &mut Queue, val: u64) {
        vector::push_back(&mut queue.items, val);
        queue.end = queue.end + 1;
    }

    public fun dequeue(queue: &mut Queue): option::Option<u64> {
        if (queue.start < queue.end) {
            let val = *vector::borrow(&queue.items, (queue.start) as usize);
            queue.start = queue.start + 1;
            option::some(val)
        } else {
            option::none()
        }
    }

    public fun length(queue: &Queue): u64 {
        queue.end - queue.start
    }

    public fun runner() {
        let q = new_queue();
        enqueue(&mut q, 10);
        enqueue(&mut q, 20);
        enqueue(&mut q, 30);
        let len = length(&q);
        assert!(len == 3, 1001);

        let val1_opt = dequeue(&mut q);
        let val2_opt = dequeue(&mut q);
        let val3_opt = dequeue(&mut q);
        let val4_opt = dequeue(&mut q);

        let val1 = option::extract(val1_opt);
        let val2 = option::extract(val2_opt);
        let val3 = option::extract(val3_opt);

        // validate FIFO order
        assert!(val1 == 10, 1002);
        assert!(val2 == 20, 1003);
        assert!(val3 == 30, 1004);
        // val4_opt should be none
        assert!(option::is_none(val4_opt), 1005);
    }

    // Complex Variant with a field referencing another struct inside this module
    struct Wrapper has store {
        queue: Queue
    }

    enum ComplexEnum has store {
        Variant1,
        Variant2(Wrapper),
    }

    public fun complex_enum_runner() {
        let q = new_queue();
        let w = Wrapper { queue: q };
        let _enum_val = ComplexEnum::Variant2(w);
    }
}



//# run 0xCAFE::QueueModule::runner



//# run 0xCAFE::QueueModule::complex_enum_runner



//# publish
module 0xCAFE::ClosureCompare {
    use std::vector;
    use std::bcs;
    use std::bytearray;

    // Compare closure equality by BCS serialization
    public fun closures_equal(
        c1: &(|u8| u8),
        c2: &(|u8| u8)
    ): bool {
        let serialized1 = bcs::to_bytes(c1);
        let serialized2 = bcs::to_bytes(c2);
        vector::length(&serialized1) == vector::length(&serialized2) && bytearray::equals(&serialized1, &serialized2)
    }

    // Compose closures deeply and test evaluation
    public fun compose_and_eval() {
        let inc: |u8| u8 has copy + drop = |x: u8| { x + 1 };
        let double: |u8| u8 has copy + drop = |x: u8| { x * 2 };

        let compose1: |u8| u8 has copy + drop = |x: u8| { inc(double(x)) };
        let compose2: |u8| u8 has copy + drop = |x: u8| { double(inc(x)) };

        let res1 = compose1(3u8);
        let res2 = compose2(3u8);

        // res1 = inc(double(3)) = inc(6) = 7
        assert!(res1 == 7, 2001);
        // res2 = double(inc(3)) = double(4) = 8
        assert!(res2 == 8, 2002);

        // Test closure comparison for equal closures
        let inc_copy = copy inc;
        let are_equal = closures_equal(&inc, &inc_copy);

        assert!(are_equal, 2003);

        // Test closure comparison for different closures
        let are_diff = closures_equal(&inc, &double);
        assert!(!are_diff, 2004);

        // Deep nested composition
        let nested: |u8| u8 has copy + drop = |x: u8| { compose1(compose2(x)) };
        let nested_result = nested(1u8);
        // compose2(1) = double(inc(1))=double(2)=4, compose1(4)=inc(double(4))=inc(8)=9
        assert!(nested_result == 9, 2005);
    }
}



//# run 0xCAFE::ClosureCompare::compose_and_eval
