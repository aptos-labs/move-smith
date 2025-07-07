
//# publish
module 0xCAFE::MyModule {
    // Define the inline function f2 that takes u16 and returns a tuple (u8, u8)
    public inline fun f2(a: u16): (u8, u8) {
        // For example, split a into two bytes
        let x = (a >> 8) as u8;
        let y = (a & 0xFF) as u8;
        (x, y)
    }
}

//# publish
module 0xCAFE::AddAndLambda {
    public fun add_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        
        // returning a specific value (let's say the sum + 10)
        sum + 10
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = lambda(x, y);
        result
    }
    
    public fun caller_inline(a: u16): u8 {
        // Calling inline function from MyModule
        let (x, y) = 0xCAFE::MyModule::f2(a);
        // Use the results to compute something and return u8 - x + y mod 256
        let res = (x + y) as u8;
        res
    }
}



//# run 0xCAFE::AddAndLambda::add_u8 --args 23u8 19u8



//# run 0xCAFE::AddAndLambda::apply_lambda --args 11u8 12u8



//# run 0xCAFE::AddAndLambda::caller_inline --args 100u16
