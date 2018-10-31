# Import modules
import os
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

current = os.getcwd()
directory_in_str = current + '/testing_results/'
directory = os.fsencode(directory_in_str)

def fx(x):
    if x == "cold":
        return 'cold'
    else:
        return 'other'

for file in os.listdir(directory):
    filename = os.fsdecode(file)
    if filename.endswith(".csv"):
        file_directory = os.path.join(directory_in_str, filename)
        root_name = filename[:-4]

        df_comb = pd.read_csv(file_directory)
        ax = plt.figure(root_name)
        fig = sns.lineplot(x = "database_size", y = "time", hue = "cold", ci='sd', data=df_comb)
        plt.setp(fig, xlabel="Size of database", ylabel="Running time (s)")
        plt.xscale('log')
        
        axes = plt.gca()
        axes.set_ylim([0, None])

        plt.savefig(os.path.join(directory_in_str, root_name + '.png'))

plt.show()