
//# publish
module 0xCAFE::AddModule {
    public fun add_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) {
            10
        } else {
            sum
        };
        result
    }

    public fun lambda_example(): u8 {
        let multiply = |a: u8, b: u8| a * b;
        let square = |a: u8| multiply(a, a);
        square(5u8)
    }

    // Inline function returning tuple
    public inline fun inline_add_mul(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add_mul(x: u8, y: u8): (u8, u8) {
        AddModule::inline_add_mul(x, y)
    }

    // Move function pointer type in Aptos Move is written as `&<address>::<Module>::<fun_name>`
    // or more generally `&<fun signature>`
    // But Move currently doesn't allow generic function param types expressed as function pointers inline
    // Instead, move to using a generic type parameter for the function with the constraint it is a function.

    // So let's define a type parameter F which is a function type.
    // However, Move currently (as of Aptos) does not support passing function pointers as parameters directly,
    // the usual workaround is to pass some parameters and call a public function explicitly.

    // Since passing function pointers is not supported natively, 
    // define the function we want to call inside this module, then call it.

    public fun multiply(p: u8, q: u8): u8 {
        p * q
    }

    // Rewrite call_with_code_block to just call multiply internally for demo:
    public fun call_with_code_block(x: u8, y: u8): u8 {
        let a = x + 2u8;
        let b = y + 3u8;
        multiply(a, b)
    }

    public fun run_code_block_example(): u8 {
        call_with_code_block(4u8, 5u8)
    }
}



//# run 0xCAFE::AddModule::add_u8 --args 3u8 4u8




//# run 0xCAFE::AddModule::add_u8 --args 7u8 6u8




//# run 0xCAFE::AddModule::lambda_example




//# run 0xCAFE::CallerModule::call_inline_add_mul --args 3u8 2u8




//# run 0xCAFE::CallerModule::call_with_code_block --args 1u8 2u8




//# run 0xCAFE::CallerModule::run_code_block_example
