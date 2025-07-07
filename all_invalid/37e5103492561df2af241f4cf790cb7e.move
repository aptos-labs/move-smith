
// test_only]
//# publish
module 0xCAFE::AttributeTesting {
    use std::vector;

    // inline]
    public fun no_args() {}

    // inline]
    // test_only]
    public fun multiple_attributes(x: u8): u8 {
        // use vector::empty even if not 'use'd explicitly (actually imported here), to test dependency tracking
        let _v = vector::empty<u8>();
        x
    }

    // inline]
    public fun empty_vector_items() {
        // empty item lists between delimiters: tuple with empty tuple inside
        let _empty_tuple: (()) = (());
        let _empty_vec: vector<u8> = vector[];
    }

    // inline]
    public fun ensure_no_critical_edges(x: u8): u8 {
        let val = x;
        // construct multiple branches and loops with early breaks to ensure no critical edges in bytecode
        if (val > 10) {
            val = val - 5;
        } else {
            val = val + 5;
            if (val > 15) {
                val = 0;
            };
        };
        while (val < 10) {
            if (val == 3) {
                break;
            };
            val = val + 1;
        };
        val
    }

    // inline]
    public fun call_with_args(x: u8, y: u8): u8 {
        // call functions with arguments
        no_args();
        multiple_attributes(x);
        ensure_no_critical_edges(y)
    }

    // inline]
    public fun runner(): u8 {
        call_with_args(7u8, 8u8)
    }
}


//# run 0xCAFE::AttributeTesting::runner


//# run 0xCAFE::AttributeTesting::call_with_args --args 20u8 5u8


// Featurres:
// a9d2adcb1f17b70532c07980a4451c57: Annotate Move items (modules, functions, etc.) with single or multiple attributes.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// f0b018110a66295be45449caa5ffcaac: Permit empty item lists between supported delimiters by omitting elements entirely.
// c62af4c957af48fcf0e166c5959469f0: Ensure Bytecode is free of critical edges before execution.
// c185274deb99a3838ded6c765228f460: Call functions with arguments by following a name with '(' and argument expressions (e.g., foo(1, 2)).
