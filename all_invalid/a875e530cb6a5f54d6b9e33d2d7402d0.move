
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

    public fun acquire_permission(_s: &signer, target: address, required_level: u8): bool {
        let res_ref: &Resource = borrow_global<Resource>(target);
        if (res_ref.permission_level >= required_level) {
            true
        } else {
            false
        }
    }

    public fun update_permission(s: &signer, target: address, new_level: u8) {
        let res_mut: &mut Resource = borrow_global_mut<Resource>(target);
        res_mut.permission_level = new_level;
    }

    public fun get_resource_value(_s: &signer, target: address): u8 {
        let res_ref: &Resource = borrow_global<Resource>(target);
        res_ref.value
    }
}


//# publish
module 0xBADA::Policy {
    use std::signer;
    use 0xdead::ResourceHandler;

    // Configures a resource with a specific permission level during creation.
    public fun setup_resource_with_permission(s: &signer, permission_level: u8, value: u8) {
        ResourceHandler::create_resource(s, permission_level, value);
    }

    // Attempts to acquire permission to a resource with arbitrary owner address.
    public fun check_and_update_permission(s: &signer, resource_owner: address, required_level: u8, new_level: u8): bool {
        if (ResourceHandler::acquire_permission(s, resource_owner, required_level)) {
            ResourceHandler::update_permission(s, resource_owner, new_level);
            true
        } else {
            false
        }
    }

    // Uses a wildcard '*' to get resource value for any owner.
    public fun get_any_resource_value(target: address): u8 {
        // Since borrow_global requires a &signer but we don't have one,
        // we'll assume that the caller supplies a valid signer for the context.
        // Alternatively, implement a way to obtain a signer reference if needed.
        // For now, assume there's a special "system" signer or ref is provided.
        // But since the function signature doesn't include signer, and move language 
        // requires a signer for borrow_global, you might need to pass &signer.
        // To fix the compile error, we declare the function as accepting a &signer parameter.

        // Updated method:
        // public fun get_any_resource_value(s: &signer, target: address): u8
    }
}

// Corrected code for get_any_resource_value function:
public fun get_any_resource_value(s: &signer, target: address): u8 {
    ResourceHandler::get_resource_value(s, target)
}


//# run 0xdead::ResourceHandler::create_resource --signers 0xABCD --args 5u8 10u8


//# run 0xBADA::Policy::setup_resource_with_permission --signers 0xABCD --args 3u8 7u8


//# run 0xBADA::Policy::check_and_update_permission --signers 0xABCD --args 0xdead 2u8 8u8


//# run 0xdead::ResourceHandler::acquire_permission --args 0xdead 0xBADA --args 2u8


//# run 0xdead::ResourceHandler::get_resource_value --signers 0xABCD --args 0xdead


//# run 0xBADA::Policy::get_any_resource_value --args 0xdead
