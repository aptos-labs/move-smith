
//# publish
module 0xDEADBEEF::VectorTest {
    use std::vector;
    use std::signer;
    use 0xDEADBEEF::MyModule;

    // Helper function to pop bytes from vector and sum them
    public fun sum_bytes(v: &mut vector<u8>): u8 {
        let total: u8 = 0;
        while (vector::length(v) > 0) {
            let b = vector::pop_back(v);
            total = total + b;
        }
        total
    }

    // Function to run test: prepare vector with 10 bytes, pop and sum
    public fun test_sum() {
        let vec: vector<u8> = vector::empty();
        let i: u8 = 1;
        let sum: u8 = 0;

        // Push bytes 1..=10
        while (i <= 10) {
            vector::push_back(&mut vec, i);
            i = i + 1;
        }

        sum = sum_bytes(&mut vec);
        // The sum should be 55 (1+2+...+10)
        assert!(sum == 55, 1000);
        sum
        // last expression is the return value
    }

    // Struct and enum assignment, control flow, mutability, etc.
    struct MyStruct has copy, drop {
        a: u64,
        b: bool,
    }

    enum MyEnum has copy, drop {
        Variant1,
        Variant2(u8, u8),
        Variant3 { flag: bool },
    }

    public fun complex_control_flow(flag: bool, value: u8): (MyStruct, MyEnum, u8) {
        let s: MyStruct;
        let e: MyEnum;
        let res: u8;

        if (flag) {
            s = MyStruct { a: 42, b: true };
            e = MyEnum::Variant2(1, 2);
            res = value + 1;
        } else {
            s = MyStruct { a: 0, b: false };
            e = MyEnum::Variant3 { flag: false };
            res = value;
        };

        // Loop example: count down from 3
        let counter: u8 = 3;
        loop {
            if (counter == 0) {
                break;
            };
            counter = counter - 1;
        };

        // Pattern match on enum
        let new_res: u8 = match e {
            MyEnum::Variant1 => 10,
            MyEnum::Variant2(x, y) => x + y,
            MyEnum::Variant3 { flag: f } => if (f) { 1 } else { 0 },
        };

        (s, e, new_res)
    }

    // Processing package with modules and address mappings
    // (Note: Normally in transactional tests, package definitions would be interpreted inline)
    module 0xDEADBEEF::InnerModule {
        public fun inner_func(): u64 {
            999
        }
    }

    public fun package_process() {
        let value = 0xDEADBEEF::InnerModule::inner_func();
        assert!(value == 999, 2000);
    }
}


//# run 0xDEADBEEF::VectorTest::test_sum
//

//# run 0xDEADBEEF::VectorTest::complex_control_flow --args true 5u8

// Featurres:
// 1a658f6f9dabec2e3b18caae10e6fe91: Test that repeatedly popping bytes from a vector and summing their values correctly results in the expected total (10).
// a19b33529bfd56ad7415f20e92ba7763: Test basic struct and enum assignments, mutable references, and control flow constructs such as loops and pattern matching in Move modules.
// dbc94bb18575b7ab61689e75eac66ec5: Process package definitions to include modules and address mappings.
