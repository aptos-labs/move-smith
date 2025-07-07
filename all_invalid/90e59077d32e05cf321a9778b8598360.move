// Transactional test for Aptos Move compiler and VM

// Feature 1: Test largest_prime_factor function

//# publish
module 0x1::PrimeUtils {
    public fun largest_prime_factor(mut n: u64): u64 {
        let mut max_prime = 1;
        let mut i = 2;
        while (i * i <= n) {
            if (n % i == 0) {
                max_prime = i;
                n = n / i;
            } else {
                i = i + 1;
            }
        };
        if (n > 1) {
            max_prime = n;
        };
        max_prime
    }

    // Runner with no args for testing: tests with known value
    public fun run_test() {
        let res = Self::largest_prime_factor(13195); // Should return 29
        let res2 = Self::largest_prime_factor(15);    // Should return 5
        let res3 = Self::largest_prime_factor(53);    // Should return 53 (prime)
        // No asserts; simply ensures function is run
        // res, res2, res3 are unused (for code elimination check purposes)
        _ = res;
        _ = res2;
        _ = res3;
    }
}
//# run 0x1::PrimeUtils::run_test --signers 0x1


// Feature 2: Access modifier specification with Acquires/Reads/Writes & negation/address chain

resource struct Foo { val: u64 }
resource struct Bar { val: u8 }

//# publish
module 0x2::AccessMods {
    use std::signer;

    resource struct Dummy { val: u64 }

    // Demonstrates acquires, writes, and reads, with negation/address chain.
    public fun do_nothing(addr: address)
    acquires Foo,
             !Bar,
             0x2::AccessMods::Dummy,
             !0x2::AccessMods::Dummy
    reads Foo, !0x2::AccessMods::Dummy
    writes !Foo, Bar, 0x2::AccessMods::Dummy
    {
        // This function does nothing.
        // Stuff here to prevent dead code elimination
        if (false) {
            let _ = addr;
            assert!(true, 0);
        }
    }

    // Runner to call do_nothing
    public fun run_access_mods_for_self(acct: &signer) {
        let addr = signer::address_of(acct);
        Self::do_nothing(addr);
    }
}
//# run 0x2::AccessMods::run_access_mods_for_self --signers 0x2

// Feature 3: Aggressive simplifications - code elimination when specified

//# publish
module 0x3::AggressiveElim {
    /// Should be eliminated if aggressive DCE is enabled
    fun unused_function() : u64 {
        99
    }

    // Used function - should remain
    public fun runner() {
        // Aggressive DCE should NOT remove this path
        let x = if (true) { 42 } else { unused_function() };
        _ = x;
    }
}
//# run 0x3::AggressiveElim::runner --signers 0x3


// Feature 1 as a transaction script: Testing largest_prime_factor directly

//# run
script {
    fun main() {
        let res = 0x1::PrimeUtils::largest_prime_factor(600851475143); // Should return 6857
        // No assertions, ensures function and compiler/VM exercised
        _ = res;
    }
}