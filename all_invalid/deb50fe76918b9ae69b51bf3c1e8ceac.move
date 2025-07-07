//# publish
module 0xCAFE::AbilityChecker {
    use std::ability;

    public fun ability_set_empty_check() {
        let abilities_empty = ability::empty();
        let abilities_bitset = ability::ABILITIES_BITSET(0u8);

        // Check if empty ability set is empty (expect true)
        let is_empty_empty = ability::is_empty(&abilities_empty);
        let is_empty_bitset = ability::is_empty(&abilities_bitset);

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