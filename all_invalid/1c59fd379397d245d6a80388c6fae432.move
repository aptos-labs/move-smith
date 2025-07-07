//# publish
module 0xCAFE::ModuleA {
    /// A simple struct with a value
    struct S has store {
        val: u64,
    }

    /// Construct S with given value
    public fun create(val: u64): S {
        S { val }
    }

    /// Returns the value inside S
    public fun get_value(s: &S): u64 {
        s.val
    }

    /// Entry function that takes a value and returns a struct S
    entry fun entry_create(val: u64): S {
        create(val)
    }
}

//# publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA;

    /// Struct that contains multiple fields of type ModuleA::S
    struct M has store {
        s1: ModuleA::S,
        s2: ModuleA::S,
        s3: ModuleA::S,
    }

    /// Create M with fields initialized: s1 with val, s2 with val*2 and s3 with val*3
    public fun create_m(val: u64): M {
        let s1 = ModuleA::create(val);
        let s2 = ModuleA::create(val * 2);
        let s3 = ModuleA::create(val * 3);
        M { s1, s2, s3 }
    }

    /// Sum all s.val fields inside M
    public fun sum_all(m: &M): u64 {
        ModuleA::get_value(&m.s1) + ModuleA::get_value(&m.s2) + ModuleA::get_value(&m.s3)
    }

    /// Runner function that creates an M with val=10 and returns sum_all value
    public fun runner(): u64 {
        let m = create_m(10);
        sum_all(&m)
    }
}
//# run 0xCAFE::ModuleB::runner

//# publish
module 0xCAFE::Registry {
    /// DelayedWork stores an amount of work as u64
    struct DelayedWork has store {
        work: u64,
    }

    /// Registry stores delayed work functions associated with an address
    struct Registry has key {
        /// Map from address to DelayedWork
        data: table::Table<address, DelayedWork>,
    }

    /// Initialize the Registry, publish must be called once to create the Registry resource under signer
    public fun init_registry(account: &signer) {
        let reg = Registry { data: table::new() };
        move_to(account, reg);
    }

    /// Add delayed work for an address, create entry if missing
    public fun add_delayed_work(registry: &mut Registry, addr: address, amount: u64) {
        if (!table::contains(&registry.data, &addr)) {
            table::add(&mut registry.data, addr, DelayedWork { work: amount });
        } else {
            let dw = table::borrow_mut(&mut registry.data, &addr);
            dw.work = dw.work + amount;
        }
    }

    /// Evaluate the delayed work for the given address, returning the total and resetting work to zero
    public fun eval_delayed_work(registry: &mut Registry, addr: address): u64 {
        if (!table::contains(&registry.data, &addr)) {
            0
        } else {
            let dw = table::borrow_mut(&mut registry.data, &addr);
            let total = dw.work;
            dw.work = 0;
            total
        }
    }

    /// Return total delayed work without resetting
    public fun get_delayed_work(registry: &Registry, addr: address): u64 acquires Registry {
        if (!table::contains(&registry.data, &addr)) {
            0
        } else {
            let dw = table::borrow(&registry.data, &addr);
            dw.work
        }
    }

    /// Runner function that adds and evaluates delayed work for caller address
    /// Expects: none
    public entry fun runner(account: &signer): u64 {
        let addr = signer::address_of(account);
        // Load Registry resource for signer (must exist)
        let reg = borrow_global_mut<Registry>(addr);

        // Add 10 units of work twice
        add_delayed_work(reg, addr, 10);
        add_delayed_work(reg, addr, 10);

        // Check total work (should be 20)
        let sum = get_delayed_work(reg, addr);

        // Evaluate (should reset to zero)
        let total = eval_delayed_work(reg, addr);

        // Verify reset (should be 0)
        let reset_check = get_delayed_work(reg, addr);

        // Return sum + total + reset_check (20 + 20 + 0 = 40)
        sum + total + reset_check
    }
}

//# run 0xCAFE::Registry::runner --signers 0xCAFE

//# run 0xCAFE::ModuleA::entry_create --signers 0xCAFE --args 42u64

// Featurres:
// 9d566eb4836899102ffef9aba3b62e3f: Mark a function as an entry function, allowing it to be published as a transaction entry point using the 'entry' keyword.
// 5c3e1db827b2d38387d85a070816039f: Test that a struct can correctly contain multiple fields of the same type defined in another module, including when some fields are initialized using functions from different modules.
// 3033ead783c591afb5847471fcbe56b3: Test that the registry correctly stores, updates, and retrieves delayed work functions, ensuring that the accumulated work is computed accurately over multiple add and eval operations.
