//# publish
module 0xCAFE::IncrementTest {

    #[skip(num_args)]
    struct WrappingU8 has copy, drop, store {
        value: u8,
    }

    #[skip(field_shadowing)]
    struct InnerStruct has copy, drop, store {
        x: u64,
        y: bool,
    }

    #[skip(prune_variant)]
    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        tag: u8,
    }

    // increment a primitive u8 input and return it
    public fun incr_u8(x: u8): u8 {
        x + 1
    }

    // increment a primitive u64 input and return it
    public fun incr_u64(x: u64): u64 {
        x + 1
    }

    // increment the field `value` inside WrappingU8 struct
    public fun incr_wrapping_u8(w: WrappingU8): WrappingU8 {
        WrappingU8 { value: w.value + 1 }
    }

    // increment the field x inside InnerStruct
    public fun incr_inner_x(i: InnerStruct): InnerStruct {
        InnerStruct { x: i.x + 1, y: i.y }
    }

    // increment the field tag inside OuterStruct
    public fun incr_outer_tag(o: OuterStruct): OuterStruct {
        OuterStruct { inner: o.inner, tag: o.tag + 1 }
    }

    // increment the first element in vector<u8> by 1 if vector is non-empty
    public fun incr_vector(v: vector<u8>): vector<u8> {
        if (Vector::length(&v) == 0) {
            v
        } else {
            let mut new_v = Vector::empty<u8>();
            let first = Vector::borrow(&v, 0) + 1;
            Vector::push_back(&mut new_v, first);
            let mut i = 1;
            while (i < Vector::length(&v)) {
                let val = Vector::borrow(&v, i);
                Vector::push_back(&mut new_v, *val);
                i = i + 1;
            };
            new_v
        }
    }

    // accessors for comparison to test consistency:
    public fun get_wrapping_u8_value(w: &WrappingU8): u8 {
        w.value
    }

    public fun get_inner_x(i: &InnerStruct): u64 {
        i.x
    }

    public fun get_outer_tag(o: &OuterStruct): u8 {
        o.tag
    }

    public fun get_vector_first(v: &vector<u8>): Option<u8> {
        if (Vector::length(v) == 0) {
            Option::none<u8>()
        } else {
            Option::some<u8>(*Vector::borrow(v, 0))
        }
    }

    // Runner function with no arguments that demonstrates usage and can be called with run command
    public fun runner() {
        // incr u8
        let a: u8 = 41;
        let a_inc = incr_u8(a);
        // incr u64
        let b: u64 = 1000;
        let b_inc = incr_u64(b);
        // incr WrappingU8
        let w = WrappingU8 { value: 250 };
        let w_inc = incr_wrapping_u8(w);
        // incr InnerStruct x
        let inner = InnerStruct { x: 999, y: true };
        let inner_inc = incr_inner_x(inner);
        // incr OuterStruct tag
        let outer = OuterStruct { inner: inner, tag: 254 };
        let outer_inc = incr_outer_tag(outer);
        // incr vector first element - vector<u8>
        let v = Vector::empty<u8>();
        Vector::push_back(&mut v, 10);
        Vector::push_back(&mut v, 20);
        let v_inc = incr_vector(v);

        // dummy usage of get functions to "read" values (not asserting)
        let _ = get_wrapping_u8_value(&w_inc);
        let _ = get_inner_x(&inner_inc);
        let _ = get_outer_tag(&outer_inc);
        let _ = get_vector_first(&v_inc);
    }
}
//# run 0xCAFE::IncrementTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::RunnerNoArgsTest {
    // Simple module to test runner function without args that uses primitives repeatedly

    #[skip(unused_var)]
    struct Data has copy, drop, store {
        val: u64,
    }

    public fun increment_data(d: Data): Data {
        Data { val: d.val + 1 }
    }

    public fun runner() {
        let d = Data { val: 1234 };
        let d2 = increment_data(d);
        let d3 = increment_data(d2);
        let x = d3.val;
        // dummy usage
        let _ = x;
    }
}
//# run 0xCAFE::RunnerNoArgsTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::IncrementTest;

    fun main() {
        // Test increments on primitives and structs by calling functions directly

        let x_u8: u8 = 100;
        let x_u8_inc = IncrementTest::incr_u8(x_u8);

        let x_u64: u64 = 54321;
        let x_u64_inc = IncrementTest::incr_u64(x_u64);

        let w = IncrementTest::WrappingU8 { value: 200 };
        let w_inc = IncrementTest::incr_wrapping_u8(w);

        let i = IncrementTest::InnerStruct { x: 1000, y: true };
        let i_inc = IncrementTest::incr_inner_x(i);

        let o = IncrementTest::OuterStruct { inner: i_inc, tag: 20 };
        let o_inc = IncrementTest::incr_outer_tag(o);

        let mut v = Vector::empty<u8>();
        Vector::push_back(&mut v, 50);
        Vector::push_back(&mut v, 51);
        let v_inc = IncrementTest::incr_vector(v);

        // read accesses
        let _ = IncrementTest::get_wrapping_u8_value(&w_inc);
        let _ = IncrementTest::get_inner_x(&i_inc);
        let _ = IncrementTest::get_outer_tag(&o_inc);
        let _ = IncrementTest::get_vector_first(&v_inc);
    }
}

// Featurres:
// eb9d496d4c6b5c330f13f8d6886363fe: Test that various implementations of increment and access functions for primitive types, structs, wrapped types, and vectors produce consistent and correct results across different usage patterns.
// a99471d2ea89cf76f0ccd0486eb6abcd: Configure your code with `#[skip(lint_name)]` attributes to customize lint enforcement according to your preferences.
// fa1f0755c83c8b79f78255984c60ae82: Specify module names and ensure they do not start with an underscore.
