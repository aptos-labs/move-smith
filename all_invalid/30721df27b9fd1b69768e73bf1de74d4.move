
//# publish
module 0xBADD::PrimeFactor {
    // This module provides a utility function for prime factorization
    public fun largest_prime_factor(n: u64): u64 {
        let largest_factor = 1;
        let temp_n = n;
        let divisor = 2;

        while (divisor * divisor) <= temp_n {
            if (temp_n % divisor == 0) {
                largest_factor = divisor;
                // update temp_n
                let quotient = temp_n / divisor;
                temp_n = quotient;
                // Reset divisor to 2 after division
                divisor = 2;
            } else {
                divisor = divisor + 1;
            };
        };
        if (temp_n > largest_factor) {
            largest_factor = temp_n;
        };
        largest_factor
    }
}

//# publish
module 0xCAFE::AccessControl {
    use std::error;
    use std::signer;
    use std::vector;

    // Generic access control pattern: functions that take function values
    public fun permissioned_read<T>(
        resource: &T,
        access_fn: &fun(&signer::Signer): bool,
        signer_addr: &signer::Signer
    ): bool {
        if (access_fn(signer_addr)) {
            true
        } else {
            false
        }
    }

    public fun permissioned_write<T>(
        resource: &mut T,
        access_fn: &fun(&signer::Signer): bool,
        signer_addr: &signer::Signer
    ) acquires T {
        if (access_fn(signer_addr)) {
            // Dummy write operation
            true
        } else {
            false
        }
    }

    // Example resource
    struct Resource has store, key {
        data: u64
    }

    // Access control functions
    public fun allow_all(_s: &signer::Signer): bool {
        true
    }

    public fun deny_all(_s: &signer::Signer): bool {
        false
    }

    // Function to demonstrate generic permissioned access
    public fun test_permissioned_access(signer_addr: &signer::Signer) {
        let res = Resource { data: 42 };
        // Test read with allow_all
        let _ = permissioned_read(&res, &allow_all, signer_addr);
        // Test write with allow_all
        let _ = permissioned_write(&mut res, &allow_all, signer_addr);
        // Test read with deny_all
        let _ = permissioned_read(&res, &deny_all, signer_addr);
        // Test write with deny_all
        let _ = permissioned_write(&mut res, &deny_all, signer_addr);
    }
}


//# run 0xBADD::PrimeFactor::largest_prime_factor --args 100u64


//# run 0xCAFE::AccessControl::test_permissioned_access --signers 0xDUMMY --args


// Featurres:
// 0b89dd6ddc06f3fa01b23ecf6ecef9c6: Test that the `largest_prime_factor` function correctly identifies the largest prime factor of a given number.
// d24f22da4df48d58f1ad9e427550008c: Test that generic access control using function values enables permissioned read and write operations on any resource type without embedding access logic within each resource.
// 380e15dd9e7623b85786841db007105f: Use temporary variables in your expressions
