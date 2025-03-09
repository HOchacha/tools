#!/bin/bash

output_file="fio_results.csv"

# CSV 헤더 작성
echo "blocksize,IOPS,Throughput(MB/s),Latency(usec)" > $output_file

# 테스트 변수 정의
blocksizes=("4k")
filename="testfile"
size="1G"
runtime=30
rw_mode="write"

# 블록 크기별 테스트 수행
for bs in "${blocksizes[@]}"; do
    echo "Running FIO with blocksize=$bs..."
    
    # FIO 실행 및 JSON 형식 결과 저장
    fio --name=test --rw=$rw_mode --bs=$bs --direct=1 --size=$size --iodepth=16 --runtime=$runtime --filename=$filename --output-format=json | awk '/^{/{flag=1} flag' > fio_output.json
    # JSON 파일 유효성 검사
    if [[ ! -s fio_output.json ]]; then
        echo "Error: JSON output is empty or invalid for blocksize=$bs."
        continue
    fi

    # JSON에서 쓰기 결과 추출
    iops=$(jq '.jobs[0].write.iops' fio_output.json)
    throughput=$(jq '.jobs[0].write.bw' fio_output.json) # Bandwidth in KB/s
    latency=$(jq '.jobs[0].write.lat_ns.mean' fio_output.json) # Latency in nanoseconds

    # Bandwidth를 MB/s로 변환
    throughput_mb=$(echo "scale=2; $throughput / 1024" | bc)

    # Latency를 microseconds로 변환
    latency_usec=$(echo "scale=2; $latency / 1000" | bc)

    # 결과를 CSV에 추가
    echo "$bs,$iops,$throughput_mb,$latency_usec" >> $output_file
done

echo "FIO 테스트 완료. 결과는 $output_file에 저장되었습니다."

