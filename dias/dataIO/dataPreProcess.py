import numpy as np

def refine_gt(mask):
    """
    make groundturth continuous
    """
    for cdx in range(3):
        E_index = np.where(mask[:,:,cdx] > 0)
        if len(E_index) > 0:
            inds = E_index[1].argsort()
            E_1 = E_index[0][inds]
            E_2 = E_index[1][inds]
            
            for idx in range(len(E_index[0])-1):
                dx = E_1[idx+1] - E_1[idx]
                dy = E_2[idx+1] - E_2[idx]

                if dx == 0:
                    if dy >0:
                        mask[E_1[idx],E_2[idx]:E_2[idx+1],cdx] = 1
                    else:
                        mask[E_1[idx],E_2[idx+1]:E_2[idx],cdx] = 1
                elif dy == 0:
                    mask[E_1[idx]:E_1[idx+1],E_2[idx],cdx] = 1
                else:
                    k = dy/dx
                    for jdx in range(dx):
                        mask[E_1[idx]+jdx,int(k*jdx)+E_2[idx],cdx] = 1
                    if dy > 0:
                        for jdx in range(dy):
                            mask[E_1[idx]+int(jdx*(dy/k)),E_2[idx]+jdx,cdx] = 1
                    else:
                        for jdx in range(int(-1.0*dy)):
                            mask[E_1[idx]+int(jdx*(dy/k)),E_2[idx]-jdx,cdx] = 1
        
    return mask