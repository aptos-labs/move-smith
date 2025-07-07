//# publish
module 0xDEADBEEF::test_module {

    // Struct to test mutations
    struct Counter has key {
        count: u64,
    }

    // Initialize Counter resource
    public fun initialize(account: &signer) {
        move_to(account, Counter { count: 0 })
    }

    // Mutable function to increment Counter and return current count
    public fun increment(counter: &mut Counter): u64 {
        counter.count = counter.count + 1;
        counter.count
    }

    // Function that tests unsigned 16-bit arithmetic
    public fun test_u16_arithmetic() {
        let max_value = 65535u16;

        // Addition - no overflow
        let a = 10000u16;
        let b = 20000u16;
        let sum = a + b;
        assert(sum == 30000u16, 0);

        // Addition overflow should fail -- simulate with try
        // Move on since Move will panic on overflow
        // We can test with `checked` functions if available
        // But in Move, normal arithmetic overflows in debug mode trigger errors
        // so below code is to illustrate, actual overflow will cause compile or runtime error
        // Uncomment to test overflow failure
        // let _overflow_add = 60000u16 + 60000u16; // should panic

        // Subtraction - valid
        let c = 5000u16;
        let d = 3000u16;
        let sub = c - d;
        assert(sub == 2000u16, 1);

        // Subtraction overflow (underflow) should panic
        // let _sub_underflow = 3000u16 - 5000u16; // should panic

        // Multiplication - within bounds
        let e = 300u16;
        let f = 200u16;
        let mul = e * f; // 300*200=60000
        assert(mul == 60000u16, 2);

        // Multiplication overflow (uncomment to test)
        // let _mul_overflow = 300u16 * 300u16; // should panic

        // Division - valid
        let g = 100u16;
        let h = 20u16;
        let div = g / h;
        assert(div == 5u16, 3);

        // Division by zero should panic in runtime
        // let _div_zero = g / 0u16; // should panic

        // Modulus - valid
        let i = 55u16;
        let j = 6u16;
        let m = i % j;
        assert(m == 1u16, 4);

        // Modulus by zero should panic
        // let _mod_zero = i % 0u16; // should panic
    }

    // Struct and function to test repeated mutations
    resource struct MutationStruct {
        value: u64,
    }

    public fun initialize_mutation_struct(account: &signer): () {
        move_to(account, MutationStruct { value: 0 })
    }

    // Function that mutably modifies the struct's field, returns iteration count
    public fun mutate_and_return(struct: &mut MutationStruct, iter: u64): u64 {
        struct.value = struct.value + 1;
        iter
    }

    // Runner function that performs multiple iterations
    public fun run_mutations(account: &signer, times: u64): vector<u64> {
        let mut results = vector::empty<u64>();
        let mut struct_ref = borrow_global_mut<MutationStruct>(signer_address_of(account));
        let mut i = 0;
        while (i < times) {
            let res = mutate_and_return(&mut struct_ref, i);
            vector::push_back(&mut results, res);
            i = i + 1;
        }
        results
    }

    // Valid function with script to invoke above
    public fun script_function() {
        // just a placeholder
    }
}

//# run 0xDEADBEEF::test_module::initialize  --signers 0xA550C0DE
//# run 0xDEADBEEF::test_module::test_u16_arithmetic
//# run 0xDEADBEEF::test_module::initialize_mutation_struct --signers 0xA550C0DE
//# run 0xDEADBEEF::test_module::run_mutations --signers 0xA550C0DE --args 10