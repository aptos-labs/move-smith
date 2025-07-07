//# publish
module 0x1::HigherOrderTest {
    /// A simple function that takes a u64 and returns it plus 1.
    public fun add_one(x: u64): u64 {
        x + 1
    }

    /// A function that takes a u64 and returns it times 2.
    public fun double(x: u64): u64 {
        x * 2
    }

    /// Creates a vector of functions from u64 to u64.
    /// These are closures simulated as function pointers.
    public fun create_functions(): vector<fn(u64): u64> {
        let mut vec = Vector::empty<fn(u64): u64>();
        Vector::push_back(&mut vec, add_one);
        Vector::push_back(&mut vec, double);
        vec
    }

    /// Given a vector of functions and an argument x, applies each function to x,
    /// sums the results and returns the sum.
    public fun eval(functions: vector<fn(u64): u64>, x: u64): u64 {
        let mut sum = 0;
        let len = Vector::length(&functions);
        let mut i = 0;
        while (i < len) {
            let f = *Vector::borrow(&functions, i);
            sum = sum + f(x);
            i = i + 1;
        }
        sum
    }

    /// Returns multiple values - here a tuple (Move doesn't have built-in tuples,
    /// but returns multiple via a struct or via multiple let bindings).
    /// We'll return a struct simulating multiple return values.
    struct MultiReturn has copy, drop, store {
        first: bool,
        second: u8
    }

    /// Return multiple values via struct
    public fun multiple_returns(): MultiReturn {
        MultiReturn { first: true, second: 42u8 }
    }

    /// An inline-style function that uses a functional style: given a function f,
    /// applies it to 10 and returns the result.
    public fun inline_apply(f: fn(u64): u64): u64 {
        f(10)
    }

    /// A runner to test multiple features in one place.
    /// Uses name references, value literals, variable bindings,
    /// applies higher-order functions and returns sum of eval + inline_apply.
    public fun runner(): u64 {
        // variable binding
        let funcs = create_functions();
        let x = 5u64;

        // value literals (boolean, number, byte vector literal)
        let _b = true;
        let _num = 123u64;
        let _bytes = b"MoveByteString";

        // call eval function
        let s = eval(funcs, x);

        // call inline_apply with a closure/function pointer "add_one"
        let i = inline_apply(add_one);

        // multiple return values
        let multi = multiple_returns();
        // binding unpacking (simulated via fields)
        let first_val = multi.first;
        let second_val = multi.second;

        // use name references and compute sum of results
        s + i + (if first_val { second_val as u64 } else { 0 })
    }
}

//# run 0x1::HigherOrderTest::runner


//# run
script {
    use 0x1::HigherOrderTest;

    fun main(account: &signer) {
        // Call runner function which tests evaluating sum of function results,
        // variable bindings, multi returns, inline functions and literals.
        let result = HigherOrderTest::runner();
        // no assertion required per instructions
        let _ = result; // ignore unused variable warning
    }
}