// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Low level random number/choice selection logic

use arbitrary::{Arbitrary, Result, Unstructured};
use log::trace;
use rand::{rngs::StdRng, SeedableRng};
use rand_distr::{Beta, Distribution};
use serde::Deserialize;

/// The core number selection logic
/// * We want to mostly select sane values that are around to some number we specify
/// * We still want to (very rarely) select large but valid values
#[derive(Debug, Clone, Deserialize)]
pub struct RandomNumber {
    /// The minimum value that can be selected
    pub min: usize,
    /// The threshold value, see documentation for `select`
    pub target: usize,
    /// The maximum value that can be selected
    pub max: usize,
    #[serde(skip)]
    once_value: Option<usize>,
}

/// How often we select sane values vs large values
/// Divisor of 10000
const DEFAULT_THRESHOLD: usize = 9950;

/// Constants for the Beta distribution
const DEFAULT_ALPHA: f64 = 4.0;
const DEFAULT_BETA: f64 = 9.0;

impl RandomNumber {
    pub fn new(min: usize, target: usize, max: usize) -> Self {
        assert!(min <= max);
        assert!(target >= min && target <= max);

        Self {
            min,
            target,
            max,
            once_value: None,
        }
    }

    /// Select a random number
    /// * Most of the time, we will selected something in [min, target*2]. See `select_small`.
    /// * Rarely, we will select something greater than `target*2`. See `select_large`.
    pub fn select(&self, u: &mut Unstructured) -> Result<usize> {
        if self.min == self.max {
            return Ok(self.min);
        }

        let v = if u.ratio(DEFAULT_THRESHOLD, 10000usize)? {
            self.select_small(u)
        } else {
            self.select_large(u)
        };
        trace!("NUM: selected value: {:?} from: {:?}", v, self);
        v
    }

    /// Select a number upon first time and cache it
    pub fn select_once(&mut self, u: &mut Unstructured) -> Result<usize> {
        if let Some(v) = self.once_value {
            return Ok(v);
        }
        let v = self.select(u)?;
        self.once_value = Some(v);
        Ok(v)
    }

    /// Select a number within [min, target*2]
    /// We use a Beta distribution that skew towards left of the target
    /// The mode of the distribution is around
    /// $(target * 2 - min) * (ALPHA - 1) / (ALPHA + BETA - 2)$
    fn select_small(&self, u: &mut Unstructured) -> Result<usize> {
        let dist = Beta::new(DEFAULT_ALPHA, DEFAULT_BETA).expect("Invalid Beta distribution");
        let mut rng = StdRng::seed_from_u64(u64::arbitrary(u)?);
        let value = dist.sample(&mut rng);

        let range = (self.target * 2 - self.min) as f64;
        let mapped = value * range + self.min as f64;
        Ok(mapped.round() as usize)
    }

    /// We simply map some raw bytes to a value in [target*2, max]
    /// so the distribution is controlled by the fuzzer
    fn select_large(&self, u: &mut Unstructured) -> Result<usize> {
        u.int_in_range(self.target * 2..=self.max)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utils::get_random_bytes;
    use serde::Deserialize;
    use std::collections::BTreeMap;
    use toml;

    #[test]
    fn test_random_number_selection() {
        let total: f64 = 100000.0;
        let target = 10;
        let s = RandomNumber::new(0, target, 255);

        let buffer = get_random_bytes(1234, 16 * total as usize);
        let mut u = Unstructured::new(&buffer);

        let bucket_num = 10usize;
        let mut buckets = BTreeMap::new();

        let mut very_sane_cnt: usize = 0;
        let mut insane_cnt: usize = 0;
        let mut left_cnt: usize = 0;
        let mut right_cnt: usize = 0;
        let mut target_cnt: usize = 0;

        for _ in 0..(total as usize) {
            use std::cmp::Ordering::*;
            let n = s.select(&mut u).unwrap();
            match n.cmp(&target) {
                Less => left_cnt += 1,
                Equal => target_cnt += 1,
                Greater => right_cnt += 1,
            }
            if n >= target / 2 && n <= target * 2 {
                very_sane_cnt += 1;
            } else if n > target * 2 {
                insane_cnt += 1;
            }
            let bucket = n / bucket_num;
            *buckets.entry(bucket).or_insert(0) += 1;
        }
        for (bucket, count) in &buckets {
            println!("Bucket {}: {}", bucket, count);
        }
        let very_sane_percentage = (very_sane_cnt as f64 / total) * 100.0;
        let insane_percentage = (insane_cnt as f64 / total) * 100.0;
        let target_percentage = (target_cnt as f64 / total) * 100.0;
        let left_percentage = (left_cnt as f64 / total) * 100.0;
        let right_percentage = (right_cnt as f64 / total) * 100.0;

        println!(
            "Very sane numbers: {} ({:.2}%)",
            very_sane_cnt, very_sane_percentage
        );
        println!("Insane numbers: {} ({:.2}%)", insane_cnt, insane_percentage);
        println!(
            "Number of target: {} ({:.2}%)",
            target_cnt, target_percentage
        );
        println!("Number of left: {} ({:.2}%)", left_cnt, left_percentage);
        println!("Number of right: {} ({:.2}%)", right_cnt, right_percentage);

        assert!(very_sane_percentage > 70.0);
        assert!(insane_percentage <= 1.0);
        assert!(left_cnt > right_cnt);
    }

    #[derive(Debug, Deserialize)]
    struct TestGen {
        x: RandomNumber,
        y: RandomNumber,
    }

    #[test]
    fn test_random_number_deserialization() {
        let toml_str = r#"
            x = { min = 0, target = 10, max = 255 }
            y = { min = 5, target = 100, max = 111 }
        "#;
        let gen = toml::from_str::<TestGen>(toml_str).unwrap();
        assert_eq!(gen.x.min, 0);
        assert_eq!(gen.x.target, 10);
        assert_eq!(gen.x.max, 255);
        assert_eq!(gen.y.min, 5);
        assert_eq!(gen.y.target, 100);
        assert_eq!(gen.y.max, 111);
        println!("{:#?}", gen);
    }
}
