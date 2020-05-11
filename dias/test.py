import tensorflow as tf
import numpy as np
from dias.model.FPN_Model import Dias_FPN
from dias.model.Unet_Model import Dias_Unet
from dias.dataIO.data import IonoDataManager
from dias.dataIO.dataPostProcess import get_minH_maxF
import segmentation_models as sm
import matplotlib.pyplot as plt
import os

def test(cfgs):
    print('Setting Model...')
    # set up model
    if cfgs['Model']['Type'] == 'Unet' or cfgs['Model']['Type'] == 'naiveUnet':
        model = Dias_Unet(cfgs)
    elif cfgs['Model']['Type'] == 'FPN':
        model = Dias_FPN(cfgs)
    model.load_weights(cfgs['Test']['ModelPath'])

    threshold = float(cfgs['Test']['Threshold'])
    # set up dataset
    dataManager = IonoDataManager(cfgs)
    all_test_num = len(dataManager.test_data_list)

    # if only save MinH and MaxF
    if cfgs['Test']['TestSave'] == 'OnlyMinHMaxF':
        res_mat = np.zeros([len(dataManager.test_data_list),3,6])
        for idx in range(len(dataManager.test_data_list)):
            test_data, human_res, artist_res = dataManager.get_test_batch(idx)
            Dias_res = model.predict(test_data)
            res_mat[idx,:,0:2] = get_minH_maxF(human_res,threshold)
            res_mat[idx,:,2:4] = get_minH_maxF(artist_res,threshold)
            res_mat[idx,:,4:6] = get_minH_maxF(Dias_res,threshold)
            if idx%100==0:
                print(res_mat[idx,:])
        np.save(cfgs['Test']['SavePath']+'MinHMaxF.npy',res_mat)
    # if save All outputs of the model
    elif cfgs['Test']['TestSave'] == 'AllOutput':
        for idx in range(all_test_num):
            print('On {}'.format(idx))
            test_data, human_res, artist_res = dataManager.get_test_batch(idx)
            Dias_res = model.predict(test_data)
            res_mat = (test_data, human_res, artist_res,Dias_res)
            np.save(cfgs['Test']['SavePath']+'TEST_{}.npy'.format(idx),res_mat)
    else:
        print('Please choose a vaild TestSave Option')
    
    return
