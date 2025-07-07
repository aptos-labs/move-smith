// # publish
module 0xCAFE::GenericAbilities {
    use std::error;
    use std::signer;

    /// A resource struct with a copy ability
    struct CopyResource has copy, drop, store {
        value: u64,
    }

    /// A resource struct with key ability (but not copy)
    struct KeyResource has key, drop, store {
        id: u64,
    }

    /// Generic function with ability constraint: T must have copy + store
    public fun generic_copy_store<T: copy + store>(val: T): T {
        val
    }

    /// Generic function with ability constraint: T must have key + drop + store
    public fun generic_key_drop_store<T: key + drop + store>(s: &signer, id: u64): T acquires T {
        // Just abort, no actual logic, for test compilation & abilities
        abort 42;
    }

    /// A runner function that exercises generic_copy_store with CopyResource
    public fun runner() {
        let r = CopyResource { value: 123 };
        let _ = generic_copy_store<CopyResource>(r);
    }
}

// # run 0xCAFE::GenericAbilities::runner --signers 0xCAFE

// # publish
module 0xCAFE::SequenceTest {
    /// A global mutable resource to track side effects
    struct Counter has key, store {
        val: u64,
    }

    public fun init(owner: &signer) {
        move_to(owner, Counter { val: 0 });
    }

    /// Increments the counter by 1 and returns the old value
    public fun inc_and_get_old(counter: &mut Counter): u64 {
        let old = counter.val;
        counter.val = old + 1;
        old
    }

    /// Function testing binary op with side-effect expressions in operands
    /// Note: this will test sequence expressions in operands like (inc_and_get_old(&mut) + inc_and_get_old(&mut))
    /// in Move language versions which allow this and which evaluate left operand first.
    public fun test_sequence_op(counter: &mut Counter): u64 {
        // Let l = inc_and_get_old, then r = inc_and_get_old, add them
        inc_and_get_old(counter) + inc_and_get_old(counter)
    }

    /// Runner to initialize and call test_sequence_op
    public fun runner(owner: &signer): u64 {
        init(owner);
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(owner));
        test_sequence_op(counter_ref)
    }
}

// # run 0xCAFE::SequenceTest::runner --signers 0xCAFE

// # publish
module 0xCAFE::PurityCheckerTest {
    use std::debug;
    use std::vector;

    /// Pure function - allowed in spec context, no side effects
    public fun pure_add(a: u64, b: u64): u64 {
        a + b
    }

    /// Impure function - writes to debug (side effect)
    public fun impure_log(msg: &vector<u8>) {
        debug::print(msg);
    }

    /// Spec function checking purity
    spec fun is_pure_func(addr: address, module: vector<u8>, name: vector<u8>): bool
        acquires {}

    /// Dummy verification spec, stub for FunctionPurenessChecker effect
    spec {
        // Theoretical purity check calls happen here
        // (This part is to simulate the presence of purity checking in specs)
    }

    /// Runner function calls pure function and impure function
    public fun runner() {
        let a = 10;
        let b = 20;
        let _ = pure_add(a, b);
        let msg = b"impure call";
        // calling impure_log inside normal function (outside spec) is allowed
        impure_log(&vector::empty<u8>());
    }
}

// # run 0xCAFE::PurityCheckerTest::runner --signers 0xCAFE

// Featurres:
// e5d5a8872369648d737b218c87dbd0f6: Define generic functions with type parameters that have specific ability constraints.
// 9999b96aafc20d2893411f661fd93de2: Include non-trivial sequence expressions (with side effects) as operands in binary operations, but be aware that it is not allowed under some language versions.
// 96b8be613325ac53132116bcedb223cd: Use the FunctionPurenessChecker to verify function purity within specifications.
