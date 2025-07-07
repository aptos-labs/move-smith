
//# publish
module 0xCAFE::ComplexTypes {
    use std::vector;

    struct Inner has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct Outer<T, U> has copy, drop, store {
        inner: T,
        more_data: U,
        flag: bool,
    }

    public fun make_inner(a: u8, b: u16): Inner {
        Inner {a, b}
    }

    public fun make_outer(): Outer<Inner, (u64, vector<u8>)> {
        let inner = make_inner(42u8, 65535u16);
        let v = vector::from_bytes(b"ABC");
        Outer {
            inner,
            more_data: (123456789u64, v),
            flag: true,
        }
    }

    // Function with complex function type parameter and tuple return
    public fun apply_func(f: |(u8, u16): (u32, bool), input: (u8, u16)): (u32, bool) {
        f(input)
    }

    // Inline function returning nested tuple with generic parameter and function type inside tuple
    public inline fun nested_return<T>(x: T, y: u8): ((T, u8), |u8: u8) {
        let lambda: |u8: u8 = |z: u8| { z + y };
        ((x, y), lambda)
    }

    public fun run() {
        let o = make_outer();

        let lambda = |(p, q): (u8, u16)| {
            (u32::from(p) + u32::from(q), true)
        };

        let (_res1, _res2) = apply_func(lambda, (10u8, 20u16));

        let ((_nested_x, _nested_y), _lambda2) = nested_return<u8>(7u8, 8u8);

        let _ = _lambda2(5u8);
    }
}



//# run 0xCAFE::ComplexTypes::run



//# publish
module 0xCAFE::LibraryModule {
    use std::vector;

    public struct Item has copy, drop, store {
        id: u64,
        data: vector<u8>,
    }

    public fun create_item(id: u64, data: vector<u8>): Item {
        Item { id, data }
    }

    public fun get_id(item: &Item): u64 {
        item.id
    }

    public fun get_data_len(item: &Item): u64 {
        vector::length(&item.data) as u64
    }

    public fun example_usage() {
        let data = vector::from_bytes(b"xyz");
        let item = create_item(999u64, data);
        let _id = get_id(&item);
        let _len = get_data_len(&item);
    }
}



//# run 0xCAFE::LibraryModule::example_usage



//# publish
module 0xCAFE::UseLibrary {
    use std::signer;
    use 0xCAFE::LibraryModule;

    struct Container has store {
        item: LibraryModule::Item,
        count: u8,
    }

    public fun create_container(s: signer, id: u64, raw: vector<u8>, count: u8) {
        let item = LibraryModule::create_item(id, raw);
        let container = Container { item, count };
        move_to(&s, container);
    }

    public fun get_container_id(s: signer): u64 acquires Container {
        let c = borrow_global<Container>(signer::address_of(&s));
        LibraryModule::get_id(&c.item)
    }

    public fun get_container_data_len(s: signer): u64 acquires Container {
        let c = borrow_global<Container>(signer::address_of(&s));
        LibraryModule::get_data_len(&c.item)
    }

    public fun runner(s: signer) acquires Container {
        create_container(s, 42u64, vector::from_bytes(b"HI"), 2u8);
        let _id = get_container_id(s);
        let _len = get_container_data_len(s);
    }
}



//# run 0xCAFE::UseLibrary::runner --signers 0xDEAD



//# publish
module 0xCAFE::NestedGenerics {
    use std::vector;

    struct Inner<T> has copy, drop, store {
        value: T,
    }

    struct Middle<U> has copy, drop, store {
        inner: Inner<U>,
        data: vector<U>,
    }

    struct Outer<T, U> has copy, drop, store {
        middle: Middle<T>,
        extra: U,
    }

    public fun create_nested(): Outer<u8, u64> {
        let inner = Inner { value: 100u8 };
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 1u8);
        vector::push_back(&mut v, 2u8);
        vector::push_back(&mut v, 3u8);

        let middle = Middle { inner, data: v };
        Outer { middle, extra: 5000u64 }
    }

    public fun complex_return_typed_lambda(): (Outer<u8, u64>, |u64: u8) {
        let outer = create_nested();

        let lambda = |x: u64| {
            (x % 256u64) as u8
        };
        (outer, lambda)
    }

    public fun run() {
        let (outer, lambda) = complex_return_typed_lambda();
        let _val = lambda(65535u64);
        let _val2 = outer.middle.inner.value + _val;
    }
}



//# run 0xCAFE::NestedGenerics::run
