
//# publish
module 0xDEAD::SpecTest {
    use std::vector;

    // Define abilities for testing
    struct AbilitySet has store, key, copy, drop {
        abilities: vector<u8>
    }

    // Function to create a AbilitySet with specific abilities
    public fun new_ability_set(abilities: vector<u8>): AbilitySet {
        AbilitySet { abilities }
    }

    // Function to test ability parsing and properties
    public fun test_ability_properties() {
        let abilities_vector = vector::empty<u8>();
        vector::push_back(&mut abilities_vector, 1); // store
        vector::push_back(&mut abilities_vector, 2); // key
        vector::push_back(&mut abilities_vector, 4); // copy
        vector::push_back(&mut abilities_vector, 8); // drop
        let ability_set = new_ability_set(abilities_vector);
        // Use ability set info (no assertions needed)
        ability_set
    }

    // Function to define a package with a module and test the package info attributes
    public fun package_info_test() {
        // Prepare package info
        let package_name = b"TestPackage";
        let version_major: u8 = 1;
        let version_minor: u8 = 0;

        // Compose package info as a tuple
        let package_info = (
            package_name,
            version_major,
            version_minor,
            // Modules list: just including our current module
            vector::empty<&str>(),
        );
        // Mutate package info to add our module name
        let module_name = "SpecTest";
        let modules_vector = vector::empty<&str>();
        vector::push_back(&mut modules_vector, module_name);
        // Reassign package info with modules vector
        let package_info_final = (
            package_name,
            version_major,
            version_minor,
            modules_vector,
        );
        package_info_final
    }

    // Function to demonstrate abilities in a generic context
    public fun generic_ability_demo<T: copy + drop>() {
        // Use abilities to enforce trait bounds
        // No operation needed; if bounds are wrong, compilation fails
        let _dummy: T;
        // Return `()`
    }

    // Function that tests ability combination and meta info
    public fun abilities_and_metadata() {
        let abilities = vector::empty<u8>();
        vector::push_back(&mut abilities, 1);
        vector::push_back(&mut abilities, 2);
        vector::push_back(&mut abilities, 4);
        let ability_set = new_ability_set(abilities);
        // Compose package info
        let pkg_name = b"AbilityPackage";
        let ver_major: u8 = 2;
        let ver_minor: u8 = 5;
        let modules = vector::empty<&str>();
        vector::push_back(&mut modules, "SpecTest");
        let package_meta = (
            pkg_name,
            ver_major,
            ver_minor,
            modules,
        );
        // Call generic ability demo
        generic_ability_demo<u64>();
        ability_set; 
        package_meta
    }
}


//# run 0xDEAD::SpecTest::test_ability_properties


//# run 0xDEAD::SpecTest::package_info_test


//# run 0xDEAD::SpecTest::abilities_and_metadata


// Featurres:
// 26438a256710f81405ba5794ef4f0cbc: Write specification conditions for Move modules and functions and have them checked for correctness
// 1831330fadc45f430f99ce2e8c9b6445: List each ability in the provided AbilitySet separated by spaces.
// 42efa3d947de9596936229598f2f727b: Allow modules and scripts to have associated package information and named address mappings.
