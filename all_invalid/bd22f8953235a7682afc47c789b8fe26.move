//# publish
module 0x1::KeyDropTest {
    use std::signer;
    use std::vector;

    struct MyResource has key, drop { val: u64 }

    public fun create_resource(account: &signer) {
        move_to(account, MyResource { val: 42 });
    }

    public fun borrow_resource(account: &signer): &MyResource {
        &borrow_global<MyResource>(signer::address_of(account))
    }

    // This function attempts to move out the resource twice to trigger resource existence checks
    public fun double_move_out(account: &signer) {
        let addr = signer::address_of(account);
        // First move_out must succeed
        let _res = move_from<MyResource>(addr);
        // Second move_out shall fail (borrow checker resource existence failure)
        let _res2 = move_from<MyResource>(addr);
    }

    // Runner function to test above
    public fun runner(account: &signer) {
        create_resource(account);
        // borrow once - should succeed
        let _r = borrow_resource(account);
        // run double_move_out to cause failure due to moving resource twice
        double_move_out(account);
    }
}
//# run 0x1::KeyDropTest::runner --signers 0x1

//# publish
module 0x1::ShadowingTest {

    public fun outer(): u64 {
        let mut _x = 1;

        // inner function foo shadows _x through a lambda parameter and assigns 2 to it
        fun foo(f: &mut u64) {
            *f = 2;
        };

        foo(&mut _x);

        _x
    }
}
//# run 0x1::ShadowingTest::outer

//# publish
module 0x1::ParserErrorTest {
    // This module is valid but we will run a script with a deliberate syntax error below
}

//# run
script {
    fun main() {
        // Intentionally malformed syntax to generate unexpected token error:
        let a = 10
        let b = 20;;  // double semicolon and missing semicolon after previous line will cause parse error
    }
}