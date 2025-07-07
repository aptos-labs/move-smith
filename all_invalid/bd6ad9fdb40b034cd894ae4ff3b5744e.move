//# publish
module 0xCAFE::LoopAndSpec {
    use std::vector;

    // A struct with variant and ability declarations, ability declared after the variant list
    struct VariantAfter has copy, drop {
        variant A;
        variant B;
    }

    // A struct with ability declared before the variant list
    struct AbilityBefore has key {
        variant X;
        variant Y;
    }

    // A resource struct to demonstrate state updates
    struct Counter has key {
        value: u64,
    }

    // Public function demonstrating a while loop incrementing counter
    public fun while_loop(counter: &mut Counter) {
        let mut i = 0u64;
        while i < 5 {
            counter.value = counter.value + 1;
            i = i + 1;
        }
    }

    // Public function demonstrating a loop with break
    public fun loop_with_break(counter: &mut Counter) {
        let mut i = 0u64;
        loop {
            counter.value = counter.value + 2;
            i = i + 1;
            if (i == 3) {
                break;
            }
        }
    }

    // A runner function to create a counter, run both loops modifying it, and leave it stored
    public fun runner(account: &signer) {
        let counter = Counter { value: 0 };
        move_to(account, counter);
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        while_loop(counter_ref);
        loop_with_break(counter_ref);
    }

    // Spec block testing update expressions on Counter
    spec module {
        fun runner_spec(addr: address) {
            let c = borrow_global<Counter>(addr);
            // Update: increase value by 10
            update c.value = c.value + 10;
        }
    }
}
//# run 0xCAFE::LoopAndSpec::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::LoopAndSpec;

    fun main(account: signer) {
        LoopAndSpec::runner(&account);
    }
}

// Featurres:
// e646d5fb8be97e12c12b06b3ae8d7555: Write `while` and `loop` loop constructs.
// 501fc4a8a44915c292953952c4d54c5b: Use update expressions to specify state changes within spec blocks.
// 2731021478adb70b395236d2630f22ed: Declare abilities before or after variant lists with optional postfix ability declarations.
