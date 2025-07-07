//# publish
module 0x1::AddressMapping {
    use std::string;
    use std::vector;

    /// A struct representing a target file with an associated address mapping.
    struct TargetFile has copy, drop, store {
        name: string::String,
        address: address,
        content: vector<u8>,
    }

    /// A struct representing a dependency file with associated address mapping.
    struct DependencyFile has copy, drop, store {
        name: string::String,
        address: address,
        content: vector<u8>,
    }

    /// Parses a "file" with given name, address and content.
    public fun parse_target_file(name: string::String, addr: address, content: vector<u8>): TargetFile {
        TargetFile { name, address: addr, content }
    }

    /// Parses a "dependency" file with given name, address and content.
    public fun parse_dependency_file(name: string::String, addr: address, content: vector<u8>): DependencyFile {
        DependencyFile { name, address: addr, content }
    }

    /// An example runner function to exercise parsing.
    public fun runner() {
        let name = string::utf8(b"module.move");
        let content = b"module content bytes".to_vec();
        let _target = parse_target_file(name, @0x1, content);

        let dep_name = string::utf8(b"dep.move");
        let dep_content = b"dependency bytes".to_vec();
        let _dep = parse_dependency_file(dep_name, @0x2, dep_content);
    }
}

//# run 0x1::AddressMapping::runner


//# publish
module 0x2::LintSkipDemo {
    use std::string;

    /// Example functions for demonstrating skip attribute usage.
    #[skip(audit_failure, unused_variable)]
    public fun lint_skipped_function() {
        let _unused: u64 = 42; // unused variable, normally triggers lint
        // we pretend it has an "audit_failure" issue too, but skipping it.
    }

    #[skip(unused_parens)]
    public fun another_skip() {}

    /// runner to call the skipped lint function just to execute.
    public fun runner() {
        lint_skipped_function();
        another_skip();
    }
}

//# run 0x2::LintSkipDemo::runner


//# publish
module 0x3::GenericPhantom {
    use std::marker::Phantom;

    /// Generic struct with two type parameters, T and Phantom type U.
    struct GenericStruct<T, U> has store {
        value: T,
        phantom: Phantom<U>,
    }

    public fun new<T, U> (val: T): GenericStruct<T, U> {
        GenericStruct {
            value: val,
            phantom: Phantom<U>,
        }
    }

    public fun get_value<T, U>(gs: &GenericStruct<T, U>): &T {
        &gs.value
    }

    public fun runner() {
        let s = new<u64, vector<u8>>(123);
        let _v = get_value(&s);
    }
}

//# run 0x3::GenericPhantom::runner


//# publish
module 0x4::AbilityString {
    use std::string;
    use std::vector;
    use std::ability;

    /// Converts an AbilitySet to string list like "+ copy + drop + store"
    public fun ability_set_to_string(ab_set: ability::AbilitySet): string::String {
        let mut abilities: vector<string::String> = vector::empty<string::String>();
        if (ability::has(ab_set, ability::copy())) {
            vector::push_back(&mut abilities, string::utf8(b"copy"));
        }
        if (ability::has(ab_set, ability::drop())) {
            vector::push_back(&mut abilities, string::utf8(b"drop"));
        }
        if (ability::has(ab_set, ability::store())) {
            vector::push_back(&mut abilities, string::utf8(b"store"));
        }
        if (ability::has(ab_set, ability::key())) {
            vector::push_back(&mut abilities, string::utf8(b"key"));
        }
        if (vector::is_empty(&abilities)) {
            string::utf8(b"")
        } else {
            let mut res = string::utf8(b": ");
            let mut first = true;
            let len = vector::length(&abilities);
            let mut i = 0;
            while (i < len) {
                if (!first) {
                    res = string::append(&res, string::utf8(b" + "));
                }
                res = string::append(&res, *vector::borrow(&abilities, i));
                first = false;
                i = i + 1;
            }
            res
        }
    }

    /// Runner that tests the function with some AbilitySets.
    public fun runner() {
        let all_abilities = ability::copy() | ability::drop() | ability::store();
        let s = ability_set_to_string(all_abilities);
        let empty = ability_set_to_string(ability::empty());
        let just_key = ability_set_to_string(ability::key());
        // just to avoid unused warning
        let _ = (s, empty, just_key);
    }
}

//# run 0x4::AbilityString::runner


//# publish
module 0x5::HasAbilityConstraint {
    use std::signer;

    /// A struct that must have 'store' ability
    struct StoreStruct has store {
        value: u64,
    }

    /// Function that requires T to have 'store' ability
    public fun save_value<T has store>(_: &signer, val: T) {
        // do nothing, just a dummy function to test 'has' in signature
        let _ = val;
    }

    /// Runner to invoke save_value with a struct that has the store ability.
    public fun runner(s: &signer) {
        let item = StoreStruct { value: 777 };
        save_value<StoreStruct>(s, item);
    }
}

//# run 0x5::HasAbilityConstraint::runner --signers 0x5


//# run
script {
    use 0x1::AddressMapping;
    use 0x2::LintSkipDemo;
    use 0x3::GenericPhantom;
    use 0x4::AbilityString;
    use 0x5::HasAbilityConstraint;

    fun main(account: signer) {
        AddressMapping::runner();
        LintSkipDemo::runner();
        GenericPhantom::runner();
        AbilityString::runner();
        HasAbilityConstraint::runner(&account);
    }
}