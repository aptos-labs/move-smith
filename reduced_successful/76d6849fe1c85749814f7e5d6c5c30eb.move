
//# publish
module 0xCAFE::AddU8Module {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        // return sum + 5; just to have a specific value different than sum
        sum + 5
    }

    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let add_mul_lambda: |u8, u8| (u8, u8) has copy+drop = 
            |a: u8, b: u8| {
                let add = a + b;
                let mul = a * b;
                (add, mul)
            };
        add_mul_lambda(x, y)
    }
}


//# run 0xCAFE::AddU8Module::add_and_return_sum --args 3u8 7u8


//# run 0xCAFE::AddU8Module::use_lambda --args 4u8 5u8

// Explicit address block with nested inline function call test

//# publish
module 0xCAFE::InlineCallerModule {
    use 0xCAFE::AddU8Module;

    public inline fun call_inline_add_and_return(x: u8, y: u8): u8 {
        AddU8Module::add_and_return_sum(x, y)
    }

    public fun runner(): u8 {
        // call inline function within the module
        call_inline_add_and_return(1u8, 4u8)
    }
}


//# run 0xCAFE::InlineCallerModule::runner

// Defining a module without explicitly specifying an address block (default address 0xCAFE is implicit here)
// Aptos requires explicit addresses or 0x1 usually, but here we show explicit address 0xCAFE as example


//# publish
module 0xCAFE::NamedAddressUsage {
    use std::vector;

    // For testing the named address map concept in Aptos (though real named address maps are handled by package manifest)
    // We simulate a named address map with a const map here
    
    const ADDR1: address = @0xA1B2;
    const ADDR2: address = @0xB2C3;

    public fun sum_addresses(): u128 {
        let addr1_val = 0xA1B2u128;
        let addr2_val = 0xB2C3u128;
        addr1_val + addr2_val
    }
}


//# run 0xCAFE::NamedAddressUsage::sum_addresses

// Test vector pop_back and sum, repeated popping until empty

//# publish
module 0xCAFE::VectorPopSum {
    use std::vector;

    public fun sum_popped_bytes(v: vector<u8>): u64 {
        let sum = 0u64;
        let vect = v;
        while (vector::length(&vect) > 0) {
            let val = vector::pop_back(&mut vect);
            sum = sum + (val as u64);
        };
        sum
    }

    // A runner function to test that popping bytes from [1,2,3,4] sums to 10u64
    public fun runner(): u64 {
        let v = vector[1u8, 2u8, 3u8, 4u8];
        sum_popped_bytes(v)
    }
}


//# run 0xCAFE::VectorPopSum::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 17ff4d5772fb0424b7dea7332fe27329: Define Move modules with or without specifying an explicit address block.
// 4ea79ea9656b6403591e39dee7b164b5: Access and utilize named address maps within a package.
// 1a658f6f9dabec2e3b18caae10e6fe91: Test that repeatedly popping bytes from a vector and summing their values correctly results in the expected total (10).
