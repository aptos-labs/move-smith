
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // we return sum + 0, testing that the function returns sum correctly
        sum + 0
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 7u8 8u8



//# publish
module 0xCAFE::LambdaModule {
    public fun lambda_usage(x: u8, y: u8): (u8, u8) {
        let adder: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        let (sum, product) = adder(x, y);
        (sum, product)
    }
}


//# run 0xCAFE::LambdaModule::lambda_usage --args 5u8 4u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    public inline fun call_add_inline(a: u8, b: u8): u8 {
        AddModule::add_and_return_sum(a, b)
    }
}


//# run 0xCAFE::InlineCaller::call_add_inline --args 10u8 20u8



//# publish
module 0xCAFE::EscapeSequenceModule {
    public fun get_escaped_bytes(): vector<u8> {
        let escaped: vector<u8> = b"\n\r\t\\\0\'";
        escaped
    }
}


//# run 0xCAFE::EscapeSequenceModule::get_escaped_bytes



//# publish
module 0xCAFE::SpecAxiomModule {
    spec module {
        // axiom with optional type parameter
        axiom forall<T> (v: T): bool
            ensures true;
    }
    public fun dummy() {}
}


//# run 0xCAFE::SpecAxiomModule::dummy



//# publish
module 0xCAFE::ReassignCondModule {
    public fun reassign_cond(cond: bool, orig: address, new_addr: address): address {
        let result = orig;
        if (cond) {
            result = new_addr;
        } else {
            let _ignore = 0; // the else branch does nothing and returns orig
        };
        result
    }
}


//# run 0xCAFE::ReassignCondModule::reassign_cond --args false 0xABCD 0xCAFE


//# run 0xCAFE::ReassignCondModule::reassign_cond --args true 0xABCD 0xCAFE


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 42ecf60fd5ae050cd222ae469e4762fc: Handle common escape sequences like '\n', '\r', '\t', '\\', '\0', and '\
// c5b868ba5c7847d6238e1d7b80ebae2f: Annotate 'axiom' conditions with optional type parameters in specification blocks.
// bf3f521551537f1268865efbd834c866: Test that the `reassign_cond` function returns the original address when the boolean condition is false, without reassigning.
