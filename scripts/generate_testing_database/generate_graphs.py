# Import modules
import os
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

directory_in_str = '/Users/samuelaroney/Code/zoo_stats_api_prototype/testing_results/'
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

        df_comb = pd.read_csv(file_directory, index_col=0)
        df_comb = df_comb.T.stack()
        df_comb.name = 'comb'
        df_comb.index.rename(["iterations", "database_size"], inplace=True)
        df_comb = df_comb.reset_index()
        df_comb["iteration"] = np.vectorize(fx)(df_comb["iterations"])
        ax = plt.figure(root_name)
        fig = sns.lineplot(x = "database_size", y = "comb", hue = "iteration", ci='sd', data=df_comb)
        plt.setp(fig, xlabel="Size of database", ylabel="Running time (s)")
        plt.xscale('log')
        
        axes = plt.gca()
        axes.set_ylim([0, None])

        plt.savefig(os.path.join(directory_in_str, root_name + '.png'))
        plt.show()