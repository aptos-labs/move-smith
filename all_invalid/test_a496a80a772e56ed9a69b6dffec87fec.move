//# publish
module 0x42::foo {
    struct Foo<T: store> has key, drop {
        f: ||vector<T>,
    }

    public fun make_foo<T: store>(account: &signer) {
        let f = || std::vector::empty<T>();
        move_to(account, Foo { f });
    }
}

//# publish
module 0x42::test {
    // Test that calling the anonymous function stored in `f` correctly invokes `0x42::foo::make_foo` 
    // and initializes the `Foo` resource for the account.
    fun run<T: store>(account: &signer) {
        let create_foo_fn = |a| 0x42::foo::make_foo<T>(a);
        create_foo_fn(account);
    }
}

//# run 0xCAFE::test::run --signers 0xCAFE --args 0u64

//# run
script {
    fun main() {
        // Verify that after moving `x` into `y`, updating `x` does not affect `y`.
        let x;
        let y;
        if (true) {
            x = 10;
            y = move x;
            x = 20; // update x after moving
            // y should still hold 10
            assert!(copy y == 10, 42);
            // x should now be 20
            assert!(copy x == 20, 43);
        } else {
            x = 0;
        };
        // Confirm that `x` retains its updated value later
        assert!(copy x == 20, 44);
    }
}