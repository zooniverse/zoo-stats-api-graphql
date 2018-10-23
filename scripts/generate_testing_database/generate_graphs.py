# Import modules
import os
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

directory_in_str = '/Users/samuelaroney/Code/zoo_stats_api_prototype/testing_results/'
directory = os.fsencode(directory_in_str)

for file in os.listdir(directory):
    filename = os.fsdecode(file)
    if filename.endswith(".csv"):
        file_directory = os.path.join(directory_in_str, filename)
        root_name = filename[:-4]
        df = pd.read_csv(file_directory)
        ax = plt.figure(root_name)
        sns.scatterplot(x = "database_size", y = "cold", data=df)
        plt.savefig(os.path.join(directory_in_str, root_name + '-cold.png'))
        plt.show()