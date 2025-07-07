//# publish
module 0xCAFE::OperatorPrecedence {
    // Test the precedence and evaluation of various operators

    public fun test_comparisons(a: u8, b: u8): (bool, bool, bool, bool, bool, bool) {
        // ==, !=, <, >, <=, >=
        (
            a == b,
            a != b,
            a < b,
            a > b,
            a <= b,
            a >= b
        )
    }

    public fun test_boolean_ops(x: bool, y: bool): (bool, bool, bool) {
        // ||, &&
        (
            x || y,
            x && y,
            (x && y) || (!x && !y)
        )
    }

    public fun test_bitwise_ops(x: u8, y: u8): (u8, u8, u8) {
        // |, ^, &
        (
            x | y,
            x ^ y,
            x & y
        )
    }

    public fun test_shifts(x: u8, y: u8): (u8, u8) {
        // <<, >>
        (
            x << y,
            x >> y
        )
    }

    public fun test_arithmetic(a: u8, b: u8): (u8, u8, u8, u8, u8) {
        // +, -, *, /, %
        (
            a + b,
            a - b,
            a * b,
            a / b,
            a % b
        )
    }

    public fun test_combined_expr(a: u8, b: u8, c: u8): u8 {
        // Complex expression that tests precedence
        // ((a + b) * (c - 2)) >> 1 & (b ^ 3) | (a & 1)
        let expr = ((a + b) * (c - 2));
        let expr = (expr >> 1);
        let expr = expr & (b ^ 3);
        let expr = expr | (a & 1);
        expr
    }
}


//# publish
module 0xCAFE::UpdateExprs {
    use std::signer;

    struct Counter has store {
        val: u64,
    }

    public fun init_counter(account: &signer) {
        move_to<Counter>(account, Counter { val: 0 });
    }

    public fun increment(account: &signer, inc: u64) {
        let c_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(account));
        c_ref.val = c_ref.val + inc;
    }

    public fun decrement(account: &signer, dec: u64) {
        let c_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(account));
        c_ref.val = c_ref.val - dec;
    }

    public fun multiply(account: &signer, mul: u64) {
        let c_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(account));
        c_ref.val = c_ref.val * mul;
    }

    public fun divide(account: &signer, div: u64) {
        let c_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(account));
        c_ref.val = c_ref.val / div;
    }

    public fun modulo(account: &signer, modulo_val: u64) {
        let c_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(account));
        c_ref.val = c_ref.val % modulo_val;
    }

    public fun get(account: &signer): u64 {
        let c_ref: &Counter = borrow_global<Counter>(signer::address_of(account));
        c_ref.val
    }
}


//# publish
module 0xCAFE::ResourceAccessControl {
    use std::signer;

    struct SecretResource has key, store {
        data: u64,
    }

    public fun publish_resource(s: &signer, data: u64) {
        let resource = SecretResource { data };
        move_to<SecretResource>(s, resource);
    }

    // Public accessor function with address, module, and resource type fully qualified
    public fun access_resource_full(addr: address): u64 acquires SecretResource {
        let res_ref: &SecretResource = borrow_global<SecretResource>(addr);
        res_ref.data
    }

    // Public accessor with generic type arguments match resource
    public fun access_resource_generic<T: key + store>(addr: address): &T acquires T {
        borrow_global<T>(addr)
    }
}