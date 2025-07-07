//# publish
module 0xCAFE::TestAxiomProperties {
    /// This struct will have axiom properties with additional attributes.
    struct Data has key {
        value: u64,
    }

    /// Property (axiom) describing that value is always positive (non-zero).
    axiom value_positive {
        forall d: Data {
            d.value > 0
        }
    }

    /// Property with additional attribute (like a comment inside axiom).
    axiom value_small {
        // value is always less than 1000
        forall d: Data {
            d.value < 1000
        }
    }

    /// A friend function to create Data with friend visibility.
    friend fun create_data(value: u64): Data {
        assert!(value > 0 && value < 1000, 1);
        Data { value }
    }
}
//# run 0xCAFE::TestAxiomProperties::create_data --args 42u64

//# publish
module 0xCAFE::FriendVisibilityModule {
    /// A struct with some member fields
    struct FriendStruct has key {
        pub_value: u8,
        friend friend_value: u64,
    }

    /// Create new instance with friend_value set via friend function
    friend fun create_friend_struct(pub_val: u8, friend_val: u64): FriendStruct {
        FriendStruct {
            pub_value: pub_val,
            friend_value: friend_val,
        }
    }

    /// Public function showing access to friend member is only allowed inside friend functions
    public fun get_pub_value(s: &FriendStruct): u8 {
        s.pub_value
    }

    /// Friend function to read the friend_value field.
    friend fun get_friend_value(s: &FriendStruct): u64 {
        s.friend_value
    }
}
//# run 0xCAFE::FriendVisibilityModule::create_friend_struct --args 7u8 12345u64
//# run 0xCAFE::FriendVisibilityModule::get_friend_value --args 0xCAFE::FriendVisibilityModule::create_friend_struct --signers 0xCAFE

//# publish
module 0xCAFE::GenericModule {
    /// A generic struct holding a value of any type T
    struct Container<T> has store {
        value: T,
    }

    /// Constructor for Container
    public fun new<T>(val: T): Container<T> {
        Container { value: val }
    }

    /// Generic function that returns the contained value
    public fun get_value<T>(c: &Container<T>): &T {
        &c.value
    }

    /// A generic function that swaps values inside two Containers
    public fun swap_values<T>(c1: &mut Container<T>, c2: &mut Container<T>) {
        let temp = &c1.value;
        c1.value = std::mem::replace(&mut c2.value, std::mem::replace(&mut c1.value, *temp));
    }

    /// Runner function to test generic Container creation and get
    public fun runner() {
        let c = Self::new<u64>(100u64);
        let _v = Self::get_value(&c);
    }
}
//# run 0xCAFE::GenericModule::runner

//# run
script {
    use 0xCAFE::TestAxiomProperties;
    use 0xCAFE::FriendVisibilityModule;
    use 0xCAFE::GenericModule;

    fun main() {
        // Test creating data using friend function
        let data = TestAxiomProperties::create_data(500);
        // FriendStruct creation and access
        let fs = FriendVisibilityModule::create_friend_struct(10, 5555);
        let pub_val = FriendVisibilityModule::get_pub_value(&fs);
        let friend_val = FriendVisibilityModule::get_friend_value(&fs);

        // Generic module usage
        let mut container1 = GenericModule::new<u64>(10);
        let mut container2 = GenericModule::new<u64>(20);
        GenericModule::swap_values(&mut container1, &mut container2);
    }
}

// Featurres:
// 1ebef9f7d1703a5635de74d53bd7cf18: Include properties for the 'axiom' to describe additional attributes or conditions.
// 32a3d22aeb7067ed00066a8924dc310a: Declare module members with optional 'friend' visibility modifier
// d6bfc12445a3e71a2f3add7f4a83133f: Use type parameters to define generic types and functions that can operate on various data types.
