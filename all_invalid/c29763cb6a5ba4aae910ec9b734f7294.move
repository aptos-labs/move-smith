
//# publish
module 0xCAFE::ModuleIdTest {
    use std::vector;
    use std::string;

    // Dummy struct to simulate ModuleId construction
    struct ModuleId has copy, drop, store {
        address: address,
        name: vector<u8>,
    }

    // Function to construct ModuleId from address and string name
    public fun construct_module_id(addr: address, name: vector<u8>): ModuleId {
        ModuleId {
            address: addr,
            name,
        }
    }

    public fun get_address(module_id: &ModuleId): address {
        module_id.address
    }

    public fun get_name(module_id: &ModuleId): vector<u8> {
        // Replace vector::copy with vector::deep_copy (correct function name)
        vector::deep_copy(&module_id.name)
    }
}



//# run 0xCAFE::ModuleIdTest::construct_module_id --args 0xCAFE b"ModuleIdTest"

// We cannot run get_address and get_name without arguments,
// they expect &ModuleId which we cannot provide here, so remove or comment out these run commands.


//# run 0xCAFE::ModuleIdTest::get_address --args


//# run 0xCAFE::ModuleIdTest::get_name --args




//# publish
module 0xCAFE::CopyMoveDropTest {
    struct CopyDropStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct MoveOnlyStruct has drop, store {
        x: u64,
        y: u64,
    }

    public fun test_copy_move_primitive() {
        let x = 5u8;
        let y = copy x; // copy primitive

        let z = x + y;
        let _ = z;
    }

    public fun test_copy_move_struct() {
        let s1 = CopyDropStruct {a: 10, b: 20};
        let s2 = copy s1; // copied struct

        let s3 = s1; // moved struct, s1 cannot be used after this
        let _ = s2.a + s3.b;
    }

    public fun test_move_only_struct() {
        let m1 = MoveOnlyStruct {x: 100, y: 200};
        let m2 = m1; // move m1 to m2

        // We cannot copy MoveOnlyStruct because it lacks copy ability.

        let _ = m2.x + m2.y;
    }
}



//# run 0xCAFE::CopyMoveDropTest::test_copy_move_primitive


//# run 0xCAFE::CopyMoveDropTest::test_copy_move_struct


//# run 0xCAFE::CopyMoveDropTest::test_move_only_struct




//# publish
module 0xCAFE::GenericTypeSpecTest {
    struct Container<T> has store, drop {
        value: T,
    }

    public fun create_container_u8(val: u8): Container<u8> {
        Container<u8> { value: val }
    }

    public fun create_container_address(addr: address): Container<address> {
        Container<address> { value: addr }
    }

    public fun get_value_u8(container: &Container<u8>): u8 {
        container.value
    }

    public fun get_value_address(container: &Container<address>): address {
        container.value
    }
}



//# run 0xCAFE::GenericTypeSpecTest::create_container_u8 --args 42u8


//# run 0xCAFE::GenericTypeSpecTest::create_container_address --args 0xCAFE

// get_value_u8 and get_value_address require arguments of type &Container<T>, cannot run without arguments.


//# run 0xCAFE::GenericTypeSpecTest::get_value_u8 --args


//# run 0xCAFE::GenericTypeSpecTest::get_value_address --args
