
//# publish
module 0xDEAD::StructAndFunctionTest {
    use std::vector;

    struct Person has store, key {
        name: vector<u8>,
        age: u8,
        active: bool,
    }

    struct DataHolder<T> has store, key {
        data: T,
        timestamp: u64,
    }

    enum Status has copy, drop {
        Init,
        Ready(u32),
        Error { code: u16 },
    }

    public fun create_person(name: vector<u8>, age: u8, active: bool): Person {
        Person { name, age, active }
    }

    public fun create_dataholder_u32(data: u32, timestamp: u64): DataHolder<u32> {
        DataHolder { data, timestamp }
    }

    public fun create_status_init(): Status {
        Status::Init
    }

    public fun create_status_ready(code: u32): Status {
        Status::Ready(code)
    }

    public fun create_status_error(code: u16): Status {
        Status::Error { code }
    }

    // Function with multiple parameters
    public fun process_person(p: Person, multiplier: u8): bool {
        p.age == multiplier
    }

    // Function with generic type parameter and tuple return
    public fun get_data_and_age<T>(holder: DataHolder<T>): (T, u64) {
        (holder.data, 12345)
    }

    // Function that creates a package registration (simulated for testing package info)
    public fun register_package(package_name: vector<u8>, version: u32): bool {
        // Simulate package registration logic
        true
    }
}


//# run 0xDEAD::StructAndFunctionTest::create_person --args b"John Doe" 30 true
//

//# run 0xDEAD::StructAndFunctionTest::create_dataholder_u32 --args 42u32 1627848382
//

//# run 0xDEAD::StructAndFunctionTest::create_status_init
//

//# run 0xDEAD::StructAndFunctionTest::create_status_ready --args 404u32
//

//# run 0xDEAD::StructAndFunctionTest::create_status_error --args 65535u16
//

//# run 0xDEAD::StructAndFunctionTest::process_person --args \
    //0xDEAD::StructAndFunctionTest::create_person(b"Alice", 25, true), 25u8
//

//# run 0xDEAD::StructAndFunctionTest::get_data_and_age --args \
    //0xDEAD::StructAndFunctionTest::create_dataholder_u32(100u32, 99999u64)

// Additionally, test package registration logic, if applicable, by calling `register_package`

//# run 0xDEAD::StructAndFunctionTest::register_package --args b"TestPackage" 1u32

// Featurres:
// 107f519cdb04a9583c77986ee754dd01: Define struct fields with types, and ensure each field has a unique name within the struct definition.
// 6316d8fa2d30e15c3c8423f8853e1553: Create function definitions with correct naming, visibility, and optional 'entry' modifier.
// 475cd32e93a90a6dfa812a8bbfdc6ae3: Process package definitions to register modules, their addresses, and deprecation information within the compiler context.
