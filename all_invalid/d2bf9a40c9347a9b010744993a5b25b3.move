
//# run
script {
    // This script tests the function parameters, return types, and registry management
    // It exercises creation, update, retrieval, and evaluation of stored functions
    
    // Generate a dummy signer (assuming dai::generate_signer exists; if not, replace accordingly)
    let dummy_signer: signer = dai::generate_signer("0xDEAD");
    
    // Store a new delayed work function
    0xCAFE::RegistryModule::register_work(&dummy_signer, 5u64, 10u64);
    
    // Add to existing work
    0xCAFE::RegistryModule::add_work(&dummy_signer, 15u64);
    // Add more work
    0xCAFE::RegistryModule::add_work(&dummy_signer, 20u64);
    
    // Evaluate stored work, should be 5 + 15 + 20 = 40
    let total: u64 = 0xCAFE::RegistryModule::evaluate_work(&dummy_signer);
    
    // For demonstration: no assertions as per instructions
}
#line 0xDEAD::RegistryModule


//# publish
module 0xCAFE::RegistryModule {
    use std::signer;
    use std::vector; // Keep if needed elsewhere; can remove if unused

    struct Registry has key {
        work_value: u64,
        total: u64,
    }

    /// Registers a new work with initial value, overwriting existing
    public fun register_work(s: &signer, initial: u64, total: u64) {
        let addr = signer::address_of(s);
        if (exists<Registry>(addr)) {
            let reg_ref: &mut Registry = borrow_global_mut<Registry>(addr);
            reg_ref.work_value = initial;
            reg_ref.total = total;
        } else {
            let reg = Registry { work_value: initial, total: total };
            move_to<Registry>(s, reg);
        }
    }

    /// Adds specified amount to the work value
    public fun add_work(s: &signer, delta: u64) {
        let addr = signer::address_of(s);
        let reg_ref: &mut Registry = borrow_global_mut<Registry>(addr);
        let new_value = reg_ref.work_value + delta;
        reg_ref.work_value = new_value;
        reg_ref.total = reg_ref.total + delta;
    }

    /// Evaluates total accumulated work
    public fun evaluate_work(s: &signer): u64 {
        let addr = signer::address_of(s);
        let reg_ref: &Registry = borrow_global<Registry>(addr);
        reg_ref.total
    }
}
