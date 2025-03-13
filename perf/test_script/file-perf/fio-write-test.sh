#!/bin/bash

output_file="fio_results.csv"

echo "blocksize,IOPS,Throughput(MB/s),Latency(usec)" > $output_file

blocksizes=( "8k" "32k" "128k" "512k" "2m" "8m")
filename="testfile"
size="1G"
runtime=30
rw_mode="write"

for bs in "${blocksizes[@]}"; do
    echo "Running FIO with blocksize=$bs..."
    
    fio --name=test --rw=$rw_mode --bs=$bs --direct=1 --size=$size --iodepth=16 --runtime=$runtime --filename=$filename --output-format=json | awk '/^{/{flag=1} flag' > fio_output.json
    
    iops=$(jq '.jobs[0].write.iops' fio_output.json)
    throughput=$(jq '.jobs[0].write.bw' fio_output.json) # Bandwidth in KB/s
    latency=$(jq '.jobs[0].write.lat_ns.mean' fio_output.json) # Latency in nanoseconds

    throughput_mb=$(echo "scale=2; $throughput / 1024" | bc)

    latency_usec=$(echo "scale=2; $latency / 1000" | bc)

    echo "$bs,$iops,$throughput_mb,$latency_usec" >> $output_file
done
