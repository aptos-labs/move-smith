
//# publish
module 0xCAFE::NestedStructs {
    struct InnerMost has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct Inner has copy, drop, store {
        x: InnerMost,
        y: u8,
    }

    struct Outer has copy, drop, store {
        first: Inner,
        second: u8,
    }

    // Rewritten specifications inside this module
    spec module {
        // invariant that all u8 fields in Outer should be less than 100
        invariant forall o: Outer :: 
          o.first.x.a < 100 && o.first.x.b < 100 && o.first.y < 100 && o.second < 100;
    }

    public fun test(): u8 {
        let inner_most = InnerMost { a: 10, b: 20 };
        let inner = Inner { x: inner_most, y: 30 };
        let outer = Outer { first: inner, second: 40 };

        // Access all nested fields using chained dot operator
        let a_val = outer.first.x.a;
        let b_val = outer.first.x.b;
        let y_val = outer.first.y;
        let second_val = outer.second;

        // sum all values to test access and return the sum
        a_val + b_val + y_val + second_val
    }
}


//# run 0xCAFE::NestedStructs::test


// Featurres:
// 144d392878d634a9938c334f29348413: Nest field access expressions using multiple dot operators
// f3ed1b5746a89b81a2e291455118a7ae: Rewrite specifications in Move modules during compilation for improved analysis or verification.
// 10c39196ee09f2fb225b8a6872499049: Test that the `test` function correctly initializes a struct with incremented field values and returns their sum.
