# Deep-learning for Ionogram Automatic Scaling
by Zhuowei Xiao, Jian Wang, Juan Li, Biqiang Zhao, Lianhuan Hu and Libo Liu

Code for paper 'Deep-learning for Ionogram Automatic Scaling'

Link to dataset: (Will be given after publication).

## Prerequisites
- Python3.6
- Tensorflow2
- Segmentation-Models
- PyYaml

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
python dias_main.py --train --config-file YOUR_CONFIG_PATH
```

## Testing
To test, run
```
python dias_main.py --test --config-file YOUR_CONFIG_PATH
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
If you have any suggestions and questions, please send email to jianwang@mail.iggcas.ac.cn or xiaozhuowei@mail.iggcas.ac.cn    
