# Deep-learning for Ionogram Automatic Scaling
by Zhuowei Xiao, Jian Wang, Juan Li, Biqiang Zhao, Lianhuan Hu and Libo Liu

Code for paper 'Deep-learning for Ionogram Automatic Scaling'

## Dataset
**link to dataset**: [here.](http://www.geophys.ac.cn/ArticleDataInfo.asp?MetaId=205)

**link to trained model**: 

Google Drive [here.](https://drive.google.com/file/d/109BTXlLsxSE_5LSV8SWxlggOZHjodhDT/view?usp=sharing)

Baiduyun [here](https://pan.baidu.com/s/1BXr_zVxLHG2SdOcv43QWSw) Code: 2ftt

If you want to use your own data, you may first use 'GRM2HourlyRSF.m' and 'saveSAO2mat.m' matlab scripts to extract ionograms from GRM data.
Then you may refer to jupyter notebooks under folder 'convert_GRM_to_input' to change data into desired format.

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
You can use `--gpu` argument to specifiy gpu. 
To train a model, first create a configuration file (see example_config.yaml)
Then run
```
python dias_main.py --train --gpu_id 0 --config-file YOUR_CONFIG_PATH
```
Tips: According to feedback that certain implementations of RAdam optimizer have problems in training convergence in this program, switch to Adam optimizer can solve the problem.

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
Zhuowei Xiao, Jian Wang*, Juan Li, Biqiang Zhao, Lianhuan Hu, Libo Liu. Deep learning for Ionogram Automatic Scaling. 2020. Advances in Space Research. https://doi.org/10.1016/j.asr.2020.05.009.


## Contact
If you have any questions, please send email to jianwang@mail.iggcas.ac.cn or xiaozhuowei@mail.iggcas.ac.cn    
