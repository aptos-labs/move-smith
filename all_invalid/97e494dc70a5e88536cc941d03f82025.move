// This transactional test exercises the Move compiler and VM by testing error handling, resource moves, aborts,
// variable bindings, destructuring, inline functions, higher-order functions, closures (simulated as inline functions),
// and module dependency management (using vector).

// We use address 0xCAFE as requested.

//# publish
module 0xCAFE::ErrorAndResource {
    use std::vector;

    #[error_code]
    const E_DIV_BY_ZERO: u64 = 1;
    #[error_code]
    const E_RESOURCE_NOT_EXISTS: u64 = 2;
    #[error_code]
    const E_ABORT_WITH_CODE: u64 = 3;

    struct MyResource has key, store {
        val: u64,
    }

    // Publish a resource at account if not exists
    public fun publish_resource(account: &signer, val: u64) {
        if (!exists<MyResource>(signer::address_of(account))) {
            move_to(account, MyResource { val });
        }
    }

    // Consume and return the value of MyResource; abort if resource not exists
    public fun consume_resource(addr: address): u64 {
        if (!exists<MyResource>(addr)) {
            abort E_RESOURCE_NOT_EXISTS;
        }
        let resource = move_from<MyResource>(addr);
        resource.val
    }

    // Divide two numbers, abort if divisor is zero
    public fun safe_div(numerator: u64, denominator: u64): u64 {
        if (denominator == 0) {
            abort E_DIV_BY_ZERO;
        }
        numerator / denominator
    }

    // Function that aborts with a specific error code forcibly
    public fun abort_example() {
        abort E_ABORT_WITH_CODE;
    }

    // Inline function example
    public inline fun inline_add(x: u64, y: u64): u64 {
        x + y
    }

    // Higher-order function: accepts a function with signature u64->u64 and applies it 3 times
    public fun apply_thrice(f: &fn(u64): u64, x: u64): u64 {
        let y = f(x);
        let z = f(y);
        f(z)
    }

    // "Closure" example: no true closures in Move, but simulate with inline function
    public inline fun add_five(x: u64): u64 {
        x + 5
    }

    // A runner function as required: does a sequence of tests regarding the above
    public fun runner() {
        // Test resource publish and consume
        let signer_addr = @0xCAFE;
        // In a real test, signer is needed; here we simulate by direct address resource management
        // The test environment should tolerate this resource existence check and move_from.

        // We'll just test safe_div and abort_example here, resource moves will be tested in script

        let _ = safe_div(10, 2);
        // Following line will abort if uncommented:
        // let _ = safe_div(1, 0);

        // Test inline function
        let sum = inline_add(3, 4);
        let thrice_applied = apply_thrice(&inline_add, 1); // 1+1=2; 2+1=3; 3+1=4
        let closure_like = apply_thrice(&add_five, 0); // 0+5=5; 5+5=10; 10+5=15

        // We do not return values or assert here (per instructions)

    }
}
//# run 0xCAFE::ErrorAndResource::runner

//# publish
module 0xCAFE::BindingAndDestructuring {

    // Simple tuple struct
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Inline function for swapping two values using destructuring
    public inline fun swap(a: &mut u64, b: &mut u64) {
        let tmp = *a;
        *a = *b;
        *b = tmp;
    }

    // Function that returns a tuple, to test destructuring
    public fun return_tuple(): (u64, bool) {
        (42, true)
    }

    // Function that takes a tuple as argument
    public fun takes_tuple(p: (u64, bool)) {
        let (val, flag) = p;
        // use val and flag in no-op way
        let _ = val;
        let _ = flag;
    }

    // Higher order function taking a function that takes an u64 and returns boolean
    public fun filter_num(f: &fn(u64): bool, input: u64): bool {
        f(input)
    }

    // A simple predicate inline function
    public inline fun is_even(x: u64): bool {
        (x % 2) == 0
    }

    // Runner function to test the above
    public fun runner() {
        let (a, b) = return_tuple();
        takes_tuple((a, b));
        let mut x = 10;
        let mut y = 20;
        swap(&mut x, &mut y);
        let ev = filter_num(&is_even, 20);
        let od = filter_num(&is_even, 21);

        // no assertions; just exercising code paths
    }
}
//# run 0xCAFE::BindingAndDestructuring::runner

//# publish
module 0xCAFE::VectorDependencyTest {
    use std::vector;

    // Returns the sum of the elements in the vector to test compiler's automatic dependency management on vector
    public fun sum(vec: vector<u64>): u64 {
        let mut total = 0;
        let len = vector::length(&vec);
        let mut i = 0;
        while (i < len) {
            total = total + *vector::borrow(&vec, i);
            i = i + 1;
        }
        total
    }

    // Runner: creates a vector and sums elements
    public fun runner() {
        // create vector
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);
        vector::push_back(&mut v, 30);
        let _ = sum(v);
    }
}
//# run 0xCAFE::VectorDependencyTest::runner

//# run
script {
    use 0xCAFE::ErrorAndResource;
    use 0xCAFE::BindingAndDestructuring;
    use 0xCAFE::VectorDependencyTest;
    use std::signer;

    fun main(account: signer) {
        // Test resource publish and consume with actual signer
        ErrorAndResource::publish_resource(&account, 123);
        let val = ErrorAndResource::consume_resource(signer::address_of(&account));
        let _ = val;

        // Test abort by catching is not possible here, so just call safe_div and runner functions expect no runtime error for valid input
        let div_res = ErrorAndResource::safe_div(100, 5);
        let _ = div_res;

        // Call inline, higher order functions combined
        let res = ErrorAndResource::apply_thrice(&ErrorAndResource::add_five, 7);
        let _ = res;

        BindingAndDestructuring::runner();
        VectorDependencyTest::runner();

        // Test swap via script local variables
        let mut a = 1u64;
        let mut b = 2u64;
        BindingAndDestructuring::swap(&mut a, &mut b);
    }
}

// Featurres:
// db95778a40105e12d9c4ae2d62300372: Test handling of arithmetic errors, resource moves, and aborts in Move functions, including error propagation and resource existence checks.
// a266a7f8865315499de9a81c96b2fb89: Test the correct handling of variable bindings, destructuring, inline functions, higher-order functions, and anonymous closures in Move.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
