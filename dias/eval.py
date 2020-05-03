import numpy as np

def calculate_params(res_mat):
    layerList = ['E','F1','F2']
    res_dict = dict()
    for layer in layerList:
        res_dict[layer] = dict()
    for key in res_dict.keys():
        res_dict[key]['Dias_TruePositiveNum'] = 0
        res_dict[key]['Dias_FalsePositiveNum'] = 0
        res_dict[key]['Dias_TrueNegativeNum'] = 0
        res_dict[key]['Dias_FalseNegativeNum'] = 0
        res_dict[key]['Dias_minH_abs_dev'] = 0
        res_dict[key]['Dias_maxF_abs_dev'] = 0

        res_dict[key]['ART_TruePositiveNum'] = 0
        res_dict[key]['ART_FalsePositiveNum'] = 0
        res_dict[key]['ART_TrueNegativeNum'] = 0
        res_dict[key]['ART_FalseNegativeNum'] = 0
        res_dict[key]['ART_minH_abs_dev'] = 0
        res_dict[key]['ART_maxF_abs_dev'] = 0

    for idx in range(np.shape(res_mat)[0]):
        for jdx, layer in enumerate(layerList):
            t_mat = res_mat[idx,jdx,:]

            if t_mat[0] > 9000:
                human_flag = False
            else:
                human_flag = True
                human_hmin = t_mat[0]
                human_fmax = t_mat[1]
            
            if t_mat[2] > 9000:
                art_flag = False
            else:
                art_flag = True
                art_hmin = t_mat[2]
                art_fmax = t_mat[3]
            
            if human_flag and art_flag:
                res_dict[layer]['ART_TruePositiveNum'] += 1
                res_dict[layer]['ART_minH_abs_dev'] += np.abs(human_hmin - art_hmin)
                res_dict[layer]['ART_maxF_abs_dev'] += np.abs(human_fmax - art_fmax)
            elif (not human_flag) and (not art_flag):
                res_dict[layer]['ART_TrueNegativeNum'] += 1
            elif human_flag and (not art_flag):
                res_dict[layer]['ART_FalseNegativeNum'] += 1
            else:
                res_dict[layer]['ART_FalsePositiveNum'] += 1

            if t_mat[4] > 9000:
                dias_flag = False
            else:
                dias_flag = True
                dias_hmin = t_mat[4]
                dias_fmax = t_mat[5]

            if human_flag and dias_flag:
                res_dict[layer]['Dias_TruePositiveNum'] += 1
                res_dict[layer]['Dias_minH_abs_dev'] += np.abs(human_hmin - dias_hmin)
                res_dict[layer]['Dias_maxF_abs_dev'] += np.abs(human_fmax - dias_fmax)
            elif (not human_flag) and (not dias_flag):
                res_dict[layer]['Dias_TrueNegativeNum'] += 1
            elif human_flag and (not dias_flag):
                res_dict[layer]['Dias_FalseNegativeNum'] += 1
            else:
                res_dict[layer]['Dias_FalsePositiveNum'] += 1

            if human_flag and dias_flag and art_flag:
                if idx < 2600:
                    print(idx)
                    print(np.abs(human_hmin - dias_hmin),np.abs(human_fmax - dias_fmax))
                    print(np.abs(human_hmin - art_hmin),np.abs(human_fmax - art_fmax))
    AVG_ART_minH_abs_dev_up = 0
    AVG_ART_minH_abs_dev_down = 0
    AVG_ART_maxF_abs_dev_up = 0
    AVG_ART_maxF_abs_dev_down = 0
    AVG_ART_Precision_up = 0
    AVG_ART_Precision_down = 0
    AVG_ART_Recall_up = 0
    AVG_ART_Recall_down = 0

    AVG_Dias_minH_abs_dev_up = 0
    AVG_Dias_minH_abs_dev_down = 0
    AVG_Dias_maxF_abs_dev_up = 0
    AVG_Dias_maxF_abs_dev_down = 0
    AVG_Dias_Precision_up = 0
    AVG_Dias_Precision_down = 0
    AVG_Dias_Recall_up = 0
    AVG_Dias_Recall_down = 0   
    
    for layer in layerList: 
        AVG_ART_minH_abs_dev_up += res_dict[layer]['ART_minH_abs_dev']
        AVG_ART_minH_abs_dev_down += res_dict[layer]['ART_TruePositiveNum']
        res_dict[layer]['ART_minH_abs_dev'] = res_dict[layer]['ART_minH_abs_dev']/res_dict[layer]['ART_TruePositiveNum']
        AVG_ART_maxF_abs_dev_up += res_dict[layer]['ART_maxF_abs_dev']
        AVG_ART_maxF_abs_dev_down += res_dict[layer]['ART_TruePositiveNum']
        res_dict[layer]['ART_maxF_abs_dev'] = res_dict[layer]['ART_maxF_abs_dev']/res_dict[layer]['ART_TruePositiveNum']
        AVG_ART_Precision_up += res_dict[layer]['ART_TruePositiveNum']
        AVG_ART_Precision_down += (res_dict[layer]['ART_TruePositiveNum'] + res_dict[layer]['ART_FalsePositiveNum'])
        res_dict[layer]['ART_Precision'] = res_dict[layer]['ART_TruePositiveNum']/(res_dict[layer]['ART_TruePositiveNum'] + res_dict[layer]['ART_FalsePositiveNum'])
        AVG_ART_Recall_up += res_dict[layer]['ART_TruePositiveNum']
        AVG_ART_Recall_down += (res_dict[layer]['ART_TruePositiveNum'] + res_dict[layer]['ART_FalseNegativeNum'])
        res_dict[layer]['ART_Recall'] = res_dict[layer]['ART_TruePositiveNum']/(res_dict[layer]['ART_TruePositiveNum'] + res_dict[layer]['ART_FalseNegativeNum'])

        AVG_Dias_minH_abs_dev_up += res_dict[layer]['Dias_minH_abs_dev']
        AVG_Dias_minH_abs_dev_down += res_dict[layer]['Dias_TruePositiveNum']
        res_dict[layer]['Dias_minH_abs_dev'] = res_dict[layer]['Dias_minH_abs_dev']/res_dict[layer]['Dias_TruePositiveNum']
        AVG_Dias_maxF_abs_dev_up += res_dict[layer]['Dias_maxF_abs_dev']
        AVG_Dias_maxF_abs_dev_down += res_dict[layer]['Dias_TruePositiveNum']
        res_dict[layer]['Dias_maxF_abs_dev'] = res_dict[layer]['Dias_maxF_abs_dev']/res_dict[layer]['Dias_TruePositiveNum']
        AVG_Dias_Precision_up += res_dict[layer]['Dias_TruePositiveNum']
        AVG_Dias_Precision_down += res_dict[layer]['Dias_TruePositiveNum'] + res_dict[layer]['Dias_FalsePositiveNum']
        res_dict[layer]['Dias_Precision'] = res_dict[layer]['Dias_TruePositiveNum']/(res_dict[layer]['Dias_TruePositiveNum'] + res_dict[layer]['Dias_FalsePositiveNum'])
        AVG_Dias_Recall_up += res_dict[layer]['Dias_TruePositiveNum']
        AVG_Dias_Recall_down += res_dict[layer]['Dias_TruePositiveNum'] + res_dict[layer]['Dias_FalseNegativeNum']
        res_dict[layer]['Dias_Recall'] = res_dict[layer]['Dias_TruePositiveNum']/(res_dict[layer]['Dias_TruePositiveNum'] + res_dict[layer]['Dias_FalseNegativeNum'])
    
    res_dict['AVG_ART_minH_abs_dev'] = AVG_ART_minH_abs_dev_up/AVG_ART_minH_abs_dev_down
    res_dict['AVG_ART_maxF_abs_dev'] = AVG_ART_maxF_abs_dev_up/AVG_ART_maxF_abs_dev_down
    res_dict['AVG_ART_Precision'] = AVG_ART_Precision_up/AVG_ART_Precision_down
    res_dict['AVG_ART_Recall'] = AVG_ART_Recall_up/AVG_ART_Recall_down

    res_dict['AVG_Dias_minH_abs_dev'] = AVG_Dias_minH_abs_dev_up/AVG_Dias_minH_abs_dev_down
    res_dict['AVG_Dias_maxF_abs_dev'] = AVG_Dias_maxF_abs_dev_up/AVG_Dias_maxF_abs_dev_down
    res_dict['AVG_Dias_Precision'] = AVG_Dias_Precision_up/AVG_Dias_Precision_down
    res_dict['AVG_Dias_Recall'] = AVG_Dias_Recall_up/AVG_Dias_Recall_down

    for layerKey in res_dict.keys():
        if 'AVG' in layerKey:
            print('AVG  {:}:   {:.4f}'.format(layerKey,res_dict[layerKey]))
        else:
            for key in res_dict[layerKey].keys():
                if 'Dias' in key:
                    print('Layer {:}   {:}:   {:.4f}'.format(layerKey, key,res_dict[layerKey][key]))
    
    return res_dict

if __name__ == '__main__':
    res_mat = np.load('./test.npy')
    res = calculate_params(res_mat)