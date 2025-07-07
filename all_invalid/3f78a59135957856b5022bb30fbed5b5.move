
//# publish
module 0xCAFE::GenericAccessControl {
    use std::signer;
    use std::vector;

    struct ResourceR has store {
        value: u64,
    }

    struct ResourceW has store {
        value: u64,
    }

    /// A resource that holds a resource of type R and a resource of type W under same address.
    struct Container<R: store, W: store> has key {
        read_resource: R,
        write_resource: W,
    }

    /// Initialize Container storing R and W resources under the signer's address.
    public fun init_container<R: store, W: store>(s: signer, read_val: u64, write_val: u64) {
        let r = ResourceR { value: read_val };
        let w = ResourceW { value: write_val };
        let container = Container<R, W> { read_resource: r, write_resource: w };
        move_to<Container<R, W>>(&s, container);
    }

    /// NOTE: Move does not support type aliases for functions (i.e., `type` in this position is not allowed)
    /// We just declare functions inline and pass them directly as parameters.

    /// A public function to read value from the Container using a function value as permissioned read.
    public fun read_with_access_control<R: store>(s: &signer, container_ref: &Container<R, ResourceW>, read_fn: &fun(&Container<R, ResourceW>, &signer): u64): u64 {
        read_fn(container_ref, s)
    }

    /// A public function to write value to the Container using a function value as permissioned write.
    public fun write_with_access_control<W: store>(s: &signer, container_mut_ref: &mut Container<ResourceR, W>, new_val: u64, write_fn: &fun(&mut Container<ResourceR, W>, &signer, u64): ()) {
        write_fn(container_mut_ref, s, new_val)
    }

    /// A read function implementation to read the read_resource's value
    public fun read_r<R: store>(container_ref: &Container<R, ResourceW>, _s: &signer): u64 {
        container_ref.read_resource.value
    }

    /// A write function implementation to update the write_resource's value
    public fun write_w<W: store>(container_mut_ref: &mut Container<ResourceR, W>, _s: &signer, new_val: u64) {
        container_mut_ref.write_resource.value = new_val;
    }

    /// Runner function exercising read and write access control by function values
    public fun run_access_control(s: signer) {
        init_container<ResourceR, ResourceW>(copy s, 42, 100);

        let container_ref: &mut Container<ResourceR, ResourceW> = borrow_global_mut<Container<ResourceR, ResourceW>>(signer::address_of(&s));

        let val_before = read_with_access_control(&s, container_ref, &read_r<ResourceR>);
        // update write_resource to val_before * 2 using permissioned write function value
        write_with_access_control(&s, container_ref, val_before * 2, &write_w<ResourceW>);

        let val_after = container_ref.write_resource.value;

        let _ = val_before;
        let _ = val_after;
    }

    /// Test that blocks as expressions update and access local variables correctly
    public fun run_blocks_expression(): u64 {
        let x: u64 = 10;
        let y: u64 = {
            let z = x * 2;
            let w = z + 5;
            w
        };
        y
    }

    /// Example function to test peephole optimization patterns:
    /// We do some operations that could be optimized by compiler or VM
    public fun run_peephole() {
        // Simple arithmetic ops to be optimized
        let a = 0u64;
        let b = 1u64;
        while (b < 5) {
            a = a + b;
            b = b + 1;
        };
    }
}



//# run 0xCAFE::GenericAccessControl::run_access_control --signers 0xBEEF



//# run 0xCAFE::GenericAccessControl::run_blocks_expression



//# run 0xCAFE::GenericAccessControl::run_peephole


// Features:
// d24f22da4df48d58f1ad9e427550008c: Test that generic access control using function values enables permissioned read and write operations on any resource type without embedding access logic within each resource.
// c074aa354e9f190e8e202281e65c259f: Test that blocks used as expressions can update and access local variables within a single expression statement.
// 723accf7d7ee7c1993c3850ea135749e: Run peephole optimizers on your Move bytecode to improve performance.
