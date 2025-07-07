
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    // Removed unused use std::signer;

    struct Item has copy, drop, store {
        val: u64,
    }

    // A FIFO queue implemented as a vector with front index
    struct Queue has store, drop {  // added drop ability to Queue to allow implicit drop
        items: vector<Item>,
        front: u64, // index of the front item
    }

    public fun create_queue(): Queue {
        Queue {
            items: vector::empty<Item>(),
            front: 0,
        }
    }

    public fun enqueue(q: &mut Queue, val: u64) {
        let item = Item { val };
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue(q: &mut Queue): Item {
        let len = vector::length(&q.items);
        assert!(q.front < (len as u64), 1);
        let item = *vector::borrow(&q.items, q.front);
        q.front = q.front + 1;
        if (q.front == (len as u64)) {
            // Reset queue to empty
            q.front = 0;
            q.items = vector::empty<Item>();
        };
        item
    }

    // Test function that enqueues n items and dequeues them all, no args, just runs actions
    public fun runner() {
        let q = create_queue();

        enqueue(&mut q, 10);
        enqueue(&mut q, 20);
        enqueue(&mut q, 30);
        enqueue(&mut q, 40);
        enqueue(&mut q, 50);

        // To avoid unused local variable warnings and drop errors,
        // consume the dequeued values by unpacking Item structs:
        let i1 = dequeue(&mut q);
        let Item { val: _v1 } = i1;
        let i2 = dequeue(&mut q);
        let Item { val: _v2 } = i2;
        let i3 = dequeue(&mut q);
        let Item { val: _v3 } = i3;
        let i4 = dequeue(&mut q);
        let Item { val: _v4 } = i4;
        let i5 = dequeue(&mut q);
        let Item { val: _v5 } = i5;

        // i1.val should be 10
        // i5.val should be 50
    }
}



//# run 0xCAFE::QueueModule::runner




//# publish
module 0xCAFE::ComplexStructs {
    use std::vector;
    // Removed unused use std::vector;

    struct RefHolder<T: copy+drop> has copy, drop, store {
        reference: T,
    }

    struct ComplexSingleton<T: copy+drop> has store, drop { // added drop ability here
        field1: u64,
        inner: RefHolder<T>,
    }

    enum ComplexEnum<T: copy+drop + store> has store, drop { // added drop ability here
        Variant1,
        Variant2(RefHolder<T>),
        Variant3 {
            val: u64,
            nested: ComplexSingleton<T>,
        },
    }

    public fun create_singleton<T: copy+drop>(val: T): ComplexSingleton<T> {
        let inner = RefHolder<T> { reference: val };
        ComplexSingleton {
            field1: 42,
            inner,
        }
    }

    public fun create_enum_variant2<T: copy+drop + store>(val: T): ComplexEnum<T> {
        let rh = RefHolder<T> { reference: val };
        ComplexEnum::Variant2(rh)
    }

    public fun create_enum_variant3<T: copy+drop + store>(val: T): ComplexEnum<T> {
        let singleton = create_singleton(val);
        ComplexEnum::Variant3 {
            val: 99,
            nested: singleton
        }
    }

    // Runner function that exercises the creation without any args
    public fun runner() {
        let single = create_singleton(10u64);
        // Consume ComplexSingleton by unpacking it
        let ComplexSingleton { field1: _f1, inner: RefHolder { reference: _r1 } } = single;

        let v2 = create_enum_variant2(20u64);
        match v2 {
            ComplexEnum::Variant1 => (),
            ComplexEnum::Variant2(RefHolder { reference: _r2 }) => (),
            ComplexEnum::Variant3 { val: _v, nested } => {
                let ComplexSingleton { field1: _f3, inner: RefHolder { reference: _r3 } } = nested;
            }
        };

        let v3 = create_enum_variant3(30u64);
        match v3 {
            ComplexEnum::Variant1 => (),
            ComplexEnum::Variant2(RefHolder { reference: _r4 }) => (),
            ComplexEnum::Variant3 { val: _val, nested } => {
                let ComplexSingleton { field1: _f4, inner: RefHolder { reference: _r5 } } = nested;
            }
        };
    }
}



//# run 0xCAFE::ComplexStructs::runner




//# publish
module 0xCAFE::AbilityCombine {
    // Demonstrate a struct with multiple type parameters constrained with "+" syntax
    struct MultiAbility<T: copy+drop+store> has store, drop {  // added drop
        field: T,
    }

    struct DoubleGeneric<T: copy+drop+store, U: drop+store> has store, drop {  // added drop
        val1: T,
        val2: U,
    }

    public fun create_multi_ability(): MultiAbility<u64> {
        MultiAbility { field: 123u64 }
    }

    public fun create_double_generic(): DoubleGeneric<u8, u64> {
        DoubleGeneric {
            val1: 1u8,
            val2: 999u64,
        }
    }

    public fun runner() {
        let a = create_multi_ability();
        let MultiAbility { field: _field_a } = a;

        let b = create_double_generic();
        let DoubleGeneric { val1: _v1, val2: _v2 } = b;
    }
}



//# run 0xCAFE::AbilityCombine::runner
