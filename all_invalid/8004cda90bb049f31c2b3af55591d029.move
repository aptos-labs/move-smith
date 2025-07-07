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

//# run 0xCAFE::OperatorPrecedence::test_comparisons --args 5u8 10u8

//# run 0xCAFE::OperatorPrecedence::test_boolean_ops --args true false

//# run 0xCAFE::OperatorPrecedence::test_bitwise_ops --args 0x0Fu8 0xF0u8

//# run 0xCAFE::OperatorPrecedence::test_shifts --args 0x10u8 2u8

//# run 0xCAFE::OperatorPrecedence::test_arithmetic --args 15u8 4u8

//# run 0xCAFE::OperatorPrecedence::test_combined_expr --args 5u8 10u8 7u8


//# publish
module 0xCAFE::UpdateExprs {
    // Test update expressions with left-hand side and right-hand side expressions

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

//# run 0xCAFE::UpdateExprs::init_counter --signers 0xBEEF

//# run 0xCAFE::UpdateExprs::increment --signers 0xBEEF --args 10u64

//# run 0xCAFE::UpdateExprs::multiply --signers 0xBEEF --args 5u64

//# run 0xCAFE::UpdateExprs::decrement --signers 0xBEEF --args 7u64

//# run 0xCAFE::UpdateExprs::divide --signers 0xBEEF --args 3u64

//# run 0xCAFE::UpdateExprs::modulo --signers 0xBEEF --args 4u64

//# run 0xCAFE::UpdateExprs::get --signers 0xBEEF


//# publish
module 0xCAFE::ResourceAccessControl {
    use std::signer;

    struct SecretResource has key, store {
        data: u64,
    }

    public fun publish_resource(s: signer, data: u64) {
        let resource = SecretResource { data };
        move_to<SecretResource>(&s, resource);
    }

    // Public accessor function with address, module, and resource type fully qualified
    public fun access_resource_full(addr: address): u64 acquires SecretResource {
        let res_ref: &SecretResource = borrow_global<SecretResource>(addr);
        res_ref.data
    }

    // Public accessor with generic type arguments match resource
    public fun access_resource_generic<T: store>(addr: address): &T acquires T {
        borrow_global<T>(addr)
    }
}
//# run 0xCAFE::ResourceAccessControl::publish_resource --signers 0xFF01 --args 42u64

//# run 0xCAFE::ResourceAccessControl::access_resource_full --args 0xFF01

//# run 0xCAFE::ResourceAccessControl::access_resource_generic --args 0xFF01


// Featurres:
// 115fee4aaa6657a698e8acb005e52c16: Identify the precedence level of operators like '==', '!=', '<', '>', '<=', '>=', '||', '&&', '|', '^', '&', '<<', '>>', '+', '-', '*', '/', and '%' in Move code.
// a5335100194ac81e7ddd952c2156dba7: Update expressions with left-hand side and right-hand side expressions.
// 7194eb47892e13690c0ddfa779aa8f6c: Use access specifiers with detailed module address, name, resource name, and type arguments to control resource access in Move modules.
