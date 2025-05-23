# 抢占显卡脚本


## 使用前编译

```shell
nvcc gg.cu -o gg
```

## 拉起后台任务5分钟监测一次，并拉起占位任务

```shell
chmod +x ./auto_start.sh
nohup sh ./auto_start.sh > /tmp/gpu_monitor_output.log 2>&1 &
```

## 修改占有率

gg.cu 文件开头
```cuda
const int max_block_dim = 1024;
const int max_sleep_time = 1e3;
const float sleep_interval = 1e16;
```

## 抢占到显卡后自动执行默认脚本
**使用方法：**  
```shell
./gg <占用显存 (GB)> <占用时间 (h)> <显卡序号>
```

**举例：**  
抢占 1 GB 显存 24 小时，使用 GPU 0, 1, 2, 3 来运行默认脚本。
```shell
./gg 1 24 0,1,2,3,4,5,6,7
```

## 抢占到显卡后自动执行自定义程序（比如训练模型）
**使用方法：**  
```shell
./gg <占用显存 (GB)> <占用时间 (h)> <显卡序号> <自定义脚本路径（.sh文件）>
```

**举例：**  
抢占 16 GB 显存 24 小时，使用 GPU 0, 1, 2, 3 来运行自定义脚本 `run.sh`。注意这里的占用时间是无效的，会直到自定义脚本执行完毕才释放显卡。
```shell
./gg 16 24 0,1,2,3 run.sh
```
