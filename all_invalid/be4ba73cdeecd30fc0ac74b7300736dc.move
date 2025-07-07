//# publish
module 0xCAFE::AbilityChecker {
    use std::abilities;

    public fun ability_set_empty_check() {
        let abilities_empty = abilities::empty();
        let abilities_bitset = abilities::ABILITIES_BITSET(0u8);

        // Check if empty ability set is empty (expect true)
        let is_empty_empty = abilities::is_empty(&abilities_empty);
        let is_empty_bitset = abilities::is_empty(&abilities_bitset);

        // Dummy usage to prevent unused variable warning
        if (is_empty_empty) {
            let _ = 1u8;
        } else {
            let _ = 0u8;
        };

        if (is_empty_bitset) {
            let _ = 1u8;
        } else {
            let _ = 0u8;
        };
    }
}

//# run 0xCAFE::AbilityChecker::ability_set_empty_check

// Featurres:
// 509b20779ecabeff191eebe7cae1cfbd: Declare public functions and modules using the 'public' visibility modifier.
// 017b6b6a632470501fba26c324c0fae5: Create module keys with a specific address and module name when both are available.
// fa5d0cd90beec0418e1ecd92a71c0234: Check if an AbilitySet is empty to determine if no abilities are assigned.
