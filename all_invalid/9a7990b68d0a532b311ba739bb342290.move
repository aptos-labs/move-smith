// The test uses address 0xCAFE as requested

//# publish
module 0xCAFE::ComplexTypes {
    use std::vector;

    /// A generic struct with nested complex type fields
    struct Nested<T1, T2> has copy, drop, store {
        a: T1,
        b: (T2, T1),
        c: vector<T2>,
        d: (u64, bool),
    }

    /// A function type alias
    // (Move doesn't have native function types, but we can simulate a function pointer as a closure or usage of functor types)
    // Here we simulate a function type by a function that takes u64 and returns bool
    // We'll define a function and store it inside a struct for testing.
    struct Functor has copy, drop, store {
        f: fn(u64): bool,
    }

    /// Construct a Nested<u8, bool>
    public fun make_nested(): Nested<u8, bool> {
        let c = vector::empty<bool>();
        vector::push_back(&mut c, true);
        vector::push_back(&mut c, false);
        Nested {
            a: 42u8,
            b: (true, 7u8),
            c,
            d: (999u64, true),
        }
    }

    /// Access the fields using dot notation and return a u64 from the nested tuple
    public fun access_fields(n: &Nested<u8, bool>): u64 {
        // access d field, which is (u64, bool)
        let (count, flag) = n.d;
        count
    }

    /// Function used as function pointer type
    public fun sample_predicate(x: u64): bool {
        x % 2 == 0
    }

    /// Create Functor with sample_predicate function
    public fun make_functor(): Functor {
        Functor { f: sample_predicate }
    }

    /// Call the function inside functor to test function type application
    public fun call_functor(f: &Functor, x: u64): bool {
        (f.f)(x)
    }

    /// A runner function that tests all of above
    public fun runner() {
        let nested = make_nested();
        let _count = access_fields(&nested);
        let functor = make_functor();
        let _result = call_functor(&functor, 10u64);
    }
}
 
//# run 0xCAFE::ComplexTypes::runner

// Another module with spec blocks attached to a script

//# publish
module 0xCAFE::SpecTest {
    // simple struct with fields we will use to test dot notation and specs
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    public fun make_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    public fun get_x(p: &Point): u64 {
        p.x
    }
}
 
//# run
script {
    use 0xCAFE::SpecTest;

    /// # Move Specification
    /// 
    /// Ensures the point created has x = 3 and y = 4.
    /// 
    /// ```spec
    /// let p = SpecTest::make_point(3, 4);
    /// assert!(SpecTest::get_x(&p) == 3);
    /// ```
    fun main() {
        let p = SpecTest::make_point(3, 4);
        let _x = SpecTest::get_x(&p);
    }
}

// Featurres:
// 9fd62ea3370c57398899b86c1c46384f: Create complex and nested types such as tuples, function types, and type applications with parameters.
// ad85128a36447a8cf9a6445270a1bf6e: Access fields in a struct using dot notation
// 13675b7ad6c379aec27010a3c83483ad: Attach and filter Move specification blocks (specs) to scripts.
