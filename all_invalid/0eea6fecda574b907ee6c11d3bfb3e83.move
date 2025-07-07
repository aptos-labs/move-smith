
//# publish
module 0xDEAD::TestFeature1 {
    use std::signer;
    use std::debug;

    struct ResourceA has store, key {
        value: u64,
    }

    public fun init_resource(s: signer): ResourceA {
        let resource = ResourceA { value: 0 };
        move_to<ResourceA>(&s, resource)
    }

    // Function to test updating resource with assignment syntax
    public fun update_value(s: signer, new_value: u64) acquires ResourceA {
        let resource_ref: &mut ResourceA = borrow_global_mut<ResourceA>(signer::address_of(&s));
        resource_ref.value = new_value;
    }

    // Function with condition property in brackets, testing spec property assignment
    public fun check_condition(resource_addr: address): bool {
        // condition property - resource value > 10
        exists<ResourceA>(resource_addr) && (borrow_global<ResourceA>(resource_addr).value > 10)
    }
}


//# run 0xDEAD::TestFeature1::init_resource --signers 0xBADD

//# run 0xDEAD::TestFeature1::update_value --signers 0xBADD --args 42u64



//# publish
module 0xBADD::SpecVariableUpdate {
    use std::signer;

    // Spec variable declaration
    struct SpecResource has store, key {
        flag: bool,
        count: u64,
    }

    // Initialize resource with default values
    public fun init_resource(s: signer): SpecResource {
        let res = SpecResource { flag: false, count: 0 };
        move_to<SpecResource>(&s, res)
    }

    // Function updating spec variables with assignment syntax
    public fun update_spec_variables(s: signer, new_flag: bool, new_count: u64) acquires SpecResource {
        let res_ref: &mut SpecResource = borrow_global_mut<SpecResource>(signer::address_of(&s));
        res_ref.flag = new_flag;
        res_ref.count = new_count;
    }

    // Function asserting spec property (property enclosed in brackets)
    public fun check_spec_property(addr: address): bool {
        exists<SpecResource>(addr) && (borrow_global<SpecResource>(addr).flag == true && borrow_global<SpecResource>(addr).count >= 1)
    }
}


//# run 0xBADD::SpecVariableUpdate::init_resource --signers 0xCACA

//# run 0xBADD::SpecVariableUpdate::update_spec_variables --signers 0xCACA --args true 100u64



//# publish
module 0xFEED::ConditionPropertyInBrackets {
    use std::signer;

    // Resource to test condition property with brackets
    struct Status { active: bool }

    // Initialize resource
    public fun init_status(s: signer): Status {
        let stat = Status { active: false };
        move_to<Status>(&s, stat)
    }

    // Function testing property condition in brackets
    public fun is_active(addr: address): bool {
        exists<Status>(addr) && (borrow_global<Status>(addr).active)
    }

    // Function to set active
    public fun set_active(s: signer) acquires Status {
        let status_ref: &mut Status = borrow_global_mut<Status>(signer::address_of(&s));
        status_ref.active = true;
    }
}


//# run 0xFEED::ConditionPropertyInBrackets::init_status --signers 0xDADA

//# run 0xFEED::ConditionPropertyInBrackets::set_active --signers 0xDADA

//# run 0xFEED::ConditionPropertyInBrackets::is_active --signers 0xDADA



//# publish
module 0xC0FFEE::ResourceAccess {
    use std::signer;

    struct AccessTracker has store, key {
        accesses: u64,
    }

    public fun init_tracker(s: signer): AccessTracker {
        let tracker = AccessTracker { accesses: 0 };
        move_to<AccessTracker>(&s, tracker)
    }

    // Acquires clause to specify resource access
    public fun record_access(s: signer) acquires AccessTracker {
        let tracker_ref: &mut AccessTracker = borrow_global_mut<AccessTracker>(signer::address_of(&s));
        tracker_ref.accesses = tracker_ref.accesses + 1;
    }

    // Checking current access count
    public fun get_access_count(addr: address): u64 acquires AccessTracker {
        borrow_global<AccessTracker>(addr).accesses
    }
}


//# run 0xC0FFEE::ResourceAccess::init_tracker --signers 0xABCD

//# run 0xC0FFEE::ResourceAccess::record_access --signers 0xABCD

//# run 0xC0FFEE::ResourceAccess::get_access_count --signers 0xABCD



// Featurres:
// 9c339a4f76a64549803ab3b233351947: Update specification variables using assignment syntax in spec blocks.
// 0f26324d5bfccb30b1fbc5010a2360ab: Declare condition properties enclosed in brackets in your code.
// a09c47183d5958017f3dc77f613e4879: Annotate functions with acquires clauses specifying the resources they access
