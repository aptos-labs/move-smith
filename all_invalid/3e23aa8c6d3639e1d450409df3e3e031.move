
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



//# run 0xCAFE::ControlFlowTest::read_struct_fields --args &0xCAFE::ControlFlowTest::create_struct()
