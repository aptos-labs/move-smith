
//# publish
module 0xCAFE::TestTupleAndAbilities {
    // Sequential abilities with comma-separated list after 'has'
    struct Data has copy, drop, store {
        a: u64,
        b: u64,
    }

    public fun compute_and_mutate(x: u64, y: u64): u64 {
        // Tuple destructuring and mutation in expression scope
        let (mut_p, mut_q) = (x, y);
        {
            mut_p = mut_p + 10;
            mut_q = mut_q + 20;
            mut_p + mut_q
        }
    }

    public fun add_tuple_fields(data: Data): u64 {
        let Data {a, b} = data;
        a + b
    }

    public fun runner(): u64 {
        let init = (3u64, 7u64);
        let (v1, v2) = init;
        let interim = compute_and_mutate(v1, v2);
        let d = Data { a: interim, b: 5u64 };
        let total = add_tuple_fields(d);
        total
    }
}


//# run 0xCAFE::TestTupleAndAbilities::runner



//# publish
module 0xCAFE::ExitStateVisualization {
    // Visualize exit state analysis by bytecode comments for debugging

    public fun simple_add(a: u8, b: u8): u8 {
        // Bytecode representation (pseudocode):
        // 0: load a
        // 1: load b
        // 2: add
        // 3: return
        a + b
    }

    public fun loop_sum(n: u8): u8 {
        // Bytecode (pseudocode):
        // 0: load n
        // 1: init sum = 0
        // 2: loop_start:
        // 3: check i < n
        // 4: add i to sum
        // 5: increment i
        // 6: jump to loop_start or exit
        // 7: return sum
        let sum = 0u8;
        let i = 0u8;
        while (i < n) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    public fun runner(): u8 {
        let add_result = simple_add(5u8, 10u8);
        let loop_result = loop_sum(6u8);
        add_result + loop_result
    }
}


//# run 0xCAFE::ExitStateVisualization::runner


// Featurres:
// aa3a79fbc8f4c1458f141ee16e2d9f7d: Test that tuple destructuring and variable mutation within an expression scope produce the correct values when returning and summing results.
// 949da64cd2f6ac426e454f9d89ed0665: Declare multiple abilities sequentially after the 'has' keyword, allowing for a comma-separated list.
// e939c3053bed69e5d55cdedf93bdb14e: Visualize exit state analysis as bytecode annotations for debugging purposes.
