//# publish
module 0xCAFE::OperatorPrecedence {
    use std::signer;

    struct GlobalRes has key, store {
        a: u64,
        b: u64,
        flag: bool,
        counter: u64,
    }

    public fun create_global_res(s: &signer, a: u64, b: u64, flag: bool) {
        let res = GlobalRes { a, b, flag, counter: 0 };
        move_to<GlobalRes>(signer::address_of(s), res);
    }

    public fun read_fields(s: &signer): (u64, u64, bool, u64) acquires GlobalRes {
        let addr = signer::address_of(s);
        let res: &GlobalRes = borrow_global<GlobalRes>(addr);
        (res.a, res.b, res.flag, res.counter)
    }

    public fun mutate_fields(s: &signer): () acquires GlobalRes {
        let addr = signer::address_of(s);
        let res_mut: &mut GlobalRes = borrow_global_mut<GlobalRes>(addr);
        // mutate counter with arithmetic expression and bitwise ops
        res_mut.counter = (res_mut.a + (res_mut.b * 2) - (5 / 1) & 0xFF) | 3;
    }

    public fun test_assertions(s: &signer): bool acquires GlobalRes {
        let addr = signer::address_of(s);
        let res: &GlobalRes = borrow_global<GlobalRes>(addr);

        // Logical and comparison operators mixed with parentheses for precedence
        let cond1 = ((res.a > 10) && (!(res.flag || (res.b == 0))));
        let cond2 = ((res.counter & 0xF) == 3);
        let cond3 = (((res.a + res.b) / 2) >= 5 || (res.counter < 100));

        // assert all true; errors 101, 102, 103 respectively
        assert!(cond1, 101);
        assert!(cond2, 102);
        assert!(cond3, 103);
        true
    }

    public fun runner(s: signer) {
        create_global_res(&s, 20, 0, false);
        let _ = read_fields(&s);
        mutate_fields(&s);
        let ok = test_assertions(&s);
        let _ = ok;
    }
}

//# run 0xCAFE::OperatorPrecedence::runner --signers 0xCAFE

//# run 0xCAFE::OperatorPrecedence::read_fields --signers 0xCAFE

//# run 0xCAFE::OperatorPrecedence::mutate_fields --signers 0xCAFE

//# run 0xCAFE::OperatorPrecedence::test_assertions --signers 0xCAFE