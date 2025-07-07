//# publish
module 0xabc::nested_enum_test {
    enum Outer {
        X(Inner),
        Y,
    } has drop;

    enum Inner {
        Z(Deep),
        W,
    } has drop;

    enum Deep {
        Val(u128),
    } has drop;

    // Test pattern matching with nested enums with drop semantics
    fun match_nested(x: Outer) {
        match (x) {
            Outer::Y => (),
            Outer::X(Inner::Z(Deep::Val(v))) => {
                // do nothing, just match
            },
            Outer::X(Inner::W) => (),
        }
    }

    // Runner function to test nested pattern matching
    public fun run_test() {
        let a = Outer::Y;
        match_nested(a);

        let b = Outer::X(Inner::W);
        match_nested(b);

        let c = Outer::X(Inner::Z(Deep::Val(999)));
        match_nested(c);
    }
}

//# run 0xabc::nested_enum_test::run_test

//# publish
module 0xabc::vector_sum {
    use std::vector;

    // Function to sum elements in a vector of u64
    public fun sum_vector(v: &vector<u64>): u64 {
        let total = 0;
        let len = vector::length(v);
        let i = 0;
        while (i < len) {
            let e = *vector::borrow(v, i);
            total = total + e;
            i = i + 1;
        }
        total
    }

    // Test function to create a vector, sum its elements
    public fun run() : u64 {
        let v = vector[10u64, 20, 30, 40, 50];
        sum_vector(&v)
    }
}

//# run 0xabc::vector_sum::run