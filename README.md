# Deep-learning for Ionogram Automatic Scaling
by Zhuowei Xiao, Jian Wang, Juan Li, Biqiang Zhao, Lianhuan Hu and Libo Liu

Code for paper 'Deep-learning for Ionogram Automatic Scaling'

## Dataset
**link to dataset**: [here.](http://www.geophys.ac.cn/ArticleDataInfo.asp?MetaId=205)

If you want to use your own data, you may first use 'GRM2HourlyRSF.m' and 'saveSAO2mat.m' matlab scripts to extract ionograms from GRM data.
Then you may refer to jupyter notebook 'ConvertMat2PickleData.ipynb' under folder 'convert_GRM_to_input' to change data into desired format.

## Prerequisites
- [Python3.6](https://www.python.org)
- [Tensorflow2](https://www.tensorflow.org)
- [Segmentation-Models](https://github.com/qubvel/segmentation_models)
- [PyYaml](https://pyyaml.org/)

(If you are not familiar with python, we suggest you to use [Anaconda](https://www.anaconda.com
) to install these prerequisites.)


## Installation
Clone this project to your machine. 

```bash
git clone https://github.com/MrXiaoXiao/DIAS
cd DIAS
```

## Training
Pretrained models can be downloaded from: (Will be given after publication) []()
You can use `--gpu` argument to specifiy gpu. 
To train a model, first create a configuration file (see example_config.yaml)
Then run
```
python dias_main.py --train --gpu_id 0 --config-file YOUR_CONFIG_PATH
```

## Testing
To test, run
```
python dias_main.py --test --gpu_id 0 --config-file YOUR_CONFIG_PATH
```

### Evaluation
You can evaluate the model's performance by running script:
```
python dias_main.py --eval --config-file YOUR_CONFIG_PATH
```

## Reference
If you find our work useful for your research, please consider citing:
(Will be given after publication)


## Contact
If you have any questions, please send email to jianwang@mail.iggcas.ac.cn or xiaozhuowei@mail.iggcas.ac.cn    
