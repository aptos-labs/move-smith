
//# publish
module 0xCAFE::ControlFlowTest {
    struct Dummy has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun run_control_flow(): u8 {
        let x = 0u8;

        let z = {
            let a = {
                let b = 1u8;
                b // this should return 1
            };
            x = a + 1;
            x // should be 2 here
        };

        if (z > 0) {
            x = z * 2;
        } else {
            x = 0;
        };

        {
            if (x > 10) {
                let _ = 100u8; // dead code in this branch, never taken since x=4
            } else {
                x = x + 1;
            };
            // x should be 5 here
        };

        x // should return 5
    }

    public fun dead_code_elimination_test(): u8 {
        let x = 10u8;
        let y = 20u8;
        let _dead = 30u8; // never used: dead code

        {
            let a = 5u8;
            let _unused = a * 2; // dead store
            x + y + a // 10+20+5=35
        }
    }

    struct HasFields has store {
        id: u64,
        flag: bool,
    }

    public fun create_struct(): HasFields {
        HasFields {
            id: 42u64,
            flag: true,
        }
    }

    public fun read_struct_fields(h: &HasFields): (u64, bool) {
        (h.id, h.flag)
    }
}


//# run 0xCAFE::ControlFlowTest::run_control_flow


//# run 0xCAFE::ControlFlowTest::dead_code_elimination_test


//# run 0xCAFE::ControlFlowTest::create_struct


//# run 0xCAFE::ControlFlowTest::read_struct_fields --args @0xCAFE


// Featurres:
// 86f8adf1e0f084864bf8f1a02cbe9d90: Test that variable assignments and returns within code blocks are evaluated in the correct order and that control flow behaves as expected within expression blocks.
// 02a6b7099c2e89ce595efd077846f2bf: Apply dead code elimination to remove unreachable code and unnecessary stores.
// 242e7882aa1263866d1af91f1f1e6e5a: Specify struct fields with designated signatures and names.
