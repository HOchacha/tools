#!/bin/bash

output_file="fio_results-rw.csv"

echo "blocksize,READ-IOPS,READ-Throughput(MB/s),READ-Latency(usec),WRITE-IOPS,WRITE-Throughput(MB/s),WRITE-Latency(usec)" > $output_file

blocksizes=( "8k" "32k" "128k" "512k" "2m" "8m")
filename="testfile"
size="1G"
runtime=30
rw_mode="randrw"

for bs in "${blocksizes[@]}"; do
    echo "Running FIO with blocksize=$bs..."
    sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
    fio --name=test --rw=$rw_mode --bs=$bs --size=$size --iodepth=16 --runtime=$runtime --filename=$filename --output-format=json | awk '/^{/{flag=1} flag' > fio_output.json
    
    read_iops=$(jq '.jobs[0].read.iops' fio_output.json)
    read_throughput=$(jq '.jobs[0].read.bw' fio_output.json) # Bandwidth in KB/s
    read_latency=$(jq '.jobs[0].read.lat_ns.mean' fio_output.json) # Latency in nanoseconds

    write_iops=$(jq '.jobs[0].write.iops' fio_output.json)
    write_throughput=$(jq '.jobs[0].write.bw' fio_output.json) # Bandwidth in KB/s
    write_latency=$(jq '.jobs[0].write.lat_ns.mean' fio_output.json)

    read_throughput_mb=$(echo "scale=2; $read_throughput / 1024" | bc)
    read_latency_usec=$(echo "scale=2; $read_latency / 1000" | bc)

    write_throughput_mb=$(echo "scale=2; $write_throughput / 1024" | bc)
    write_latency_usec=$(echo "scale=2; $write_latency / 1000" | bc)

    echo "$bs,$read_iops,$read_throughput_mb,$read_latency_usec,$write_iops,$write_throughput_mb,$write_latency_usec" >> $output_file
done