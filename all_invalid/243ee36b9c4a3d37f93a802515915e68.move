//# publish
module 0x1::ExprTest {
    // Simple function to double an integer
    public fun double(x: u64): u64 {
        x * 2
    }

    // Function that calls double with an expression as an argument
    public fun call_double_with_expr(): u64 {
        let input = 3 + 4;
        double(input) // input is an expression (3 + 4)
    } 

    // A function that iterates over a vector and applies a function to each element
    public fun map_and_sum(vec: vector<u8>): u64 {
        let i = 0;
        let total = 0u64;
        while (i < Vector::length(&vec)) {
            let v = *Vector::borrow(&vec, i);
            total = total + (v as u64) * 2;
            i = i + 1;
        };
        total
    }

    // A function using abort with an expression
    public fun may_fail(x: u64) {
        if (x > 10) {
            abort x + 42;
        }
    }

    // "Runner" function, combines above
    public fun runner() {
        let v = vector[5u8, 10u8, 3u8];
        let sum = Self::map_and_sum(v);
        // Intentionally abort if sum is > 30
        if (sum > 30) {
            abort sum;
        };
        let res = Self::call_double_with_expr();
        // Intentionally abort with an expression result
        Self::may_fail(res);
    }
}

address 0xCAFE {
    module Collection {
        use std::vector;

        // Custom function to increment an lvalue in a vector in-place
        public fun inc_elem(vec: &mut vector<u8>, i: u64) acquires  {
            let val = *vector::borrow(vec, i);
            *vector::borrow_mut(vec, i) = val + 1;
        }

        // Iterates over the collection and processes each one (calls inc_elem)
        public fun process_all(vec: &mut vector<u8>) {
            let i = 0;
            let len = vector::length(vec);
            while (i < len) {
                Self::inc_elem(vec, i);
                i = i + 1;
            };
        }

        // Runner function for the module
        public fun collection_runner() {
            let mut v = vector[1u8, 2u8, 3u8];
            Self::process_all(&mut v);
            // After process_all, v should be [2, 3, 4]
            // We'll just abort with the sum as exercise
            let sum = (*vector::borrow(&v, 0) as u64) + (*vector::borrow(&v, 1) as u64) + (*vector::borrow(&v, 2) as u64);
            if (sum > 9) {
                abort sum + 11;
            }
        }
    }
}

//# run 0x1::ExprTest::runner --signers 0x1

//# run 0xCAFE::Collection::collection_runner --signers 0xCAFE

//# run
script {
    use 0x1::ExprTest;
    fun main() {
        let val = ExprTest::call_double_with_expr();
        ExprTest::may_fail(val + 456);
    }
}