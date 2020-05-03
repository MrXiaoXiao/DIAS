import numpy as np

def get_minH_maxF(mask, th=0.3):
    """Calculate minH and maxF from mask
    """
    # mask [W * H * CH]
    if len(np.shape(mask)) == 4:
        mask = mask[0,:,:,:]
    res = np.zeros([3,2])
    for idx in range(3):
        maxF = 0
        minH = 9999
        t_mat = mask[:,:,idx]
        
        if len(t_mat[t_mat>th])<2:
            res[idx,0] = minH
            res[idx,1] = maxF
            continue

        for jdx in range(np.shape(mask)[1]):
            if np.max(mask[:,jdx,idx]) < th:
                continue
            t_minH = np.argmax(mask[:,jdx,idx])
            t_maxF = jdx
            if t_minH < minH:
                minH = t_minH
            if t_maxF > maxF:
                maxF = t_maxF
        res[idx,0] = minH
        res[idx,1] = maxF
    return res

def trans_mask_v2(mask, th = 0.3):
    """Transform mask to scaling results
    """
    mask_t = np.zeros_like(mask)
    for idx in range(np.shape(mask)[2]):
        e_tl = mask[0,:,idx,0]
        if np.max(e_tl) > th and np.max(mask[0,:,idx+1,0]) < th:
            e_tl[e_tl>th] = 1.0
            mask_t[0,np.max(np.argmax(e_tl)),idx,0] = 1
        elif np.max(e_tl) > th:
            mask_t[0,np.argmax(e_tl),idx,0] = 1
        
        f1_tl = mask[0,:,idx,1]
        if np.max(f1_tl) > th and np.max(mask[0,:,idx+1,1]) < th:
            f1_tl[f1_tl>th] = 1.0
            mask_t[0,np.max(np.argmax(f1_tl)),idx,1] = 1
        elif np.max(f1_tl) > th:
            mask_t[0,np.argmax(f1_tl),idx,1] = 1
            
        f2_tl = mask[0,:,idx,2]
        if np.max(f2_tl) > th and np.max(mask[0,:,idx+1,2]) < th:
            f2_tl[f2_tl>th] = 1.0
            mask_t[0,np.max(np.argmax(f2_tl)),idx,2] = 1
        elif np.max(f2_tl) > th:
            mask_t[0,np.argmax(f2_tl),idx,2] = 1
            
    return mask_t
