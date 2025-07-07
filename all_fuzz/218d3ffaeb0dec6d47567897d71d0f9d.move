
//# publish
module 0xCAFE::ClosureShadowing {
    public fun foo(x: u8, f: |u8| u8): u8 {
        // Call closure f with x
        f(x)
    }

    public fun runner() {
        let x = 1u8;

        // closure shadows outer x variable and returns new value
        let closure: |u8| u8 has copy+drop = |x: u8| {
            let x = x + 2;
            x
        };

        let x = foo(x, closure);

        // After foo call, x should be 3
        let _ = x;
    }
}


//# run 0xCAFE::ClosureShadowing::runner



//# publish
module 0xCAFE::MultipleArgs {
    public fun add_three(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }

    public fun runner() {
        let sum = add_three(1u8, 2u8, 3u8);
        let _ = sum;
    }
}


//# run 0xCAFE::MultipleArgs::runner



//# publish
module 0xCAFE::PropertySets {
    struct Car has store {
        brand: vector<u8>,
        year: u16,
        running: bool,
    }

    struct House has store {
        rooms: u8,
        address: vector<u8>,
    }

    struct Person has store {
        name: vector<u8>,
        age: u8,
        car: Car,
        house: House,
    }

    public fun create_person(): Person {
        let my_car = Car {brand: b"Tesla", year: 2022, running: true};
        let my_house = House {rooms: 4u8, address: b"123 Aptos St"};
        Person {name: b"Alice", age: 30u8, car: my_car, house: my_house}
    }

    public fun runner() {
        let person = create_person();
        let running_status = person.car.running;
        let house_rooms = person.house.rooms;
        let _ = (running_status, house_rooms);
    }
}


//# run 0xCAFE::PropertySets::runner


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
