//# publish
module 0xabc::test_module {
    public fun compute(p: u64): u64 {
        1 + (p + {p = p + 2; p})
    }
}

//# run 0xabc::test_module::compute --args 10

//# publish
module 0xdef::loop_test {
    fun empty_range() {
        let counter = 0;
        for (i in 20..10) {
            counter = counter + 1; // Should not execute
        };
        assert!(counter == 0, 42);
    }

    fun inclusive_range() {
        let sum = 0;
        for (i in 1..=3) { // Rust style inclusive, Move may differ; using standard range
            sum = sum + i;
        };
        assert!(sum == 6, 42);
    }

    public fun run_all() {
        Self::empty_range();
        Self::inclusive_range();
    }
}
//# run 0xdef::loop_test::run_all

//# publish
module 0x789::enum_update {
    enum DataVariant has drop {
        Alpha{x: u64, y: u8},
        Beta{x: u64, y: u8, z: u32},
        Gamma{flag: bool}
    }

    public fun update_alpha() -> u64 {
        let mut variant = DataVariant::Alpha {x: 100, y: 10};
        match &mut variant {
            DataVariant::Alpha {x, ..} => {
                *x = 50;
                *x
            }
            _ => 0,
        }
    }

    public fun update_beta_z() -> u32 {
        let mut variant = DataVariant::Beta {x: 200, y: 20, z: 30};
        match &mut variant {
            DataVariant::Beta {z, ..} => {
                *z = 99;
                *z
            }
            _ => 0,
        }
    }

    public fun update_gamma_flag() -> bool {
        let mut variant = DataVariant::Gamma {flag: false};
        match &mut variant {
            DataVariant::Gamma {flag} => {
                *flag = true;
                *flag
            }
            _ => false,
        }
    }
}

//# run 0x789::enum_update::update_alpha
//# run 0x789::enum_update::update_beta_z
//# run 0x789::enum_update::update_gamma_flag