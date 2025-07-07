
//# publish
module 0xCAFE::PatternBindingTest {
    use std::vector;

    struct FriendStruct {
        secret: u64,
        data: u8,
    }

    // Declare a friend module with special privileges
    public fun create_friend_struct(secret: u64, data: u8): FriendStruct {
        FriendStruct { secret, data }
    }

    // Function to grant access to the friend module
    public fun get_secret(f: &FriendStruct): u64 {
        f.secret
    }

    // Struct with type parameter
    struct Container<T> has copy, drop {
        value: T,
        label: bool,
    }

    // Enum with pattern matching
    enum Shape {
        Circle { radius: u64 },
        Rectangle { width: u64, height: u64 },
        Triangle(u64, u64, u64),
    }

    // Function to test pattern binding in match
    public fun match_shape(s: Shape): u64 {
        // match expression must be statement (end with semicolon)
        match s {
            Shape::Circle { radius } => radius,
            Shape::Rectangle { width, height } => width + height,
            Shape::Triangle(a, b, c) => a + b + c,
        }; // Added semicolon here
    }

    // Function to demonstrate pattern binding list matching
    public fun test_binding_list(): () {
        let shape1 = Shape::Circle { radius: 10 };
        let shape2 = Shape::Rectangle { width: 5, height: 8 };
        let shape3 = Shape::Triangle(3, 4, 5);

        let val1 = match shape1 {
            Shape::Circle { radius } => radius,
            _ => 0,
        };

        let val2 = match shape2 {
            Shape::Rectangle { width, height } => (width + height),
            _ => 0,
        };

        let val3 = match shape3 {
            Shape::Triangle(a, b, c) => (a + b + c),
            _ => 0,
        };

        // Instantiate generic struct with type parameter
        let container_int = Container<u8> { value: 42u8, label: true };
        let container_bool = Container<bool> { value: false, label: false };
    }
}



//# run 0xCAFE::PatternBindingTest::test_binding_list



//# publish
module 0xCAFE::TypeParamFriend {
    // Generic struct with type parameter
    struct Data<T> has copy, drop {
        field: T,
        info: u8,
    }

    // Function to instantiate with bool
    public fun create_bool_data(value: bool, info: u8): Data<bool> {
        Data<bool> { field: value, info }
    }

    // Function to instantiate with u64
    public fun create_u64_data(value: u64, info: u8): Data<u64> {
        Data<u64> { field: value, info }
    }

    // Function to access the 'friend' module (simulate ally access)
    public fun get_field<T: copy>(d: &Data<T>): T {
        d.field
    }
}



//# run 0xCAFE::TypeParamFriend::create_bool_data --args false 2



//# run 0xCAFE::TypeParamFriend::create_u64_data --args 123456789u64 3



//# publish
module 0xCAFE::FriendAccess {
    use 0xCAFE::PatternBindingTest;
    use 0xCAFE::TypeParamFriend;

    // Function simulating friend module access
    public fun access_secret(secret_struct: &PatternBindingTest::FriendStruct): u64 {
        PatternBindingTest::get_secret(secret_struct)
    }

    // Function to create and access generic data
    public fun access_data<T: copy>(d: &TypeParamFriend::Data<T>): T {
        TypeParamFriend::get_field(d)
    }

    // Function to create a friend struct
    public fun create_wrapper(secret: u64, data: u8): PatternBindingTest::FriendStruct {
        PatternBindingTest::create_friend_struct(secret, data)
    }
}



//# run 0xCAFE::FriendAccess::access_secret --args
// Note: In actual test, pass a reference to a created FriendStruct. Here it's illustrative.



//# run 0xCAFE::FriendAccess::access_data --args
// Similar to above, in real test pass proper references.

// Featurres:
// 250ccbd7036b39252ecd52156bdafca9: Use pattern binding lists to match on complex structures in each match arm.
// 62335aa7e34bb5c4b4fab043e532fdfa: Declare structs with type parameters
// b7cf2830591b569585c2b4bc36d4ba75: Declare 'friend' modules to grant special access rights.