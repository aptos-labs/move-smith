//# run

script {
    fun main() {
        let mut x = 1u64;
        let mut y = 2u64;
        let mut z = 3u64;
        mutate_and_sum(&mut x, &mut y, &mut z);
    }

    // Dummy implementation of mutate_and_sum for completeness
    fun mutate_and_sum(x: &mut u64, y: &mut u64, z: &mut u64) {
        *x = *x + 1;
        *y = *y + 1;
        *z = *z + 1;
    }
}