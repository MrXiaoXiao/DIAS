# main program for dispersion picker
import os
import yaml
import argparse

from dias.train import train
from dias.test import test
# add evalute module to main

def dias_main(args):
    """
    Deep-learning for Ionogram Automatic Scaling
    """
    # load configuration file
    cfgs = yaml.load(open(args.config_file), Loader=yaml.BaseLoader)

    # check if train or test
    if not (args.run_train or args.run_test):
        print ('Please set one of the options --train | --test')
        parser.print_help()
        return
    
    # train
    if args.run_train:
        print('Setting Trainer')
        train(cfgs)
        print('Done Training')
        return
    
    # test
    if args.run_test:
        print('Setting Tester')
        test(cfgs)
        print('Done Testing')
        return
    
    return

if __name__ == '__main__':
    # prase config data
    parser = argparse.ArgumentParser(description='Deep-learning-based Ionogram Automatic Scaler')
    parser.add_argument('--config-file', dest='config_file', type=str, help='Experiment configuration file')
    parser.add_argument('--train', dest='run_train', action='store_true', default=False, help='Launch training')
    parser.add_argument('--test', dest='run_test', action='store_true', default=False, help='Launch testing on a list of Ionograms')
    parser.add_argument('--evaluate', dest='run_eval', action='store_true', default=False, help='Launch evaluation on a list of Ionograms')
    parser.add_argument('--gpuid',dest='gpu_id',type=str, default=False, help='Gpu id')

    args = parser.parse_args()
    
    dias_main(args)        
