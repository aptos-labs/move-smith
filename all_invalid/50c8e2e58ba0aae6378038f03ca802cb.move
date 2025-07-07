//# publish
module 0xCAFE::ModuleMembers {
    // public constant
    const CONST_VALUE: u64 = 42;

    // public struct with copy, drop, store, key abilities for testing
    struct Data has copy, drop, store, key {
        x: u8,
        y: u64,
    }

    // public struct without copy or drop (linear)
    struct ResourceType has store, key {
        val: u64,
    }

    // public function returning multiple values as tuple
    public fun return_multiple(): (u8, u64, bool) {
        (123, 456u64, true)
    }

    // public inline helper function
    public inline fun helper_add(a: u64, b: u64): u64 {
        a + b
    }

    // public function returning struct and u64
    public fun return_struct_and_u64(): (Data, u64) {
        let d = Data { x: 7, y: 77u64 };
        (d, 99u64)
    }

    // public function returning ResourceType
    public fun return_resource(): ResourceType {
        ResourceType { val: 1001u64 }
    }

    // public runner function: runs a test of returning values and uses them
    public fun run_tests() {
        // test multiple returns
        let (a, b, c) = Self::return_multiple();
        let sum = Self::helper_add(b, 10u64);
        let (data, val) = Self::return_struct_and_u64();
        let resource = Self::return_resource();

        // just to exercise usage of those variables without assertions
        let _ = a;
        let _ = c;
        let _ = sum;
        let _ = data.x;
        let _ = data.y;
        let _ = val;
        let _ = resource.val;
    }
}
//# run 0xCAFE::ModuleMembers::run_tests --signers 0xCAFE


//# run
script {
    use 0xCAFE::ModuleMembers;

    fun main() {
        // --- Test module member aliasing ---

        // alias the constant
        let cst = ModuleMembers::CONST_VALUE;
        let new_val = cst + 10u64;

        // alias the struct
        let data_instance = ModuleMembers::Data { x: 200u8, y: new_val };

        // alias function multiple return call
        let (x, y, z) = ModuleMembers::return_multiple();

        // alias inline helper
        let added = ModuleMembers::helper_add(x as u64, data_instance.y);

        // alias function returning struct and u64
        let (d2, val2) = ModuleMembers::return_struct_and_u64();

        // alias function returning resource
        let resource = ModuleMembers::return_resource();

        // use the aliased members to avoid unused warnings
        let _ = z;
        let _ = added;
        let _ = val2;
        let _ = d2.x;
        let _ = d2.y;
        let _ = resource.val;
    }
}

// Featurres:
// 38c9b5c668830d116f1ace86df64486f: Declare distinct kinds of module members in a Move module.
// e5a715fbeb59c9ecf5bedade3cc590d2: Use module member aliasing to refer to module members more conveniently.
// 39a5276d71bb4576631a14e3c7dab09f: Support functions with multiple return values by generating appropriate result temporaries and labels.
