* [all_fuzz](./all_fuzz/): 1636 files from the most recent fuzzing session
    * [reduced_unique_cov](./reduced_unique_cov/): a subset of all_fuzz containing 329 files that achieves all the unique coverage
        * [reduced_unique_cov/0000_coverage_report.md](./reduced_unique_cov/0000_coverage_report.md): detailed information about the unique lines/branches each test covers
    * [reduced_successful](./reduced_successful/): a subset of all_fuzz containing 180 files that are (1) compilable (2) no runtime error
* [all_invalid](./all_invalid/): 4880 invalid Move files gathered from various different generation setup
