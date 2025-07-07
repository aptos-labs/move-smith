// # publish
module 0xCAFE::PlusEqualsTest {
    use std::vector;
    use std::option;

    #[deprecated]
    struct SampleStruct {
        val: u64,
    }

    #[deprecated]
    struct Wrapper<T> {
        inner: T,
    }

    #[deprecated]
    struct NestedStruct<T> {
        a: u64,
        b: vector::Vector<u8>,
        c: Wrapper<T>,
    }

    #[deprecated]
    public fun runner() {
        // 1. primitive types
        let mut x: u64 = 1;
        x += 1;
        let mut y: u64 = 1;
        y = y + 1;
        // x and y should be equal (no asserts needed)

        // 2. struct field with deprecated struct
        let mut s = SampleStruct { val: 10 };
        s.val += 5;
        let mut s2 = SampleStruct { val: 10 };
        s2.val = s2.val + 5;

        // 3. generic wrapper with deprecated struct and with optional type annotations
        let mut w: Wrapper<u64> = Wrapper { inner: 100 };
        w.inner += 20;
        let mut w2 = Wrapper { inner: 100u64 };
        w2.inner = w2.inner + 20u64;

        // 4. vector element
        let mut v: vector::Vector<u64> = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        let mut_val_ref = vector::borrow_mut(&mut v, 1);
        *mut_val_ref += 5;
        let mut v2 = vector::empty::<u64>();
        vector::push_back(&mut v2, 1u64);
        vector::push_back(&mut v2, 2u64);
        let mut_val_ref2 = vector::borrow_mut(&mut v2, 1);
        *mut_val_ref2 = *mut_val_ref2 + 5;

        // 5. nested struct with vector and generic wrapper
        let mut nested = NestedStruct {
            a: 0,
            b: vector::empty<u8>(),
            c: Wrapper { inner: 1u64 },
        };
        nested.a += 1;
        nested.b.push_back(42);
        nested.c.inner += 10;

        let mut nested2 = NestedStruct {
            a: 0u64,
            b: vector::empty<u8>(),
            c: Wrapper { inner: 1u64 },
        };
        nested2.a = nested2.a + 1;
        nested2.b.push_back(42u8);
        nested2.c.inner = nested2.c.inner + 10u64;
    }
}
// # run 0xCAFE::PlusEqualsTest::runner --signers 0xCAFE

// # publish
module 0xCAFE::OptionalTypeAnno {
    #[deprecated]
    public fun add_one(mut x: u64) { 
        x += 1; 
    }

    #[deprecated]
    public fun add_one_explicit(mut x: u64) { 
        x = x + 1; 
    }

    #[deprecated]
    public fun runner() {
        // Use optional type annotations in let bindings
        let x = 10u64;
        let mut y: u64 = 10;   // explicit
        y += 1;
        let mut z = 10;        // inferred
        z = z + 1;

        // call functions
        add_one(y);
        add_one_explicit(z);
    }
}
// # run 0xCAFE::OptionalTypeAnno::runner --signers 0xCAFE

// # publish
module 0xCAFE::DeprecatedInModule {
    #[deprecated]
    public fun deprecated_fun() {
        // no body
    }

    #[deprecated]
    public fun runner() {
        deprecated_fun();
    }
}
// # run 0xCAFE::DeprecatedInModule::runner --signers 0xCAFE

// # run
script {
    use 0xCAFE::PlusEqualsTest;
    use 0xCAFE::OptionalTypeAnno;
    use 0xCAFE::DeprecatedInModule;

    fun main() {
        PlusEqualsTest::runner();
        OptionalTypeAnno::runner();
        DeprecatedInModule::runner();
    }
}

// Featurres:
// 60b8edac2927117d5a8f167f98050333: Test that the `+=` (plus-equals) operator works correctly and is equivalent to explicit addition and assignment (`x = x + 1`) for primitive types, struct fields, generic wrappers, vectors, and nested data structures.
// 7f0eee0ccf6d537626d8da45a5b5f98a: Use optional type annotations in your code to allow types to be present or omitted
// 61f09ed7a7df1ead29aa123b533315c4: Annotate functions or modules with `#[deprecated]` to mark them as deprecated.
