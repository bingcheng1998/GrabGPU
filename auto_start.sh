#!/bin/bash

# 定义日志文件路径
LOG_FILE="/tmp/gpu_monitor.log"

# 检查GPU平均利用率的函数
check_gpu_utilization() {
    local duration=10  # 检查时长（秒）
    local threshold=30  # 利用率阈值（百分比）
    local sum=0
    local count=0

    for ((i = 0; i < duration; i++)); do
        utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | awk '{sum+=$1} END {print sum/NR}')
        sum=$(echo "$sum + $utilization" | bc)
        count=$((count + 1))
        sleep 1
    done

    average_utilization=$(echo "$sum / $count" | bc)
    echo "[$(date)] GPU Average Utilization: $average_utilization%" | tee -a "$LOG_FILE"

    if (( $(echo "$average_utilization < $threshold" | bc -l) )); then
        return 0  # 如果平均利用率小于阈值，返回0（成功）
    else
        return 1  # 否则返回1（失败）
    fi
}

# 主循环
while true; do
    echo "[$(date)] Checking GPU utilization..." | tee -a "$LOG_FILE"
    if check_gpu_utilization; then
        echo "[$(date)] GPU Utilization is below threshold. Running ./gg..." | tee -a "$LOG_FILE"
        ./gg 1 48 0,1,2,3,4,5,6,7
        echo "[$(date)] ./gg execution completed." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] GPU Utilization is above threshold. Skipping this round." | tee -a "$LOG_FILE"
    fi
    sleep 300  # 每5分钟检查一次
done