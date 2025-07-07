//# publish
module 0x1::DependencyModule {
    #[skip(lint1, lint2)]
    struct R has key {
        value: u64,
    }

    /// Create a new R resource with the given value
    public fun create_r(value: u64): R {
        R { value }
    }
}

//# publish
module 0x1::MainModule {
    use 0x1::DependencyModule;

    // Flattened attributes: #[skip(lint1, lint2, lint3)]
    #[skip(lint1)]
    #[skip(lint2, lint3)]
    struct Container has key {
        r: DependencyModule::R,
    }

    spec module {
        assume exists<DependencyModule::R>(@0x1);
    }

    /// Runner function that demonstrates modifying R based on v
    public entry fun do_(account: &signer, v: u64) {
        let r = DependencyModule::create_r(v);

        if (v > 10) {
            // Modify r in some way
            let new_value = r.value * 2;
            // Move struct to Container wrapper
            let container = Container { r: DependencyModule::R { value: new_value } };
            move_to(account, container);
        } else {
            // Just move r as is
            move_to(account, Container { r });
        }
    }

    /// Runner function with no args for simple run
    public entry fun runner(account: &signer) {
        Self::do_(account, 42);
    }
}
/// Run main runnner with signer
//# run 0x1::MainModule::runner --signers 0x1

//# run 0x1::MainModule::do_ --signers 0x1 --args 8u64

//# run 0x1::DependencyModule::create_r --args 100u64

//# run
script {
    use 0x1::MainModule;
    use 0x1::DependencyModule;

    fun main(account: &signer) {
        // Create R with value 5 and move to Container
        MainModule::do_(account, 5);

        // Create R with value > 10 should trigger value modification
        MainModule::do_(account, 20);
    }
}