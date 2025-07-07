//# publish
module 0xA11::init_test {
    struct CapA has copy, store {
        owner: address
    }

    struct CapB has copy, store {
        owner: address
    }

    struct CapC has copy, store {
        owner: address
    }

    struct CapStore has key {
        cap_b: CapB,
        cap_c: CapC
    }

    fun destroy_cap_b(c: CapB) {
        let CapB{owner: _} = c;
        // resource is destroyed at the end of scope
    }
    
    // This function will initialize and move CapC into storage, destroy CapB, and return CapA and CapC
    fun init(s: &signer): (CapA, CapC) {
        let (cap_a, cap_b, cap_c) = generate_caps();
        move_to(s, CapStore { cap_b, cap_c });
        destroy_cap_b(cap_b);
        (cap_a, cap_c)
    }

    fun generate_caps(): (CapA, CapB, CapC) {
        // Generate dummy capabilities with owners
        (CapA { owner: @0x1 }, CapB { owner: @0x2 }, CapC { owner: @0x3 })
    }
}

//# run --signers 0xDEAD -- 0xA11::init_test::init

//# run
script {
    fun main() {
        // Infinite loop with early return; ensures code after loop is not executed
        while (false) {
            // This block won't execute
            assert!(true, 0);
        }
        // Early return should skip assertion below
        return;
        // This assertion should not execute
        assert!(false, 42);
    }
}

//# run --verbose --  // Ensure the script completes without executing the assertion after early return

//# publish
module 0x42::tuple_destruct {
    struct Pair<X, Y>(X, Y);

    fun baz(x: u64, y: u64): u64 {
        let Pair(y, x) = Pair(x, y);
        y - x
    }

    fun test_baz() {
        assert!(baz(5, 3) == -2, 42);
        assert!(baz(10, 10) == 0, 42);
        assert!(baz(20, 5) == -15, 42);
    }
}

//# run -- 0x42::tuple_destruct::test_baz