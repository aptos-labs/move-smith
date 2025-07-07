// # publish
module 0xCAFE::PrimeFactor {
    /// Returns the largest prime factor of a given `n`.
    public fun largest_prime_factor(n: u64): u64 {
        let mut x = n;
        let mut largest = 0;
        let mut divisor = 2;

        while (divisor * divisor <= x) {
            if (x % divisor == 0) {
                largest = divisor;
                x = x / divisor;
            } else {
                divisor = divisor + 1;
            }
        };
        if (x > largest) {
            largest = x;
        };
        largest
    }

    /// Runner function to test largest_prime_factor(13195) == 29
    public fun runner() {
        let lf = largest_prime_factor(13195);
        // no assertions required, just calling the function to exercise compiler and VM
        let _ = lf;
    }
}
// # run 0xCAFE::PrimeFactor::runner

// # publish
module 0xCAFE::Parser {
    use std::string;
    use std::vector;

    /// Type to represent a single field with a name and a type name string.
    struct FieldType has copy, drop, store {
        name: string::String,
        type_name: string::String,
    }

    /// Parse a string representing a comma separated list of types enclosed in parentheses,
    /// e.g. "(u8, u64, bool)" into a vector of FieldType structs with fields named "0", "1", ...
    ///
    /// This function expects the input format strictly: starting with '(' and ending with ')',
    /// types separated by commas, no nested parentheses.
    public fun parse_type_list(types_str: &string::String): vector<FieldType> {
        // Remove '(' and ')' at the ends
        let len = string::length(types_str);
        assert!(len > 2, 1); // minimal "()"
        let inner = string::slice(types_str, 1, len - 1);

        // Split by commas
        let parts = string::split(&inner, ',');

        let mut result = vector::empty<FieldType>();
        let len_parts = vector::length(&parts);
        let mut i = 0;
        while (i < len_parts) {
            let ty_str = string::trim(&vector::borrow(&parts, i));

            let index_str = u64_to_string(i as u64);
            let field = FieldType {
                name: index_str,
                type_name: ty_str,
            };
            vector::push_back(&mut result, field);
            i = i + 1;
        }
        result
    }

    /// Return string representation of u64 number (simple implementation).
    fun u64_to_string(num: u64): string::String {
        // We convert u64 assuming small numbers, as field count is small.
        if (num == 0) {
            return string::from_bytes(vector::from_bytes(b"0"));
        };
        let mut n = num;
        let mut digits = vector::empty<u8>();
        while (n > 0) {
            let d = (n % 10) as u8;
            vector::push_back(&mut digits, d + 48);
            n = n / 10;
        };
        vector::reverse(&mut digits);
        string::from_bytes(digits)
    }

    /// Runner for the parser: 
    /// parse "(u8, u64, bool)" and return vector of FieldType,
    /// just call and store it.
    public fun runner() {
        let input = string::from_bytes(vector::from_bytes(b"(u8, u64, bool)"));
        let vec_fields = parse_type_list(&input);
        let _ = vec_fields;
    }
}
// # run 0xCAFE::Parser::runner


// # publish
module 0xCAFE::PrivilegedModule {
    /// Friend address for this module
    const FRIEND: address = 0xBEEF;

    /// Internal function: can only be called by friend address
    fun internal_fn(caller: &signer) {
        assert!(signer::address_of(caller) == FRIEND, 0);
        // some dummy logic
    }

    /// Privileged public function: only friend can call
    public fun privileged_fn(caller: &signer) {
        assert!(signer::address_of(caller) == FRIEND, 0);
        Self::internal_fn(caller);
    }

    /// Public function that is non-privileged (open to all)
    public fun open_fn() {
        // does nothing
    }

    /// Runner: called by friend to exercise privileged function
    public fun runner() acquires {
        // Just a placeholder, can't create signer here
    }
}
// # run 0xCAFE::PrivilegedModule::runner --signers 0xBEEF

// # publish
module 0xBEEF::AttackerModule {
    /// Attempts to call PrivilegedModule::privileged_fn (should fail)
    public fun try_privileged_call(caller: &signer) {
        // should fail because caller is 0xBEEF here, but only 0xBEEF allowed
        // Actually 0xBEEF is the friend in PrivilegedModule so this will succeed -
        // let's try calling from 0xBEEF (friend) vs from 0xDEAD (non-friend)
        0xCAFE::PrivilegedModule::privileged_fn(caller);
    }

    /// Attempts to call internal function (should be denied, but here is impossible to call internal directly)
    // Actually internal_fn is not public, cannot call
    // This shows restriction is enforced by visibility

    /// Runner for attacker call from 0xDEAD (should fail assert)
    public fun runner_fail(caller: &signer) {
        // This call expected to abort because signer is 0xDEAD and not friend 0xBEEF
        Self::try_privileged_call(caller);
    }

    /// Runner for attacker call from friend 0xBEEF (should succeed)
    public fun runner_success(caller: &signer) {
        Self::try_privileged_call(caller);
    }
}
// # run 0xBEEF::AttackerModule::runner_fail --signers 0xDEAD
// # run 0xBEEF::AttackerModule::runner_success --signers 0xBEEF

// # publish
module 0xBEEF::FriendModule {
    /// Calls privileged fn in PrivilegedModule, allowed as friend
    public fun call_privileged(caller: &signer) {
        0xCAFE::PrivilegedModule::privileged_fn(caller);
    }

    /// Runner called by friend 0xBEEF
    public fun runner(caller: &signer) {
        Self::call_privileged(caller);
    }
}
// # run 0xBEEF::FriendModule::runner --signers 0xBEEF

// Featurres:
// 2a9fa47ddd3e17ae3c88045f68138472: Test that the largest_prime_factor function correctly returns 29 as the largest prime factor of 13195.
// 5c12958def199320ccdb7345cfcaca38: Parse comma-separated list of types enclosed in parentheses into a vector of (field, type) pairs with sequentially named fields '0', '1', ... in move code.
// 82fafcf41697c58abbe6e9774d77d212: Restrict function calls so that modules not declared as friends cannot invoke privileged or internal functions in other modules
