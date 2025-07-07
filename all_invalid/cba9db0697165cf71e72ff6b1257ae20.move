// Example Aptos transactional test for Move VM and compiler
// Address: 0xCAFE

// ------------------------------------------------------------
//# publish
module 0xCAFE::MathUtils {
    // Test for feature 2: public, friend, and private functions
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    // Only visible in 0xCAFE::MathUtils and friend modules
    friend fun double(x: u64): u64 {
        x * 2
    }

    // Private function (default if no visibility given)
    fun triple(x: u64): u64 {
        x * 3
    }

    // Public entry to test internal/private function calls
    public fun mults(x: u64): (u64, u64) {
        let d = double(x);
        let t = triple(x);
        (d, t)
    }

    // Test for feature 3: log variable states
    public fun show_variable_states(): u64 {
        let x = 10;
        let y = 3;
        let s = x + y;
        let d = x - y;
        let m = x * y;
        // log variables before instruction
        aptos_std::debug::print(&b"x before=10, y before=3, s after add=13, d after sub=7, m after mul=30");
        s + d + m
    }

    public fun runner(): u64 {
        // Call add (public)
        let sum = add(40, 2);

        // Call internal functions
        let (d, t) = mults(7);

        // Call show_variable_states
        let total = show_variable_states();

        sum + d + t + total
    }
}
//# run 0xCAFE::MathUtils::runner --signers 0xCAFE

// ------------------------------------------------------------
//# publish
module 0xCAFE::Caller {
    // Making MathUtils a friend
    friend 0xCAFE::MathUtils;

    public fun try_math_calls(): u64 {
        // Test for feature 2: calling public function from another module
        let p = 0xCAFE::MathUtils::add(100, 200);

        // Test: friend function not available (should not be allowed unless module is friend)
        // let q = 0xCAFE::MathUtils::double(5); // This line would fail if un-commented since not friend

        // Test for built-in function call (feature 1): vector::length
        let v = vector[1u8, 2u8, 3u8, 4u8];
        let n = vector::length<u8>(&v); // Built-in function call with specified location, type argument

        // Test for feature 3: log states
        aptos_std::debug::print(&b"p=300, n=4");

        p + (n as u64)
    }

    // For runner
    public fun runner(): u64 {
        try_math_calls()
    }
}
//# run 0xCAFE::Caller::runner --signers 0xCAFE

// ------------------------------------------------------------
//# run
script {
    // Test built-in function call (feature 1) in script, calling module's public function
    fun main(account: &signer) {
        let v = vector[10u8, 20u8, 30u8, 40u8];
        let n = vector::length<u8>(&v); // built-in
        aptos_std::debug::print(&b"Vec length in script");
        let s = 0xCAFE::MathUtils::add(n as u64, 5);
        let _ = s;
    }
}

// ------------------------------------------------------------
//# publish
module 0xCAFE::VarTrace {
    public fun variable_logging_example(): u64 {
        let a = 12;
        aptos_std::debug::print(&b"a initialized=12");
        let b = 8;
        aptos_std::debug::print(&b"b initialized=8");
        let c = a * b;
        aptos_std::debug::print(&b"c=a*b=96");
        let d = c + 1;
        aptos_std::debug::print(&b"d=c+1=97");
        d
    }

    public fun runner(): u64 {
        variable_logging_example()
    }
}
//# run 0xCAFE::VarTrace::runner --signers 0xCAFE

// Featurres:
// 5a520cf07a0f696135381fdd5e8fd426: Create a built-in function call with a specified location, name, optional type arguments, and list of expressions as arguments.
// 0cc62a3217f97e8703f73eb151a98449: Ensure that functions called across modules are accessible based on their visibility and the calling context.
// d4d86b2b4034f80cf9d967a21ee064f2: View the initialized state of variables before and after each instruction in a Move function.
