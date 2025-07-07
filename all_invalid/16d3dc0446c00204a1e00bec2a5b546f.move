
//# publish
module 0xCAFE::SpecIncludeModule {
    const MAX_SUM: u8 = 255;

    spec module {
        include type_check_spec;
    }

    spec type_check_spec {
        fun is_sum_valid(a: u8, b: u8): bool {
            let sum = a + b;
            sum <= MAX_SUM
        }
    }
}
