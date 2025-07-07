
//# publish
module 0xdead::ResourceHandler {
    use std::signer;

    struct Resource has key {
        owner: address,
        permission_level: u8,
        value: u8,
    }

    public fun create_resource(s: signer, permission_level: u8, value: u8) {
        let owner_address = signer::address_of(&s);
        let res = Resource {owner: owner_address, permission_level, value};
        move_to<Resource>(&s, res);
    }

    public fun acquire_permission(s: signer, target: address, required_level: u8): bool {
        let res_ref: &Resource = borrow_global<Resource>(target);
        if (res_ref.permission_level >= required_level) {
            true
        } else {
            false
        }
    }

    public fun update_permission(s: signer, target: address, new_level: u8) {
        let res_mut: &mut Resource = borrow_global_mut<Resource>(target);
        res_mut.permission_level = new_level;
    }

    public fun get_resource_value(s: signer, target: address): u8 {
        let res_ref: &Resource = borrow_global<Resource>(target);
        res_ref.value
    }
}

//# publish
module 0xBADA::Policy {
    use std::signer;
    use 0xdead::ResourceHandler;

    // Configures a resource with a specific permission level during creation.
    public fun setup_resource_with_permission(s: signer, permission_level: u8, value: u8) {
        ResourceHandler::create_resource(s, permission_level, value);
    }

    // Attempts to acquire permission to a resource with arbitrary owner address.
    public fun check_and_update_permission(s: signer, resource_owner: address, required_level: u8, new_level: u8@): bool {
        if (ResourceHandler::acquire_permission(&s, resource_owner, required_level)) {
            ResourceHandler::update_permission(&s, resource_owner, new_level)
        } else {
            false
        }
    }

    // Uses a wildcard '*' to get resource value for any owner.
    public fun get_any_resource_value(target: address): u8 {
        ResourceHandler::get_resource_value(&signer::borrow_global<signer>(target))
    }
}


//# run 0xdead::ResourceHandler::create_resource --signers 0xABCD --args 5u8 10u8


//# run 0xBADA::Policy::setup_resource_with_permission --signers 0xABCD --args 3u8 7u8


//# run 0xBADA::Policy::check_and_update_permission --signers 0xABCD --args 0xdead 2u8 8u8


//# run 0xdead::ResourceHandler::acquire_permission --args 0xdead 0xBADA --args 2u8


//# run 0xdead::ResourceHandler::get_resource_value --signers 0xABCD --args 0xdead


//# run 0xBADA::Policy::get_any_resource_value --args 0xdead


// Featurres:
// b780cd281bc15892e47b5a16d51ecde3: Configure functions to acquire resources or permissions during execution.
// ceee5fe0e6121c6a5a0828738bcf4535: Use a wildcard `*` in specifications to represent any value.
// 36e48cd89925e2df15f9975bdf234867: Use 'use' statements within modules without affecting implicit aliasing.
