
//# publish
module 0xCAFE::TestModule {
    // Define struct variants with named fields
    struct MyStruct {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    // Define a struct with copy and drop abilities
    struct CopyDropStruct has copy, drop {
        x: u8,
        y: u8,
    }

    // Function to create and return a MyStruct instance
    public fun create_struct(a: u64, b: bool, c: vector<u8>): MyStruct {
        MyStruct { a, b, c }
    }

    // Function to test referencing and mutating a struct
    public fun mutate_struct(s: &mut MyStruct, new_a: u64) {
        s.a = new_a;
    }

    // Closure-like function: just a function that takes a by-reference parameter
    public fun invoke_with_ref(f: &fun(&mut CopyDropStruct): (), s: &mut CopyDropStruct) {
        f(s)
    }
}


//# run
script {
    use 0xCAFE::TestModule;

    // Create a struct instance
    let my_struct = TestModule::create_struct(42, true, b"hello");
    // Construct a mutable local variable
    let my_mut_struct = my_struct;

    // Mutate the struct via function
    TestModule::mutate_struct(&mut my_mut_struct, 100);

    // Create an instance of CopyDropStruct
    let c = CopyDropStruct { x: 1, y: 2 };

    // Reference to the closure-like function
    let f_ref = &TestModule::invoke_with_ref;

    // Define a function to be passed that mutates CopyDropStruct
    fun mutate_copy_drop(s: &mut CopyDropStruct) {
        s.x = s.x + 1;
        s.y = s.y + 1;
    }

    // Invoke the closure-like function with the mutable reference
    f_ref(&mut mutate_copy_drop, &mut c);
}


//# run 0xCAFE::TestModule::invoke_with_ref --signers 0xCAFE --args 

// Featurres:
// 155007288c9ed8bcacb4766bb2688942: Define struct variants with named fields using braces ({ ... })
// 2405661452d0059721ed6e84ace71488: Use identifiers for naming variables, functions, modules, and other Move constructs that do not conflict with reserved keywords.
// 1838265b96ee199f371b3d9b6c493bdf: Test that closures with drop and copy abilities can be referenced and mutated via & and &mut, and correctly invoked through references.
