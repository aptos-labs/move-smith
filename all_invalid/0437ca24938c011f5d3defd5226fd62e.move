//# publish
module 0xCAFE::TestStruct {
    struct Data has copy, drop, store {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    public fun make_data(): Data {
        Data {
            a: 10,
            b: true,
            c: vector::empty<u8>(),
        }
    }
}

//# publish
module 0xCAFE::TestQuantifiers {
    use std::vector;

    // An example function using quantifiers in specifications
    public fun quantifier_example(input: vector<u64>): bool {
        // no real body needed; just to exercise parsing of quantifiers in specs
        true
    }

    spec quantifier_example {
        // forall x in input: x > 0
        forall x in input {
            x > 0
        };

        // exists y in input: y == 42
        exists y in input {
            y == 42
        };
    }
}

//# publish
module 0xCAFE::TestLoopFlag {
    public fun run_loop(): u64 {
        let mut sum = 0;
        let mut continue_loop = true;
        let mut i = 0;

        // A loop that will iterate until continue_loop is false
        while (continue_loop) {
            sum = sum + i;
            i = i + 1;
            if (i > 4) {
                continue_loop = false;
            }
        }
        sum
    }
}

//# run 0xCAFE::TestStruct::make_data

//# run 0xCAFE::TestQuantifiers::quantifier_example --args vector<u64>[1,2,42,4,5]

//# run 0xCAFE::TestLoopFlag::run_loop

// Featurres:
// 107f519cdb04a9583c77986ee754dd01: Define struct fields with types, and ensure each field has a unique name within the struct definition.
// 89191f8c80cf96615942157c5298890e: Write quantifiers using special identifier syntax (e.g., 'forall', 'exists').
// 02ddddc8c7ed4418eac57bec95bfb8cc: Declare and initialize a loop flag variable to control iteration state within the 'for' loop.
