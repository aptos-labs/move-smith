//# publish
module 0x1::UniqueIdTest {
    fun unique_id(): u64 {
        // Return a unique numeric id representing this module
        // We simulate unique id by returning a hardcoded id.
        0x1u64
    }

    // Runner function to test uniqueness (dummy test)
    public fun runner() {
        let id = unique_id();
        // Just read unique_id to ensure compilation.
        // No assertions needed.
    }
}
//# run 0x1::UniqueIdTest::runner

//# publish
module 0x2::UniqueIdTest {
    fun unique_id(): u64 {
        0x2u64
    }

    public fun runner() {
        let id = unique_id();
    }
}
//# run 0x2::UniqueIdTest::runner

//# publish
module 0x3::VariableBindings {
    /// Test variable bindings and destructuring
    public fun runner() {
        // Binding variable
        let x = 10u64;
        let (a, b) = (1u8, 2u8);

        // Shadowing variable
        let x = x + 5;
        let (x, y) = (x, a + b);

        // Just read variables so code does not optimize away
        let _ = x + y as u64;
    }
}
//# run 0x3::VariableBindings::runner

//# publish
module 0x4::InlineHigherOrderClosures {
    /// A function that takes another function and a value, applies the function to the value, returns result
    fun apply<F: copy + drop + store>(func: &F, x: u64): u64
    // NOTE: Move does not support generics as in Rust for functions standalone, so using an inline "anonymous function" with a function pointer type is limited.
    // Instead, inline function and higher order functions are approximated with fun pointers via function references.
    {
        // inline function style just call func(x)
        // But Move does not support function pointer directly, so we simulate with closure-like pattern by inline code.
        // In Move, 'fun' usually is a named function, so simulate with call.
        func.call(x)
    }

    public fun plus_one(x: u64): u64 {
        x + 1
    }

    public fun runner() {
        // Higher order function: call plus_one via apply
        // Since Move does not support function pointers strictly, we simulate with direct call.
        let result = plus_one(41u64);
        let _ = result;

        // Anonymous closure simulation: local function inside runner
        // Move doesn't support anonymous functions yet, so we test inline:
        let inline_func = plus_one;
        let result2 = inline_func(99u64);
        let _ = result2;
    }
}
//# run 0x4::InlineHigherOrderClosures::runner

//# publish
module 0x5::Conditionals {
    public fun runner() {
        // if_else with then and else
        let x = 10;
        let y = if x > 5 {
            100
        } else {
            200
        };

        // if_else with no else (optional else)
        // Move requires else branch for if expressions; to simulate optional else, use if statement:
        if x < 5 {
            // do nothing
        };

        // Use inline if_else expressions multiple times
        let z = if y > 150 { 1u8 } else { 2u8 };

        let _ = y + (z as u64);
    }
}
//# run 0x5::Conditionals::runner

//# run
script {
    use 0x1::UniqueIdTest;
    use 0x2::UniqueIdTest;
    use 0x3::VariableBindings;
    use 0x4::InlineHigherOrderClosures;
    use 0x5::Conditionals;

    fun main() {
        // Call both UniqueIdTest.runers to verify uniqueness of module ids (should succeed compilation with different modules)
        UniqueIdTest::runner();
        0x2::UniqueIdTest::runner();

        // Test VariableBindings module runner
        0x3::VariableBindings::runner();

        // Test InlineHigherOrderClosures runner
        0x4::InlineHigherOrderClosures::runner();

        // Test Conditionals runner
        0x5::Conditionals::runner();
    }
}