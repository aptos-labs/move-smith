
//# publish
module 0xCAFE::DropToken {
    // Define a struct named DROP with the drop ability
    struct DROP has drop, store {
        value: u8,
    }

    // Create an instance of DROP
    public fun create_drop(value: u8): DROP {
        DROP { value }
    }

    // Consume the DROP token (moves it, triggers drop)
    public fun consume_drop(token: DROP): u8 {
        token.value
    }

    // Runner function to test DROP creation and consumption
    public fun runner(): u8 {
        let token = create_drop(42);
        consume_drop(token)
    }
}


//# run 0xCAFE::DropToken::runner



//# publish
module 0xCAFE::AnyAddrModule {
    // For demonstration, a struct with store ability
    struct Data has store {
        id: u8
    }

    public fun make_data(id: u8): Data {
        Data { id }
    }

    public fun get_id(data: &Data): u8 {
        data.id
    }
}


//# publish
module 0xCAFE::LoopDropAny {
    use 0xCAFE::DropToken;
    use 0xCAFE::AnyAddrModule;

    struct Container has store {
        dropped_values: vector<u8>
    }

    public fun new_container(): Container {
        Container {
            dropped_values: vector::empty<u8>()
        }
    }

    public fun add_value(container: &mut Container, val: u8) {
        vector::push_back(&mut container.dropped_values, val);
    }

    // runner combining for-loop with DROP token and AnyAddrModule
    public fun runner(): u8 {
        let container = new_container();

        // for loop 0..10
        for (i in 0..10) {
            let drop_token = DropToken::create_drop(i as u8);
            let consumed_val = DropToken::consume_drop(drop_token);
            add_value(&mut container, consumed_val);
        };

        // Create data from AnyAddrModule and get id in a match-case to check abilities
        let data = AnyAddrModule::make_data(100);
        let retrieved_id = AnyAddrModule::get_id(&data);

        // Just return the sum of 10 iterations values + retrieved_id
        let sum: u8 = 0;
        // sum values in container.dropped_values vector
        let n = vector::length(&container.dropped_values);
        let idx = 0;
        while (idx < n) {
            let v = *vector::borrow(&container.dropped_values, idx);
            sum = sum + v;
            idx = idx + 1;
        };
        sum = sum + retrieved_id;
        sum
    }
}


//# run 0xCAFE::LoopDropAny::runner



//# run 0xCAFE::DropToken::create_drop --args 123u8


//# run 0xCAFE::DropToken::consume_drop --args 123u8


//# run 0xCAFE::AnyAddrModule::make_data --args 55u8


//# run 0xCAFE::AnyAddrModule::get_id --args 55u8


// Featurres:
// d3fa72cc69505d29275ee408acad95a3: Test that a for loop with a range (0..10) executes without errors in a script.
// 85848185aef1c4d35b1dcaf6ea5c3299: Recognize the 'Drop' ability when the token is an identifier with content 'DROP'.
// 87510c6f568e994b39a270b7aa41452c: Use a wildcard ('any') address specifier for flexible address matching.
