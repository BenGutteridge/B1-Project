import numpy as np
torf = []
# A script to check the correctness of outputs from the B1
with open('groundtruth.txt', 'r') as groundtruth:
    lines = groundtruth.readlines()
    for line in lines:
        if line == 'Property is true (no counter-example exists)\n':
            torf.append(1)
        elif line == 'Property is false (counter-examples exist)\n':
            torf.append(0) 
        else:
            print('error')
    
