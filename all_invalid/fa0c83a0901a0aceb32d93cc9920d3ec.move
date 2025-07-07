// This transactional test covers:
// 1. variable binding in patterns (with unbound names in 'range' list binding)
// 2. use of optional type parameters inside 'spec' patterns
// 3. ensures scripts do *not* use lambda-lifted functions

//-------------------- MODULE 1: variable binding (pattern with unbound 'b') --------------------------
//# publish
module 0x1::BindTest {
    use std::vector;

    // function that uses a for loop with pattern binding in a range list
    public fun runner() {
        // bind variable 'b' in the pattern of the for loop's range list
        let sum = &mut 0u64;
        for b in 0u8..4u8 {
            *sum = *sum + b as u64;
        };
        // dummy use so it's not warned as dead code
        let _ = *sum;
    }
}

//# run 0x1::BindTest::runner --signers 0x1

//-------------------- MODULE 2: optional type parameters in spec patterns --------------------------
//# publish
module 0x2::SpecTypeParamTest {
    struct Wrapper<T>(T);

    public fun wrap<T>(t: T): Wrapper<T> {
        Wrapper(t)
    }

    public fun runner() {
        let w = Self::wrap(55u8);
        // just a dummy use of the struct to satisfy the compiler
        let _ = w;
    }

    spec wrap<T: copy>(
        t: T
    ) {
        // Specify an optional type parameter in the spec
        // Normally you may check properties for generic arguments
        // Here's a dummy axiom using an optional type param
        // (This is a no-op, for type-check coverage)
        ensures true;
    }
}

//# run 0x2::SpecTypeParamTest::runner --signers 0x2

//--------------------- SCRIPT: No lambda lifting allowed in scripts -----------------------------
//# run
script {
    fun main() {
        let x = 10u64;
        // try to create and use a normal local function (NOT a lambda!)
        // Lambda lifting would be: let f = |y| x + y;
        // Instead we simply call directly (no nested functions)
        let y = x * 2;
        let _ = y;
    }
}