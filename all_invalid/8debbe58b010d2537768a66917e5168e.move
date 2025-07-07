// 1. Pragma usage; package-level module
//# publish
module pragma_one {
    #![pragma(author = "alice")]
    #![pragma(version = 1)]

    public fun runner() {
        let i = 0;
        let res = 0;
        // Tests simple use of 'break' and 'continue' with and without labels
        label_outer: while (i < 10) {
            let j = 0;
            while (j < 5) {
                if (i == 2 && j == 3) {
                    break label_outer; // break with a label
                }
                if (j == 2) {
                    j = j + 1;
                    continue; // continue without a label
                }
                j = j + 1;
            }
            i = i + 1;
        }
    }
}

//# run pragma_one::runner

// 2. Pragma usage; address-specific module
//# publish
module 0xCAFE::pragma_two {
    #![pragma(custom_flag)]
    #![pragma(custom_value = 42)]

    public fun runner() {
        let sum = 0;
        let found = false;
        let x = 0u8;
        // nested loop, inner loop with labelled continue, outer with labelled break
        'search: while (x < 10) {
            let y = 0u8;
            while (y < 10) {
                if (y == 5u8) {
                    y = y + 1;
                    continue; // unlabelled continue
                }
                if (x == 7u8 && y == 7u8) {
                    found = true;
                    break 'search; // labelled break
                }
                y = y + 1;
            }
            x = x + 1;
        }
    }
}
//# run 0xCAFE::pragma_two::runner --signers 0xCAFE

// 3. Script using break/continue + pragma (pragma in scripts)
//# run
script {
    #![pragma(checked = true)]

    fun main() {
        let res = 0;
        let i = 0u8;
        // simple loop with continue and break
        while (i < 5u8) {
            if (i == 2u8) {
                i = i + 1;
                continue;
            }
            if (i == 4u8) {
                break;
            }
            i = i + 1;
        }
    }
}