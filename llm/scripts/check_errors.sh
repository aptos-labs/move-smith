#!/bin/bash
work_dir="$1"
TO_IGNORE_PATH="scripts/minimal_ignore.txt" msmith --run v2-only check --rerun $work_dir/generated_tests -o $work_dir
cat $work_dir/report.txt| grep error | grep -v ".move" | sort | uniq -c | sort -rn > $work_dir/report-errors.txt

rm -rf $work_dir/generated_tests/*.output

no_error_cnt=$(cat $work_dir/fully_successful.txt | wc -l)
total_cnt=$(ls $work_dir/generated_tests/*.move 2>/dev/null | wc -l)
echo "No error tests: $no_error_cnt/$total_cnt"

exit

# For each move file in work_dir, run msmith on it
total=$(ls $work_dir/generated_tests/*.move 2>/dev/null | wc -l)
cnt=0
for file in $work_dir/generated_tests/*.move; do
    if [ -f "$file" ]; then
        echo "($((++cnt))/$total) running on $file"
        msmith --run v2-only run $file -o raw > $work_dir/generated_tests/$(basename "$file").out
    fi
done
