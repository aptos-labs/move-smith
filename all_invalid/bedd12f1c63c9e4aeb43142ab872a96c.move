//# publish
module 0xCAFE::SpecWithTemplate {

    use std::signer;
    use std::vector;

    /// A simple struct with a type parameter, storing a vector of T values.
    struct Container<T> has copy, drop, store, key {
        values: vector<T>,
    }

    /// A specification block attached to Container<T>.
    /// It contains a reusable property template that expresses the container is never empty.
    ///
    /// Note the use of a lambda style expression in the spec.
    ///
    /// `forall<T>`
    /// `spec container_never_empty = 
    ///    (lambda c: &Container<T> { vector::length(&c.values) > 0u64 })`

    spec container_never_empty<T> {
        (c: &Container<T>) {
            vector::length(&c.values) > 0u64
        }
    }

    /// A test function to publish a Container and test properties.
    /// It constructs a Container<u8> with some values.
    public fun runner(s: &signer) {
        let c = Container<u8> { values: vector::singleton<u8>(42u8) };
        move_to(s, c);
    }

}

///# run 0xCAFE::SpecWithTemplate::runner --signers 0xCAFE


//# publish
module 0xCAFE::SpecWithTemplate2 {

    use std::vector;

    /// A struct with 2 type parameters, holding 2 values.
    struct Pair<T, U> has copy, drop, store, key {
        first: T,
        second: U,
    }

    /// Specification block with multiple call arguments separated by comma.
    ///
    /// A reusable property template that requires `first` to be less than `second`.
    ///
    /// Note the lambda expression with multiple parameters separated by commas.
    spec pair_ordered<T: copy + drop + store + key, U: copy + drop + store + key> {
        (p: &Pair<T, U>, cmp: &fn(&T, &U): bool) {
            cmp(&p.first, &p.second)
        }
    }

    /// Dummy comparison function.
    public inline fun less_than(a: &u64, b: &u64): bool {
        *a < *b
    }

    /// Runner function that stores a valid Pair<u64, u64> matching the spec.
    public fun runner(s: &signer) {
        let p = Pair<u64, u64> { first: 1u64, second: 2u64 };
        move_to(s, p);
    }
}

///# run 0xCAFE::SpecWithTemplate2::runner --signers 0xCAFE


//# publish
module 0xCAFE::SpecLambdas {

    use std::vector;

    /// A struct with a vector-u8 and a bool to test spec lambdas.
    struct Data has copy, drop, store, key {
        values: vector<u8>,
        flag: bool,
    }

    /// A spec block using lambda-style expressions lifted into functions.
    ///
    /// Here we test multiple call arguments separated by commas inside the lambda.
    spec data_spec {
        (d: &Data, threshold: u8) {
            let is_nonempty = (lambda v: &vector<u8> { vector::length(v) > 0u64 });
            let flag_ok = (lambda f: bool, limit: u8 { f == (limit > 0u8) });
            is_nonempty(&d.values) && flag_ok(d.flag, threshold)
        }
    }

    /// Runner initializes Data with vector length 1 and flag == true.
    public fun runner(s: &signer) {
        let v = vector::singleton<u8>(10u8);
        let d = Data { values: v, flag: true };
        move_to(s, d);
    }

}

///# run 0xCAFE::SpecLambdas::runner --signers 0xCAFE


//# run
script {

    use 0xCAFE::SpecWithTemplate;
    use 0xCAFE::SpecWithTemplate2;
    use 0xCAFE::SpecLambdas;

    fun main() {
        // Create signers for each module runner call.
        // We reuse 0xCAFE since spec runner only needs one signer.

        SpecWithTemplate::runner(&signer::address_of(&signer::borrow_global<signer::Signer>(0xCAFE)));
        SpecWithTemplate2::runner(&signer::address_of(&signer::borrow_global<signer::Signer>(0xCAFE)));
        SpecLambdas::runner(&signer::address_of(&signer::borrow_global<signer::Signer>(0xCAFE)));
    }
}

// Featurres:
// ec40b4e0854ce5b71390346074abe0ef: Attach specification blocks to schemas with type parameters for reusable property templates.
// fde3067b4279feb6bf0ad115fc730ec6: Use lambda-style expressions in specifications, which will be lifted into new functions for later specification rewriting and processing.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
