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
#[derive(Default, Debug, Clone, Deserialize)]
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

/// A counter that will
/// * Upon first invocation to `incr`, select a random number in range like `RandomNumber` as the limit
/// * When `incr` is called:
///   * If the counter has reached the limit, it will return false
///   * If the counter has not reached the limit, it will randomly decide whether to increase the counter
///   * If the counter is increased, it will return true. Otherwise, it will return false
#[derive(Default, Debug, Clone, Deserialize)]
pub struct RandomCounter {
    /// Same as `min` in `RandomNumber`
    pub min: usize,
    /// Same as `target` in `RandomNumber`
    pub target: usize,
    /// Same as `max` in `RandomNumber`
    pub max: usize,

    #[serde(skip)]
    once_value: Option<usize>,

    #[serde(skip)]
    curr_value: Option<usize>,
}

impl RandomCounter {
    pub fn incr(&mut self, u: &mut Unstructured) -> bool {
        // First invocation
        if self.once_value.is_none() {
            let rand_num = RandomNumber::new(self.min, self.target, self.max);
            let v = rand_num
                .select(u)
                .expect("Failed to select a random number");
            self.once_value = Some(v);
        }
        if self.curr_value.is_none() {
            self.curr_value = Some(0);
        }

        let do_incr = bool::arbitrary(u).unwrap();
        if !do_incr {
            return false;
        }

        let limit = self.once_value.unwrap();
        let curr = self.curr_value.unwrap();
        if curr >= limit {
            return false;
        }
        self.curr_value = Some(curr + 1);
        true
    }
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
        trace!("NUM: selected value: {v:?} from: {self:?}");
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

pub fn choose_item_weighted<T>(u: &mut Unstructured, item_weights: &[(T, u32)]) -> Result<T>
where
    T: Clone,
{
    let weights = item_weights.iter().map(|(_, w)| *w).collect::<Vec<u32>>();
    let idx = choose_idx_weighted(u, &weights)?;
    Ok(item_weights[idx].0.clone())
}

/// Choose a random index based on the given probabilities.
/// e.g. if `weights` has [10, 20, 20], there are 3 options,
/// so this function will return 0, 1, or 2.
/// The probability for returning each element is based on the given weights.
// TODO: consider using `rand::distributions::WeightedIndex` for this.
// The current `int_in_range` doesn't seems to be evenly distributed.
// Concern is that the fuzzer will not be able to directly control the choice
pub fn choose_idx_weighted(u: &mut Unstructured, weights: &[u32]) -> Result<usize> {
    assert!(!weights.is_empty());
    let sum = weights.iter().sum::<u32>();
    let thresholds = weights
        .iter()
        .scan(0.0f32, |acc, x| {
            *acc += *x as f32 / sum as f32;
            Some(*acc)
        })
        .collect::<Vec<f32>>();

    let choice = u.int_in_range(0..=100)? as f32 / 100.0;
    for (i, threshold) in thresholds.iter().enumerate() {
        if choice <= *threshold {
            return Ok(i);
        }
    }
    Ok(0)
}

pub fn choose_idx_filter<T, F>(
    u: &mut Unstructured,
    items: &[T],
    filter: F,
) -> Result<Option<usize>>
where
    F: Fn(&T) -> bool,
{
    let mut indices = (0..items.len()).collect::<Vec<usize>>();
    while !indices.is_empty() {
        let chosen = u.int_in_range(0..=indices.len() - 1)?;
        let idx = indices[chosen];
        if filter(&items[idx]) {
            return Ok(Some(idx));
        }
        indices.remove(chosen);
    }
    Ok(None)
}

/// Given a list of items, randomly select a subset of indices from the list.
/// The number of indices to select can be specified by `num_to_select`.
/// The returned indices are shuffled.
pub fn choose_indices_subset_shuffled<T>(
    u: &mut Unstructured,
    items: &[T],
    num_to_select: Option<usize>,
) -> Result<Vec<usize>> {
    let mut indices = (0..items.len()).collect::<Vec<usize>>();
    let mut chosen_indices = Vec::new();
    let num_to_select = match num_to_select {
        Some(num) => num,
        None => u.int_in_range(1..=items.len())?,
    };
    for _ in 0..num_to_select {
        let chosen = u.int_in_range(0..=indices.len() - 1)?;
        let idx = indices[chosen];
        chosen_indices.push(idx);
        indices.remove(chosen);
    }
    Ok(chosen_indices)
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand::{rngs::StdRng, Rng, SeedableRng};

    /// Get random bytes
    pub fn get_random_bytes(seed: u64, length: usize) -> Vec<u8> {
        let mut rng = StdRng::seed_from_u64(seed);
        let mut buffer = vec![0u8; length];
        rng.fill(&mut buffer[..]);
        buffer
    }

    fn check_frequency(weights: &[u32], counts: &[u32], tolerance: f64) {
        let sum = weights.iter().sum::<u32>() as f64;
        let total_times = counts.iter().sum::<u32>() as f64;
        for idx in 0..weights.len() {
            let actual = counts[idx];
            let exp = (weights[idx] as f64 / sum) * total_times;
            let lower = (exp * (1.0 - tolerance)) as u32;
            let upper = (exp * (1.0 + tolerance)) as u32;
            let err_msg = format!(
                "Expecting the count for index {idx:?} to be in range [{lower:?}, {upper:?}], got {actual:?}"
            );
            assert!(actual >= lower, "{}", err_msg);
            assert!(actual <= upper, "{}", err_msg);
        }
    }

    #[test]
    fn test_choose_idx_weighted() {
        let buffer = get_random_bytes(12345, 4096);
        let mut u = Unstructured::new(&buffer);

        let weights = vec![10, 20, 20];
        let mut counts = vec![0u32; weights.len()];

        let total_times = 1000;
        for _ in 0..total_times {
            let idx = choose_idx_weighted(&mut u, &weights).unwrap();
            counts[idx] += 1;
        }
        assert!(counts[0] < counts[1]);
        assert!(counts[0] < counts[2]);
        check_frequency(&weights, &counts, 0.25);
    }

    #[test]
    fn test_choose_idx_zero_weighted() {
        let buffer = get_random_bytes(12345, 4096);
        let mut u = Unstructured::new(&buffer);

        let weights = vec![30, 0, 20];
        let mut counts = vec![0; weights.len()];

        let total_times = 1000;
        for _ in 0..total_times {
            let idx = choose_idx_weighted(&mut u, &weights).unwrap();
            counts[idx] += 1;
        }
        assert_eq!(counts[1], 0);
        check_frequency(&weights, &counts, 0.25);
    }
}
