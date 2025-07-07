//# publish
module 0x1::UniqueModuleA {
    // A simple function to be run: returns 42
    public fun runner(): u64 {
        42
    }
}
//# run 0x1::UniqueModuleA::runner


//# publish
module 0x2::UniqueModuleB {
    // Reference safety test - borrow a reference and use it safely
    public fun runner(): u64 acquires u64 {
        let x = 100u64;
        let r = &x;
        // dereference the reference and return value
        *r
    }
}
//# run 0x2::UniqueModuleB::runner


//# publish
module 0x3::ConditionalBranching {
    // Demonstrates if_else expressions with then and optional else

    public fun runner(): u8 {
        let x = 10u8;
        let result = if (x > 5) {
            1u8
        } else {
            0u8
        };
        result
    }
}
//# run 0x3::ConditionalBranching::runner


//# publish
module 0x4::BinaryOpSequence {
    // Uses a binary operation with trivial sequences (side-effect free)
    public fun runner(): u64 {
        let a = 3u64;
        let b = 4u64;

        // trivial sequences: single expressions
        (a + b) * (a - 1u64)
    }
}
//# run 0x4::BinaryOpSequence::runner


//# publish
module 0x5::ScriptWithConstants {
    // Defines constants with valid module member names
    const MAX_VALUE: u8 = 255;
    const MIN_VALUE: u8 = 0;

    public fun runner(): u8 {
        // use constants in an expression
        MAX_VALUE - MIN_VALUE
    }
}
//# run 0x5::ScriptWithConstants::runner


//# run
script {
    // Uses address specifier 'Literal' to specify a concrete address directly in script

    const MY_CONST: u64 = 1234;

    fun main() {
        // address literal 0xDECAF (Literal syntax is the hex literal directly used in Move)
        let addr = @0xDECAF;
        let val = MY_CONST + 6u64;
    }
}