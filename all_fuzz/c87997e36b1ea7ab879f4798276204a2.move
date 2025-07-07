
//# publish
module 0xCAFE::ShadowingAndCapture {
    struct Counter has store {
        value: u8,
    }

    public fun foo() {
        let x = 1u8;
        let inc = &mut x;

        // Move does not support nested function definitions; use an inline anonymous function pattern via a closure or just a normal block:
        {
            *inc = *inc + 1;
        };
        {
            *inc = *inc + 1;
        };

        // After two increments, x should be 3
        let x = *inc;
        assert!(x == 3, 999);
    }

    public fun multiple_args_call(a: u8, b: u8, c: u8) {
        let s = a + b + c;
        assert!(s == 6, 1000);
    }
}



//# run 0xCAFE::ShadowingAndCapture::foo



//# run 0xCAFE::ShadowingAndCapture::multiple_args_call --args 1u8 2u8 3u8



//# publish
module 0xCAFE::GenericQueue {
    use std::vector;

    struct Queue<T> has store {
        elems: vector<T>,
    }

    public fun create<T>(): Queue<T> {
        Queue<T> { elems: vector::empty<T>() }
    }

    public fun enqueue<T>(q: &mut Queue<T>, elem: T) {
        vector::push_back(&mut q.elems, elem);
    }

    public fun dequeue<T>(q: &mut Queue<T>): T {
        assert!(!vector::is_empty(&q.elems), 1);
        let elem = *vector::borrow(&q.elems, 0);
        vector::remove(&mut q.elems, 0);
        elem
    }

    public fun test_fifo() {
        let q = create<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let first = dequeue(&mut q);
        let second = dequeue(&mut q);
        let third = dequeue(&mut q);

        assert!(first == 10, 2);
        assert!(second == 20, 3);
        assert!(third == 30, 4);
    }
}



//# run 0xCAFE::GenericQueue::test_fifo



//# publish
module 0xCAFE::EnumVariants {
    enum E has copy, drop {
        V1 {
            a: u8,
            b: u8,
        },
        V2(u16, u32),
        V3,
    }

    public fun test_variants() {
        let e1 = E::V1 { a: 1, b: 2 };
        let e2 = E::V2(10, 20);
        let e3 = E::V3;

        let x = match (e1) {
            E::V1 { a, b } => a + b,
            E::V2(x, y) => (x as u8) + (y as u8),
            E::V3 => 0,
        };

        let (v1_field, v2_first, v2_second) = match (e2) {
            E::V1 { a, b } => (a, 0u8, 0u8),
            E::V2(x, y) => ((x as u8), (y as u8), (y as u8)),
            E::V3 => (0, 0, 0),
        };

        assert!(x == 3, 555);
        assert!(v1_field == 10 && v2_first == 20 && v2_second == 20, 556);
    }
}



//# run 0xCAFE::EnumVariants::test_variants



//# publish
module 0xCAFE::BindAndDestructure {
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun bind_by_name() {
        let p = Pair { a: 4u8, b: 5u8 };
        let Pair { a: x, b: y } = p;
        assert!(x == 4 && y == 5, 777);
    }

    public fun destructure_let() {
        let p = Pair { a: 8u8, b: 9u8 };
        let Pair { a, b } = p;
        assert!(a == 8 && b == 9, 778);
    }
}



//# run 0xCAFE::BindAndDestructure::bind_by_name



//# run 0xCAFE::BindAndDestructure::destructure_let
