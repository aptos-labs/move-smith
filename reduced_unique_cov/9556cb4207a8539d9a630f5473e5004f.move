
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    struct Queue<T: copy + drop> has store {
        items: vector<T>,
    }

    public fun new<T: copy + drop>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    public fun enqueue<T: copy + drop>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T: copy + drop>(queue: &mut Queue<T>): Option<T> {
        if (vector::length(&queue.items) == 0) {
            Option::none<T>()
        } else {
            let item = vector::borrow(&queue.items, 0);
            let result = *item;
            vector::remove(&mut queue.items, 0);
            Option::some<T>(result)
        }
    }

    public fun test_runner(): vector<u8> {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);
        let results = vector::empty<u8>();
        let first = dequeue(&mut q);
        let second = dequeue(&mut q);
        let third = dequeue(&mut q);
        match first {
            Option::some(v) => vector::push_back(&mut results, v),
            Option::none => {},
        };
        match second {
            Option::some(v) => vector::push_back(&mut results, v),
            Option::none => {},
        };
        match third {
            Option::some(v) => vector::push_back(&mut results, v),
            Option::none => {},
        };
        results
    }
}


//# run 0xCAFE::QueueModule::test_runner


//# publish
module 0xCAFE::ReferenceStructs {
    use std::signer;

    struct Inner has copy, drop {
        value: u64,
    }

    struct Outer has store {
        inner: Inner,
        addr: address,
    }

    struct VariantStruct<T: copy + drop> has store, copy, drop {
        val: T,
    }

    struct ComplexVariant has store {
        field1: VariantStruct<u64>,
        field2: VariantStruct<address>,
    }

    public fun create_outer(s: signer, val: u64): Outer {
        Outer {
            inner: Inner { value: val },
            addr: signer::address_of(&s),
        }
    }

    public fun create_complex(): ComplexVariant {
        ComplexVariant {
            field1: VariantStruct { val: 42u64 },
            field2: VariantStruct { val: @0xCAFE },
        }
    }
}


//# run 0xCAFE::ReferenceStructs::create_outer --signers 0xBABE --args 777u64


//# run 0xCAFE::ReferenceStructs::create_complex


//# publish
module 0xCAFE::AbilitiesExample {
    struct MultiAbility<T: copy + drop + store> has copy, drop, store { 
        value: T
    }

    public fun new<T: copy + drop + store>(val: T): MultiAbility<T> {
        MultiAbility { value: val }
    }
    
    public fun get_value<T: copy + drop + store>(m: &MultiAbility<T>): &T {
        &m.value
    }
}


//# run 0xCAFE::AbilitiesExample::new --args 123u64


//# run 0xCAFE::AbilitiesExample::get_value --args 123u64


//# publish
module 0xCAFE::EnumAccess {
    enum Options has copy, drop {
        None,
        Some(u64),
        Multi { a: u8, b: u8 },
    }

    public fun get_value(e: Options): u64 {
        match e {
            Options::None => 0,
            Options::Some(v) => v,
            Options::Multi { a, b } => (a as u64) + (b as u64),
        }
    }

    public fun get_value_by_ref(e_ref: &Options): u64 {
        match *e_ref {
            Options::None => 0,
            Options::Some(v) => v,
            Options::Multi { a, b } => (a as u64) + (b as u64),
        }
    }

    public fun test_pattern(): (u64, u64) {
        let e1 = Options::Some(100);
        let e2 = Options::Multi { a: 3, b: 4 };
        let v1 = get_value(e1);
        let v2 = get_value(e2);
        (v1, v2)
    }
}


//# run 0xCAFE::EnumAccess::test_pattern


//# publish
module 0xCAFE::UseStatementsTest {
    use 0xCAFE::EnumAccess;
    use 0xCAFE::AbilitiesExample;

    public fun runner(): u64 {
        let e = EnumAccess::Options::Some(77);
        let val = EnumAccess::get_value(e);
        val + *AbilitiesExample::get_value(&AbilitiesExample::new(10u64))
    }
}


//# run 0xCAFE::UseStatementsTest::runner


//# publish
module 0xCAFE::PackageFilter {
    use std::vector;

    struct PackageDefinition has copy, drop, store {
        name: vector<u8>,
        version: u64,
    }

    public fun filter_packages(packages: vector<PackageDefinition>): vector<PackageDefinition> {
        vector::filter(packages, |pkg: &PackageDefinition| {
            let is_selected = vector::length(&pkg.name) > 3;
            is_selected
        })
    }

    // Helper function to create packages and test filtering
    public fun test_filter(): vector<vector<u8>> {
        let p1 = PackageDefinition { name: b"abc", version: 1 };
        let p2 = PackageDefinition { name: b"abcd", version: 2 };
        let p3 = PackageDefinition { name: b"abcde", version: 3 };
        let packages = vector[p1, p2, p3];
        let filtered = filter_packages(packages);
        let names = vector::empty<vector<u8>>();
        let len = vector::length(&filtered);
        let i = 0;
        while (i < len) {
            let pkg = vector::borrow(&filtered, i);
            vector::push_back(&mut names, copy pkg.name);
            i = i + 1;
        };
        names
    }
}


//# run 0xCAFE::PackageFilter::test_filter


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 5e57cb3869d0c3044bfdc90107c9a777: Test that fields of enum variants can be accessed directly and via references, and that pattern matching destructures enum variants correctly in Move.
// 36e48cd89925e2df15f9975bdf234867: Use 'use' statements within modules without affecting implicit aliasing.
// 73f224d182152bfdb2c1fa7da72c4c1e: Apply custom filtering logic to package definitions within a program.
