// Test of transactional format: external lint, dotted expressions, filtering, dot notation.

//# publish
module 0x1::NestedStructs {
    /// External lint configuration. Assume this comment hints at custom lint usage.
    /// e.g., linter: allow(non_snake_case)
    ///@linter: allow(non_snake_case)
    struct Inner has copy, drop, store {
        a: u8,
        b: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        name: vector<u8>,
    }

    public fun make_outer(a: u8, b: u64, name: vector<u8>): Outer {
        Outer {
            inner: Inner { a, b },
            name,
        }
    }

    public fun increment_inner_a(o: &mut Outer) {
        o.inner.a = o.inner.a + 1;
    }

    public fun get_inner_b(o: &Outer): u64 {
        // Demonstrate multi-level dotted access.
        o.inner.b
    }

    /// Runner function for testing, creates, modifies, and reads nested structures.
    public fun test_all() {
        let mut outer = make_outer(7, 99, b"alpha".to_vec());
        increment_inner_a(&mut outer);
        let val = get_inner_b(&outer);
        assert!(val == 99, 100);
        // Access the name property using dot notation.
        let name_copy = outer.name;
        let first_byte = name_copy[0];
        assert!(first_byte == 97, 101); // 97 is 'a'
    }
}

//# run 0x1::NestedStructs::test_all --signers 0x1

//# publish
address 0x2 {
    ///@linter: deny(dead_code)
    module ModuleA {
        struct Foo has copy, drop, store {
            val: u8,
            sub: Bar,
        }
        struct Bar has copy, drop, store {
            x: u8,
            y: u64,
        }

        public fun set_fields(f: &mut Foo) {
            // Nested field access with dotted notation.
            f.sub.x = f.sub.x + 10;
        }

        /// Runner function.
        public fun run_test() {
            let mut bar = Bar { x: 2, y: 42 };
            let mut foo = Foo { val: 5, sub: bar };
            set_fields(&mut foo);
            assert!(foo.sub.x == 12, 12);
        }
    }
}

//# run 0x2::ModuleA::run_test --signers 0x2

//# publish
address 0x3 {
    ///@linter: allow(private_functions)
    module FilteringDemo {
        struct Demo has copy, drop, store {
            a: u64,
        }

        /// Only published when address is 0x3 and module name matches filter
        fun helper_demo() {
            // External filter: include only when module name is FilteringDemo.
        }

        public fun runner() {
            let d = Demo { a: 1234 };
            let _x = d.a; // Dotted access to a field
        }
    }
}

//# run 0x3::FilteringDemo::runner --signers 0x3

//# run
script {
    fun main() {
        let obj = 0x1::NestedStructs::make_outer(1, 2, b"abcd".to_vec());
        let y = obj.inner.b; // Dotted access to deep field in struct.
        let _ = y + 10;
    }
}