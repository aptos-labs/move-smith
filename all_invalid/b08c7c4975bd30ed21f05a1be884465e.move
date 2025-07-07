
//# publish
module 0xCAFE::StacklessOptimizationTest {
    use std::debug;

    public struct X has copy, drop {
        val: u8
    }

    // Enum with variant names starting with uppercase letters
    public enum AlphaEnum has copy, drop {
        A,
        B(u8),
        C { Value: u8 }
    }

    public fun update_directly(x: u8): u8 {
        let v = x;
        v = v + 1;
        v = v * 2;
        v
    }

    public fun update_in_expression(s: X): u8 {
        // The expression modifies s.val but returns s.val + 1
        let new_val = (
            {
                let updated_val = s.val + 1;
                X { val: updated_val }
            }
        ).val + 1;
        new_val
    }

    public fun side_effect_order(): (u8, u8) {
        let a = 1u8;
        let b = 2u8;

        // side effect in argument evaluation order test
        let r = Self::add_then_increment(&mut a, &mut b);
        (a, b)
    }

    fun add_then_increment(a: &mut u8, b: &mut u8): u8 {
        let res = *a + *b;
        *a = *a + 1;
        *b = *b + 1;
        res
    }

    // Runner function without args to test enum usage
    public fun enum_usage_runner(): u8 {
        let a = AlphaEnum::A;
        let b = AlphaEnum::B(10);
        let c = AlphaEnum::C { Value: 5 };

        let sum = match a {
            AlphaEnum::A => 1,
            AlphaEnum::B(x) => x,
            AlphaEnum::C { Value } => Value,
        } + match b {
            AlphaEnum::A => 1,
            AlphaEnum::B(x) => x,
            AlphaEnum::C { Value } => Value,
        } + match c {
            AlphaEnum::A => 1,
            AlphaEnum::B(x) => x,
            AlphaEnum::C { Value } => Value,
        };

        sum
    }
}


//# run 0xCAFE::StacklessOptimizationTest::update_directly --args 3u8


//# run 0xCAFE::StacklessOptimizationTest::update_in_expression --args 0xCAFE::StacklessOptimizationTest::X { val: 4u8 }


//# run 0xCAFE::StacklessOptimizationTest::side_effect_order


//# run 0xCAFE::StacklessOptimizationTest::enum_usage_runner


// Featurres:
// 28277c32ad3fb6b073e3e1ad62644152: Perform stackless bytecode optimization passes in a configurable pipeline.
// 2c1bc98e3cb353436381d41b0b9e8e09: Test that the Move language correctly handles both direct variable modifications and struct-like expressions within function calls, including order and side effects.
// 63949fbb5139c8cf84ce3283660c1dd3: Name struct variants with identifiers starting with an uppercase letter ('A'..'Z').
