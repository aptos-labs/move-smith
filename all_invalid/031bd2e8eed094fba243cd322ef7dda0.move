//# publish
module 0x1::DependencyModule {
    resource struct R {
        value: u64,
    }

    public fun new_r(value: u64): R {
        R { value }
    }
}

//# publish
module 0x1::MainModule {
    use 0x1::DependencyModule::R;

    #[skip(mutable_reference_arguments, unused_variable)]
    resource struct Container {
        r: R,
    }

    public fun init_container(v: u64): Container {
        Container {
            r: R::new_r(v),
        }
    }

    #[skip(unused_variable)]
    public fun do(container: &mut Container, v: u64) {
        // If v is even, increment the inner resource value by v,
        // else decrement by v.
        let r_ref = &mut container.r;
        if (v % 2 == 0) {
            r_ref.value = r_ref.value + v;
        } else {
            // Using wrapping_sub to simulate possible underflow cases
            r_ref.value = r_ref.value.wrapping_sub(v);
        }
    }

    // Runner function that modifies a Container with some logic
    public fun runner() {
        let mut c = init_container(10);
        do(&mut c, 5);
        do(&mut c, 8);
        // no returns or asserts, just exercising state changes
    }
}
//# run 0x1::MainModule::runner

//# run
script {
    use 0x1::MainModule::{init_container, do};

    fun main() {
        let mut c = init_container(20);

        // Call do with odd number (should decrement)
        do(&mut c, 3);

        // Call do with even number (should increment)
        do(&mut c, 4);
    }
}