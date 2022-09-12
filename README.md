# Mirror images action

## Mirror images to aliyun

```sh
cat mirror.d/cluster/kubespray/kubespray-v2.19.0-images.list   | xargs -t ./copy-image.sh docker.io/kanzihuang registry-vpc.cn-beijing.aliyuncs.com/kanzihuang
```
