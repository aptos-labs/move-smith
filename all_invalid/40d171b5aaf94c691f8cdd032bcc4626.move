
//# publish
module 0xBADD::PackageA {
    use std::vector;

    // Constant with attribute
    // storage_only]
    const SECRET_VALUE: u16 = 42;

    // Struct with attribute
    // derive(Copy, Drop)]
    struct InnerStruct has copy, drop {
        data: u8,
        flag: bool,
    }

    // Enum with attribute
    // error handling]
    enum Status {
        Init,
        Success(u64),
        Fail { code: u8 }
    }

    // Public function with attribute
    public fun process_value(x: u8): u8 {
        if (x > 10) {
            x
        } else {
            10
        }
    }

    // Another public function that uses match pattern
    public fun match_status(s: Status): u64 {
        match (s) {
            Status::Init => 0,
            Status::Success(v) => v,
            Status::Fail { code } => {
                // If code == 1, return 1, else 0
                if (code == 1) {
                    1
                } else {
                    0
                }
            }
        }
    }
}


//# run 0xBADD::PackageA::process_value --args 11u8


//# run 0xBADD::PackageA::match_status --args "Status::Success(12345u64)"


// Featurres:
// 3ba0e027595ad3cb8756d7a09922a084: Restrict direct calls to functions from different packages to enforce package boundaries.
// dc97784057e0582c260f6ae7aae13485: Annotate module members (functions, constants, structs) with attributes
// 3f59cfdd493ab80f28bf33bd8d131657: Use `match` expressions with pattern arms for value matching.
