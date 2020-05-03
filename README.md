# Deep-learning for Ionogram Automatic Scaling
by Zhuowei Xiao, Jian wang, Juan Li, Biqiang Zhao, Lianhuan Hu and Libo Liu
Deep-learning for Ionogram Automatic Scaling

Code for paper 'Deep-learning for Ionogram Automatic Scaling'

Link to dataset will be given below after publication.

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

Pretrained models can be downloaded from []()

## Testing
```bash
python run_model.py --input_path=./testing_set --output_path=./testing_res
```

You can use `--gpu` argument to specifiy gpu. 

### Evaluation
You can evaluate the model's performance by running script:

## Training

We trained our model using the dataset from 
[DeepDeblur_release](https://github.com/SeungjunNah/DeepDeblur_release). 
Please put the dataset into `training_set/`. And the provided `datalist_gopro.txt` 
can be used to train the model. 

Hyper parameters such as batch size, learning rate, epoch number can be tuned through command line:

```bash
python run_model.py --phase=train --batch=16 --lr=1e-4 --epoch=4000
```


## Reference
If you use any part of our code, or SRN-Deblur is useful for your research, please consider citing:
(Will be given after publication)


## Contact
We are glad to hear if you have any suggestions and questions.

Please send email to jianwang@mail.iggcas.ac.cn or xiaozhuowei@mail.iggcas.ac.cn    
