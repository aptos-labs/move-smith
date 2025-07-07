
//# publish
module 0xCAFE::AttributeSpecModule {
    use std::string;

    // Attribute structure with a parameterized attribute list
    struct Attribute has copy, drop, store {
        name: string::String,
        value: u64,
        params: vector<string::String>,
    }

    // Function to create an attribute with parameters
    public fun create_attribute(name: string::String, value: u64, params: vector<string::String>): Attribute {
        Attribute { name, value, params }
    }
}


//# publish
module 0xCAFE::TargetModule_withAttributes {
    use std::vector;
    use 0xCAFE::AttributeSpecModule;

    // Attach a list of attributes as a resource (simulating attribute annotations)
    struct AnnotatedResource has store, key {
        id: u64,
        description: string::String,
        attributes: vector<AttributeSpecModule::Attribute>,
    }

    // Create a resource with no attributes
    public fun create_resource(id: u64, desc: string::String): AnnotatedResource {
        AnnotatedResource {
            id,
            description: desc,
            attributes: vector::empty(),
        }
    }

    // Add an attribute to existing resource
    public fun add_attribute(resource_ref: &mut AnnotatedResource, attr: AttributeSpecModule::Attribute) {
        vector::push_back(&mut resource_ref.attributes, attr);
    }

    // Retrieve resource attributes
    public fun get_attributes(resource_ref: &AnnotatedResource): vector<AttributeSpecModule::Attribute> {
        // Return a copy
        vector::duplicate(&resource_ref.attributes)
    }

    // Function that reads attribute list and returns the attribute names
    public fun get_attribute_names(resource_ref: &AnnotatedResource): vector<string::String> {
        let names = vector::empty<string::String>();
        let attrs = &resource_ref.attributes;
        let len = vector::length(attrs);
        let i = 0;
        while (i < len) {
            let attr = vector::borrow(attrs, i);
            vector::push_back(&mut names, string::clone(&attr.name));
            i = i + 1;
        }
        names
    }
}


//# run 0xCAFE::AttributeSpecModule::create_attribute --args "attribute1" 42u64 [] 


//# run 0xCAFE::TargetModule_withAttributes::create_resource --args 100u64 "ResourceDescription"

# after creating the resource, retrieve it (assume resource is stored in a known address or passed as argument, but for test purposes, simulate in script)

// An internal script to test attribute insertion and retrieval

//# run 0xCAFE::TargetModule_withAttributes::add_attribute --args 100u64 "ResourceDescription" --signers 0xBEEF

//# run 0xCAFE::TargetModule_withAttributes::get_attribute_names --signers 0xBEEF


// Featurres:
// cdc6a5450223e140b5b86ef88e7b4699: Write and use non-native (Move) functions in target modules.
// a4e33a282cae3cdb894d91b180870d57: Add attributes to modules via spec modules and have those attributes appear on the merged module.
// e38ca692d45ce8bf91531889442c4e8b: Define parameterized attributes with inline argument lists.
