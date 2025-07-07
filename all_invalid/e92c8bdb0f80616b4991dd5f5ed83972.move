
//# publish
module 0xCAFE::AttributeTest {
    use std::vector;

    // 1. Struct with attributes of various kinds
    struct ReResource { 
        a: u8,
        b: u16,
    }

    struct StructWithAttributes {
        pub u_attr: u8,          // attribute of type u8
        pub s_attr: bool,        // attribute of type bool
        pub r_attr: ReResource,  // resource attribute
    }

    // 2. Function expecting to acquire a resource of type ReResource
    public fun acquire_resource(r: &ReResource) {
        // just access fields to ensure acquisition is valid
        let _ = r.a;
        let _ = r.b;
    }

    // 3. Enum with variants, only match within module
    enum AttrEnum {
        Variant1,
        Variant2(u8, u16),
        Variant3 { flag: bool },
    }

    // Function matching on AttrEnum variants only within module
    public fun match_enum(e: AttrEnum): u8 acquires ReResource {
        match e {
            AttrEnum::Variant1 => 0,
            AttrEnum::Variant2(x, y) => x + (y as u8),
            AttrEnum::Variant3 { flag } => {
                if (flag) { 1 } else { 2 }
            }
        }
    }

    // Runner function to test assigning attributes and matching
    public fun run_tests() {
        let resource_instance = ReResource { a: 10, b: 300 };
        acquire_resource(&resource_instance);

        let attr_enum_val = AttrEnum::Variant2(5, 10);
        let _res = match_enum(attr_enum_val);
        let struct_attr = StructWithAttributes {
            u_attr: 42,
            s_attr: true,
            r_attr: resource_instance,
        };
        // just to use struct_attr
        let _ = struct_attr.u_attr;
        let _ = struct_attr.s_attr;
        let _ = struct_attr.r_attr.a;
    }
}


//# run 0xCAFE::AttributeTest::run_tests

// Featurres:
// 5ec74372403f4f895ed472ad62123f67: Assign attributes with a specific kind in Move code.
// 798dc00b2432a853c699ef97cbf4b3f0: Specify resources to be acquired using the `acquires R` clause in function signatures
// 2db1da29c6dc859b43fbb2209a123301: Match on enum types only within the module that defines the enum.
