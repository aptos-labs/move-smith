//# publish
module 0xABC::global_resource_permissions {
    /// A resource with various permissions specified.
    struct PermittedResource has key, store {
        data: u64,
        // Permissions could be represented as booleans for simplicity
        read_perm: bool,
        write_perm: bool,
    }

    /// Initialize a resource with specific read/write permissions.
    public fun init(s: &signer, data: u64, read: bool, write: bool) {
        move_to(s, PermittedResource { data, read_perm: read, write_perm: write });
    }

    /// Function that reads the resource's data, with 'reads' annotation.
    fun read_resource(address: address): u64 reads 0xABC::global_resource_permissions::* {
        let res = borrow_global<PermittedResource>(address);
        // enforce read permission
        assert!(res.read_perm, 42);
        res.data
    }

    /// Function that writes to the resource's data, with 'writes' annotation.
    fun write_resource(address: address, new_value: u64) writes 0xABC::global_resource_permissions::* {
        let res = borrow_global_mut<PermittedResource>(address);
        // enforce write permission
        assert!(res.write_perm, 42);
        res.data = new_value;
    }

    /// Function attempting to read resource without permissions (should fail)
    fun fail_read(address: address) reads 0xABC::global_resource_permissions::* {
        let res = borrow_global<PermittedResource>(address);
        // forcibly ignore permissions to simulate failure
        // This will cause a runtime assert if read_perm is false
        assert!(res.read_perm, 42);
        res.data
    }

    /// Function attempting to write resource without permissions (should fail)
    fun fail_write(address: address, val: u64) writes 0xABC::global_resource_permissions::* {
        let res = borrow_global_mut<PermittedResource>(address);
        // forcibly ignore permissions to simulate failure
        // This will cause a runtime assert if write_perm is false
        assert!(res.write_perm, 42);
        res.data = val;
    }
}

//# run --signers 0x1 -- verbose
//# run 0xABC::global_resource_permissions::init --args 100u64 true false
//# run --signers 0x1 -- verbose
//# run 0xABC::global_resource_permissions::read_resource --args 0x1
//# run 0xABC::global_resource_permissions::write_resource --args 0x1 200u64
//# run --signers 0x1 -- verbose
//# run 0xABC::global_resource_permissions::read_resource --args 0x1
//# run 0xABC::global_resource_permissions::fail_read --args 0x1
//# run 0xABC::global_resource_permissions::fail_write --args 0x1 300u64

    //# publish
module 0xDEF::calculate_lcm {
    /// Compute gcd of two numbers
    public fun gcd(a: u64, b: u64): u64 {
        if (b == 0) {
            return a;
        } else {
            gcd(b, a % b)
        }
    }

    /// Compute lcm of two numbers
    public fun lcm(a: u64, b: u64): u64 {
        (a * b) / gcd(a, b)
    }

    /// Compute least common multiple of all numbers from 1 up to 'limit'
    public fun compute_lcm_upto(limit: u64): u64 {
        let result = 1;
        let i = 1;
        while (i <= limit) {
            result = lcm(result, i);
            i = i + 1;
        };
        result
    }

    /// Test function to verify lcm calculations for 10 and 20
    public fun test_calculations() {
        assert!(compute_lcm_upto(10) == 2520, 0);
        assert!(compute_lcm_upto(20) == 232792560, 1);
        // Additional test: verify lcm up to 5 (should be 60)
        assert!(compute_lcm_upto(5) == 60, 2);
        // Edge case: limit 1 (should be 1)
        assert!(compute_lcm_upto(1) == 1, 3);
        // Edge case: limit 0 (since loop won't run, result remains 1)
        assert!(compute_lcm_upto(0) == 1, 4);
    }
}

//# run 0xDEF::calculate_lcm::test_calculations