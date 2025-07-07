
//# publish
module 0xCAFE::SpecTest {
    spec module {
        // Specification function in spec block
        fun spec_add(a: u64, b: u64): u64 {
            a + b
        }

        native fun native_spec_mul(a: u64, b: u64): u64;

        spec fun spec_complicated(x: u64): u64 {
            let y = spec_add(x, 5);
            let z = native_spec_mul(y, 2);
            z
        }
    }

    public fun call_spec_functions(x: u64): u64 {
        let a = spec_add(x, 10);
        let b = native_spec_mul(a, 3);
        b
    }

    native public fun native_spec_mul(x: u64, y: u64): u64;

    public fun runner(): u64 {
        call_spec_functions(7)
    }
}


//# run 0xCAFE::SpecTest::call_spec_functions --args 10u64


//# run 0xCAFE::SpecTest::runner


//# publish
module 0xCAFE::ModA {
    public fun foo(x: u8): u8 {
        x + 1
    }

    public fun runner(): u8 {
        foo(5)
    }
}


//# publish
module 0xCAFE::ModB {
    use 0xCAFE::ModA;

    public fun bar(y: u8): u8 {
        let x = ModA::foo(y);
        x * 2
    }

    public fun runner(): u8 {
        bar(4)
    }
}


//# publish
module 0xCAFE::ModC {
    use 0xCAFE::ModA;
    use 0xCAFE::ModB;

    public fun baz(z: u8): u8 {
        let a = ModA::foo(z);
        let b = ModB::bar(z);
        a + b
    }

    public fun runner(): u8 {
        baz(3)
    }
}


//# run 0xCAFE::ModA::foo --args 10u8


//# run 0xCAFE::ModB::bar --args 5u8


//# run 0xCAFE::ModC::baz --args 2u8


//# run 0xCAFE::ModA::runner


//# run 0xCAFE::ModB::runner


//# run 0xCAFE::ModC::runner


// Featurres:
// f3a04639cbf00572c112bac1cda633ed: Define specification functions or native specification functions using the 'fun' or 'native' keywords in spec blocks.
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// ae7648d2f1a91ce9629afa86e0cd2a86: Include multiple modules under a single named address in Move packages.
