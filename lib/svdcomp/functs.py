#lib/functs.py
import numpy as np
import matplotlib.pyplot as plt

def crapper(x,y,z):
        plt.plot(x)
        plt.plot(y)
        plt.plot(z)
        plt.ylabel('some numbers')
        plt.show()

def svdcmp(x):
    return f'{np.linalg.svd(np.array(x))}'
    #return np.linalg.svd(np.array(x))

def fluffer(x):
    plt.plot(x)
    plt.ylabel('some numbers')
    plt.show()

def poop(x):
    return f'pooper{x}'
