
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed number 42 if sum exceeds 40, else sum
        if (sum > 40) {
            42
        } else {
            sum
        }
    }
}



//# run 0xCAFE::ComputeAdd::add_two_values --args 20u8 21u8



//# publish
module 0xCAFE::LambdaExamples {

    public fun pure_lambda_call(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| { a * 2 };
        lambda(x)
    }

    public fun lambda_with_capture(x: u8): u8 {
        let y = 10u8;
        let lambda: |u8| u8 has copy+drop = |a: u8| { a + y };
        lambda(x)
    }
}



//# run 0xCAFE::LambdaExamples::pure_lambda_call --args 15u8



//# run 0xCAFE::LambdaExamples::lambda_with_capture --args 5u8



//# publish
module 0xCAFE::InlineCaller {

    use 0xCAFE::ComputeAdd;

    public inline fun call_inline_add(a: u8, b: u8): u8 {
        ComputeAdd::add_two_values(a, b)
    }

    public fun nested_function_call(x: u8, y: u8): u8 {
        let result = Self::call_inline_add(x, y);
        result + 1u8
    }
}



//# run 0xCAFE::InlineCaller::nested_function_call --args 20u8 21u8



//# publish
module 0xCAFE::ResourceManager {
    use std::signer;

    struct Res has store, key {
        val: u8,
    }

    public fun create_resource(account: signer, val: u8) {
        let resource = Res { val };
        move_to<Res>(&account, resource);
    }

    public fun read_resource(addr: address): u8 {
        let res_ref = borrow_global<Res>(addr);
        res_ref.val
    }

    public fun update_resource(account: signer, new_val: u8) {
        let res_mut_ref = borrow_global_mut<Res>(signer::address_of(&account));
        res_mut_ref.val = new_val;
    }

    public fun remove_resource(addr: address) {
        let moved_res = move_from<Res>(addr);
        let Res { val: _ } = moved_res;  // Destructure but do nothing with val
    }
}



//# run 0xCAFE::ResourceManager::create_resource --signers 0xBABA --args 7u8



//# run 0xCAFE::ResourceManager::read_resource --args 0xBABA



//# run 0xCAFE::ResourceManager::update_resource --signers 0xBABA --args 77u8



//# run 0xCAFE::ResourceManager::read_resource --args 0xBABA



//# run 0xCAFE::ResourceManager::remove_resource --args 0xBABA



//# publish
module 0xCAFE::BytecodeGen {

    // Dummy stackless-style function to trigger bytecode generation
    public fun dummy_stackless_fn(x: u8): u8 {
        let y = x + 1;
        y
    }

    // This function just calls dummy_stackless_fn repeatedly to generate bytecode units
    public fun generate_bytecode_load() {
        let _ = Self::dummy_stackless_fn(10u8);
        let _ = Self::dummy_stackless_fn(20u8);
        let _ = Self::dummy_stackless_fn(30u8);
    }
}



//# run 0xCAFE::BytecodeGen::generate_bytecode_load



//# publish
module 0xCAFE::ModuleChecker {
    use std::vector;

    // Checks if a module identified by address and name exists in the current context
    // We simulate a dummy check by returning true for our own module name
    public fun check_module_exists(addr: address, name: vector<u8>): bool {
        // For testing, only 0xCAFE::ModuleChecker is treated as present
        if (addr == @0xCAFE && vector::length(&name) == 13 && *vector::borrow(&name, 0) == 109u8) {
            // 'm' in ascii is 109, roughly check
            true
        } else {
            false
        }
    }
}



//# run 0xCAFE::ModuleChecker::check_module_exists --args 0xCAFE b"ModuleChecker"


// A script to test ComputeAdd add_two_values with varying inputs


//# run
script {
    use 0xCAFE::ComputeAdd;
    fun main() {
        let _res1 = ComputeAdd::add_two_values(1u8, 2u8);
        let _res2 = ComputeAdd::add_two_values(30u8, 15u8);
    }
}

// A script to test lambdas in LambdaExamples


//# run
script {
    use 0xCAFE::LambdaExamples;
    fun main() {
        let _ = LambdaExamples::pure_lambda_call(7u8);
        let _ = LambdaExamples::lambda_with_capture(3u8);
    }
}

// A script to test InlineCaller nested function call returning nested results


//# run
script {
    use 0xCAFE::InlineCaller;
    fun main() {
        let _ = InlineCaller::nested_function_call(10u8, 31u8);
    }
}

// A script to test ResourceManager resource lifecycle


//# run
script {
    use 0xCAFE::ResourceManager;
    use std::signer;

    fun main(account: signer) {
        ResourceManager::create_resource(account, 9u8);
        let _ = ResourceManager::read_resource(signer::address_of(&account));
        ResourceManager::update_resource(account, 18u8);
        let _ = ResourceManager::read_resource(signer::address_of(&account));
        ResourceManager::remove_resource(signer::address_of(&account));
    }
}

// A script to test BytecodeGen's dummy stackless function to generate code


//# run
script {
    use 0xCAFE::BytecodeGen;
    fun main() {
        BytecodeGen::generate_bytecode_load();
    }
}

// A script to test ModuleChecker utility check_module_exists


//# run
script {
    use 0xCAFE::ModuleChecker;
    fun main() {
        let exists = ModuleChecker::check_module_exists(@0xCAFE, b"ModuleChecker");
        let _ = exists;
        let not_exists = ModuleChecker::check_module_exists(@0xBEEF, b"UnknownMod");
        let _ = not_exists;
    }
}
