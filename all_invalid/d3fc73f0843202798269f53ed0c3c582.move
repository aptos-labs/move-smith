// Thorough transactional test for Move compiler and VM on Aptos.
// NOTE: Per instructions, address aliases are NOT used. All addresses are written out fully.
// Spec functions and grouping expressions via parentheses/braces are explicitly shown.

//# publish
module 0xCAFE::SpecParenthesesTest {
    /// A simple struct, with copy and drop so we can play with values easily.
    struct Data has copy, drop, store {
        value: u64,
    }

    /// Returns a new Data object with the given value
    public fun new_data(v: u64): Data {
        Data { value: v }
    }

    /// Doubles the value via parentheses demonstration
    public fun double_braces_parens(x: u64): u64 {
        // Parentheses for grouping, braces for code blocks
        let doubled = (x + x);
        // use extra braces as a block (should compile)
        {
            let tmp = doubled * 2 + (1 + 1);
            tmp
        }
    }

    /// Call this to hit grouping calls and Data struct
    public fun grouping_runner() {
        let d1 = new_data({10 + (20)});
        let d2 = new_data((d1.value * 2) + (5 - 3));
        let r = double_braces_parens(d2.value + 15);
        // drop all
        let _ = (d1, d2, r);
    }

    /// A function to demonstrate extra parentheses in expressions and function calls
    public fun paren_expr_fun(a: u8, b: u8): u8 {
        // Move's `as` casts work only for one operand at a time,
        // (a as u16 + b as u16) is parsed as ((a as u16), +, (b as u16)).
        // But `(a as u16) + (b as u16)` is valid as both sides are u16.
        let res = (a + b) * (((a as u16) + (b as u16)) as u8);
        ((res) + (2))
    }

    public fun paren_expr_runner() {
        let x = paren_expr_fun(({8+1}), (2 + 3));
        let _ = x;
    }

    /// Spec fun: square of a value
    spec fun square(x: u64): u64 {
        x * x
    }

    /// Spec fun: just a boolean predicate with grouping parens
    spec fun is_even(n: u8): bool {
        ((n % 2) == 0)
    }

    /// Spec uses spec funs
    spec double_braces_parens {
        // Postcondition: result is even (since doubling preserves parity)
        ensures is_even(result as u8);
    }
}

//# run 0xCAFE::SpecParenthesesTest::grouping_runner --signers 0xCAFE

//# run 0xCAFE::SpecParenthesesTest::paren_expr_runner --signers 0xCAFE

//# publish
module 0xCAFE::SpecScriptTest {
    /// Just a simple function
    public fun adder(a: u64, b: u64): u64 {
        (a + b)
    }

    /// Expose a function for script
    public fun run_adder() {
        let s = adder(({7}), (3 + 4));
        let _ = (s);
    }

    /// A spec function showing grouping, returns true if even
    spec fun is_even_spec(n: u64): bool {
        (n % 2 == 0)
    }

    spec adder {
        ensures is_even_spec(result) || !is_even_spec(result);
        // The result is always either even or not even, using grouping!
    }
}

//# run 0xCAFE::SpecScriptTest::run_adder --signers 0xCAFE

//# run
script {
    use 0xCAFE::SpecParenthesesTest;

    fun main() {
        // Test grouping of calls/expressions
        let y = (1 + (3 * (4)));
        let z = SpecParenthesesTest::paren_expr_fun(({9}), 7);
        let a = SpecParenthesesTest::double_braces_parens((((z as u64) + (y as u64))));
        let _ = { a + (y as u64) };
    }
}

// Featurres:
// 905164d5858f2baedd842327c08ad337: Store address aliases for more readable code and easier Maint.
// c4a435a296221caa990a4d752dad2c55: Declare and write specification functions for Move code.
// 15f88aaf1be091ff2dd9fcdda4546618: Group expressions or call functions using parentheses and braces.
