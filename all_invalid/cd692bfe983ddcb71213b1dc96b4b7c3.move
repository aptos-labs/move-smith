
//# publish
module 0xCAFE::TypeConstraintAndSpecDomain {
    use std::vector;

    struct AA has copy, drop, store {}
    struct BB has copy, drop, store {}

    // Type parameter T constrained by copy and store abilities
    struct Container<T: copy + store> has key, store {
        items: vector<T>
    }

    // A generic function that requires copy and store ability on T
    public fun new_empty_container<T: copy + store>(): Container<T> {
        let items = vector::empty<T>();
        Container { items }
    }

    // A function to push item into container
    public fun add_item<T: copy + store>(container: &mut Container<T>, item: T) {
        vector::push_back(&mut container.items, item);
    }

    // A function to get length of items vector
    public fun length<T: copy + store>(container: &Container<T>): u64 {
        vector::length(&container.items)
    }

    // Using $spec_domain for a type variable S and value variable v
    $spec_domain S: type;
    $spec_domain IntSet = vector<S>;

    spec fun vector_length_in_range(v: IntSet, n: u64) {
        // Value quantified with 'in'
        forall i: u64 in 0..n {
            // Spec assertion over the domain
            vector::index(&v, i);
        }
    }

    // Functions just to test the domain specification exist
    public fun dummy_vec<T: copy + store>(): vector<T> {
        vector::empty()
    }
}


//# run 0xCAFE::TypeConstraintAndSpecDomain::new_empty_container


//# run 0xCAFE::TypeConstraintAndSpecDomain::add_item --args 0xCAFE::TypeConstraintAndSpecDomain::AA


//# run 0xCAFE::TypeConstraintAndSpecDomain::length


//# publish
module 0xCAFE::ErrorLocationDemo {
    // Assign a custom error location attribute to a function using a module identifier
    // error_location(std::vector)]
    public fun dummy_error_fun() {
        // Intentionally empty
    }

    // error_location(0xCAFE::TypeConstraintAndSpecDomain)]
    public fun another_error_fun() {
        // Intentionally empty
    }
}


//# run 0xCAFE::ErrorLocationDemo::dummy_error_fun


//# run 0xCAFE::ErrorLocationDemo::another_error_fun


// Featurres:
// 46c9b97e99d80c136ca51c5f26d07474: Add type constraints to struct type parameters
// 2ad1983493f0719116dabac9d866e541: Specify a domain over which a variable or type is quantified, either using a type domain with `$spec_domain` or a value domain with `in`.
// a92386e32dd4f9878cc5de9d4c9ecd63: Use module identifiers such as 'std::vector' as arguments to 'error_location' attributes
