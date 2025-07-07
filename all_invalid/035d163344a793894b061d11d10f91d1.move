module 0x1::TestFeature {

    /// A primitive struct wrapping a u64
    struct PrimitiveWrapper has copy, drop, store {
        value: u64,
    }

    /// A struct using primitive types in its type definition
    struct Container has copy, drop, store {
        id: u8,
        flag: bool,
        counter: u64,
        address: address,
        wrapper: PrimitiveWrapper,
    }

    /// A friend module declared later, to demonstrate 'friend' usage
    friend 0x1::FriendModule;

    /// Initialize a Container with primitive values, using sequences of statements
    public fun init_container(): Container {
        let id: u8;
        let flag: bool;
        let counter: u64;
        let addr: address;
        let wrapper: PrimitiveWrapper;

        // Sequence of assignments
        id = 7;
        flag = true;
        counter = 123;
        addr = @0xA;                              // address literal
        wrapper = PrimitiveWrapper { value: 999 };

        Container {
            id,
            flag,
            counter,
            address: addr,
            wrapper,
        }
    }

    /// Function that demonstrates block scopes and sequences of statements
    public fun process_container(mut container: Container): u64 {
        // Block with a sequence of statements
        {
            container.counter = container.counter + 1;
            if (container.flag) {
                container.id = container.id + 1;
            } else {
                container.id = container.id - 1;
            }
        }

        // Another block
        {
            let w = &container.wrapper;
            assert!(w.value == 999, 42);
        }

        container.counter
    }
}

module 0x1::FriendModule {

    /// This module being friend can access private fields (if any)
    friend 0x1::TestFeature;

    use std::signer;

    /// Access the private fields of Container (should be allowed due to 'friend')
    public fun friend_modify_container(container: &mut 0x1::TestFeature::Container) {
        // Directly mutate private fields
        container.id = 42;
        container.flag = false;
        container.counter = 0;
        container.address = signer::address_of(&signer::new_signer(0xB));
        container.wrapper.value = 777;
    }
}

// Transactional test using the Aptos testing framework

script {

    use 0x1::TestFeature;
    use 0x1::FriendModule;

    fun main() {
        // Create a container
        let mut c = TestFeature::init_container();

        // Assert initial values
        assert!(c.id == 7, 0);
        assert!(c.flag == true, 1);
        assert!(c.counter == 123, 2);
        assert!(c.address == @0xA, 3);
        assert!(c.wrapper.value == 999, 4);

        // Process container: increments counter and adjusts id
        let counter_after = TestFeature::process_container(&mut c);
        assert!(counter_after == 124, 5);
        assert!(c.id == 8, 6);    // was 7, plus 1 due to flag == true

        // Use friend module to mutate container directly
        FriendModule::friend_modify_container(&mut c);

        // Assert mutated values
        assert!(c.id == 42, 7);
        assert!(c.flag == false, 8);
        assert!(c.counter == 0, 9);
        assert!(c.address == @0xB, 10);
        assert!(c.wrapper.value == 777, 11);
    }
}

// Featurres:
// e77687d6a2d417d3ab8f6c23ee9482d8: Use primitive types in type definitions.
// 334af8b93b6806c10fbc9f479f2cef89: Write sequences of statements inside functions or blocks
// 81df5e2bdf888923694038d544bd8b42: Declare friend modules with the 'friend' mechanism.
