import numpy as np
import pickle
from dias.dataIO.dataPreProcess import refine_gt

class IonoDataManager():
    def __init__(self, cfgs):
        """load train and test list
        """
        self.cfgs = cfgs
        self.base_path = cfgs['Data']['BasePath']
        train_list_file_path = self.base_path + cfgs['Data']['TrainListFile']
        t_file = open(train_list_file_path,'r')
        # default batch size = 1
        self.train_data_list = list()
        for line in t_file.readlines():
            self.train_data_list.append(line)
        t_file.close()

        self.test_data_list = list()
        test_list_file_path = self.base_path + cfgs['Data']['TestListFile']
        t_file = open(test_list_file_path,'r')
        for line in t_file.readlines():
            self.test_data_list.append(line)
        t_file.close()

        self.pad_height = int(cfgs['Data']['PadHeight'])
        self.pad_width = int(cfgs['Data']['PadWidth'])
        self.channel_num = int(cfgs['Data']['ChannelNum'])
        self.class_num = int(cfgs['Data']['ClassNum'])

    def get_train_batch(self):
        """get train batch
        """
        #print(len(self.train_data_list))
        rand_id = int(np.random.randint(low=0,high=len(self.train_data_list),size=1))
        x_train = np.zeros([1,self.pad_height,self.pad_height,self.channel_num])
        y_train = np.zeros([1,self.pad_height,self.pad_height,self.class_num])

        ori_x_name = self.base_path + self.train_data_list[rand_id].split(' ')[0] 
        ori_y_name = self.base_path + self.train_data_list[rand_id].split(' ')[1]

        t_file = open(ori_x_name,'rb')
        ori_x = pickle.load(t_file)
        t_file.close()
        t_file = open(ori_y_name,'rb')
        ori_y = pickle.load(t_file)
        t_file.close()

        ori_height = np.shape(ori_x)[0]
        ori_width = np.shape(ori_x)[1]
        x_train[0,:ori_height,:ori_width,0] = ori_x[:,:,0]/np.max(ori_x[:,:,0])
        x_train[0,:ori_height,:ori_width,1] = ori_x[:,:,1]/np.max(ori_x[:,:,1])
        x_train[0,:ori_height,:ori_width,2] = ori_x[:,:,2]/np.max(ori_x[:,:,2])
        y_train[0,:ori_height,:ori_width,:] = ori_y[:,:,:]/1.0
        y_train[0,:,:,:] = refine_gt(y_train[0,:,:,:])
        
        return x_train,y_train

    def get_test_batch(self, t_id):
        """get train batch
        """
        #print(len(self.train_data_list))
        #rand_id = int(np.random.randint(low=0,high=len(self.train_data_list),size=1))
        rand_id = t_id
        x_test= np.zeros([1,self.pad_height,self.pad_height,self.channel_num])
        y_test = np.zeros([1,self.pad_height,self.pad_height,self.class_num])
        art_test = np.zeros([1,self.pad_height,self.pad_height,self.class_num])

        ori_x_name = self.base_path + self.test_data_list[rand_id].split(' ')[0] 
        ori_y_name = self.base_path + self.test_data_list[rand_id].split(' ')[1]
        art_y_name = self.base_path + self.test_data_list[rand_id].split(' ')[2].rstrip()

        t_file = open(ori_x_name,'rb')
        ori_x = pickle.load(t_file)
        t_file.close()
        t_file = open(ori_y_name,'rb')
        ori_y = pickle.load(t_file)
        t_file.close()
        t_file = open(art_y_name,'rb')
        art_y = pickle.load(t_file)
        t_file.close()

        ori_height = np.shape(ori_x)[0]
        ori_width = np.shape(ori_x)[1]
        x_test[0,:ori_height,:ori_width,0] = ori_x[:,:,0]/np.max(ori_x[:,:,0])
        x_test[0,:ori_height,:ori_width,1] = ori_x[:,:,1]/np.max(ori_x[:,:,1])
        x_test[0,:ori_height,:ori_width,2] = ori_x[:,:,2]/np.max(ori_x[:,:,2])

        y_test[0,:ori_height,:ori_width,:] = ori_y[:,:,:]/1.0
        #y_test[0,:,:,:] = refine_gt(y_test[0,:,:,:])
        
        art_test[0,:ori_height,:ori_width,:] = art_y[:,:,:]/1.0
        #art_test[0,:,:,:] = refine_gt(art_test[0,:,:,:])

        return x_test, y_test, art_test

    def get_scale_only(self, id):
        """get train batch
        """
        #print(len(self.train_data_list))
        #rand_id = int(np.random.randint(low=0,high=len(self.train_data_list),size=1))
        rand_id = id
        x_test= np.zeros([1,self.pad_height,self.pad_height,self.channel_num])
        ori_x_name = self.base_path + self.test_data_list[rand_id].split(' ')[0][:-1] 

        t_file = open(ori_x_name,'rb')
        ori_x = pickle.load(t_file)
        t_file.close()

        ori_height = np.shape(ori_x)[0]
        ori_width = np.shape(ori_x)[1]
        x_test[0,:ori_height,:ori_width,0] = ori_x[:,:,0]/np.max(ori_x[:,:,0])
        x_test[0,:ori_height,:ori_width,1] = ori_x[:,:,1]/np.max(ori_x[:,:,1])
        x_test[0,:ori_height,:ori_width,2] = ori_x[:,:,2]/np.max(ori_x[:,:,2])

        return x_test


if __name__ == '__main__':
    import yaml
    cfgs = yaml.load(open('C:/Users/wangj/Documents/GitHub/SmartRadarAssistant/DIonoAutoScaler/example_config.yaml','r'), Loader=yaml.BaseLoader)
    dataManager = IonoDataManager(cfgs)
    
    x_train, y_train = dataManager.get_train_batch()

    import matplotlib.pyplot as plt
    plt.figure()
    plt.subplot(1,2,1)
    plt.imshow(x_train[0,:,:,:])
    plt.subplot(1,2,2)
    plt.imshow(y_train[0,:,:,:])
    plt.show()