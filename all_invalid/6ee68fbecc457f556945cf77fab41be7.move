
//# publish
module 0xCAFE::ExpressionTest {
    use std::debug;

    enum Foo has copy, drop {
        A(u64, u64),
        B(u64),
    }

    public fun test(): u64 {
        let x = 0u64;

        // Each block assigns and uses the updated x during expression evaluation.
        let y = {
            x = x + 1;
            x
        } + {
            x = x + 2;
            x
        } + {
            x = x + 4;
            x
        };

        // y should be 1 + 3 + 7 = 11, because:
        // first block: x=0+1=1, returns 1
        // second block: x=1+2=3, returns 3
        // third block: x=3+4=7, returns 7
        // sum = 1+3+7=11

        y
    }

    public fun common_access(f: Foo): u64 {
        match f {
            Foo::A(a, _) => a,
            Foo::B(a) => a,
        }
    }
}



//# run 0xCAFE::ExpressionTest::test



//# run 0xCAFE::ExpressionTest::common_access --args 'A 123 456'



//# run 0xCAFE::ExpressionTest::common_access --args 'B 789'
