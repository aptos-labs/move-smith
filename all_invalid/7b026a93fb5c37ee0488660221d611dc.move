
//# publish
module 0xDEADBEEF::FeatureTestModule {
    use std::vector;
    use 0xCAFE::MyModule;

    // Specification block for f1
    // [property: always returns x + 1]
    // [property: if y is true, the returned value is x + 1; else x + 1]
    public fun spec_f1(x: u8, y: bool): u8 {
        x + 1
    }

    // Specification block for f2
    // [property: returns a tuple (a+1, a+2)]
    public fun spec_f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Specification block for f3
    // [property: constructs S with fields derived from x]
    public fun spec_f3(x: u16): S {
        let (a, b) = spec_f2(x);
        let s = S {x: a as u32, y: b as u32};
        s
    }

    // Specification for f4
    // [property: matches enum e and assigns expected value to x]
    public fun spec_f4() {
        let e1 = E::V1;
        let e2 = E::V2(3, 4);
        let e3 = E::V3 { a: true };

        let handle_e = |e: E| -> u32 {
            match (e) {
                E::V1 => 1,
                E::V2(x, y) => x + y,
                E::V3 { a } => if (a) { 2 } else { 3 },
            }
        };

        let val1 = handle_e(e1);
        let val2 = handle_e(e2);
        let val3 = handle_e(e3);
        // Implicit property: val2 == 7, val3 == 2
        assert!(val1 == 1, 999);
        assert!(val2 == 7, 998);
        assert!(val3 == 2, 997);
    }

    // Specification: lambda behaves as function adding two u8s
    // [property: outputs c = a + b, d = a * b]
    public fun spec_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(a, b)
    }

    // Specification: function f6 applies a macro (closure)
    // [property: applies function x to y]
    public fun spec_f6(x: |u8| u8, y: u8): u8 {
        x(y)
    }

    // Test property: string literals
    public fun spec_f7() {
        let byte_string: vector<u8> = b"TestString";
        let hex_string: vector<u8> = x"abcdef";

        // Property: byte string length > 0
        assert!((vector::length(&byte_string) > 0), 995);
        // Property: hex string equals expected bytes
        assert!((vector::length(&hex_string) == 3), 996);
    }
}



//# run 0xDEADBEEF::FeatureTestModule::spec_f1 --args 5u8 false
//


//# run 0xDEADBEEF::FeatureTestModule::spec_f2 --args 20u16
//


//# run 0xDEADBEEF::FeatureTestModule::spec_f3 --args 15u16
//


//# run 0xDEADBEEF::FeatureTestModule::spec_f4
//


//# run 0xDEADBEEF::FeatureTestModule::spec_lambda --args 3u8 4u8
//


//# run 0xDEADBEEF::FeatureTestModule::spec_f6 --signers 0xBEEF --args |u8| u8 = |a: u8, b: u8| {a + b} |, 5u8
//


//# run 0xDEADBEEF::FeatureTestModule::spec_f7

// Features:
// 4d32d27fed111cd29488ff84a78d2e31: Write spec blocks in Move modules to specify formal properties or documentation.
// 796915427923940fa614e2749935cd9f: Import and use dependencies from other modules in your module or script.
// 6a92a012959641e21785876cf7955ab5: Annotate conditions with one or more properties using square brackets