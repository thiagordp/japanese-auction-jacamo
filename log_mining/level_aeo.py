from os import listdir
from os.path import isfile, join

import pandas as pd
import matplotlib.pyplot as plt

PATH_ROOT = "log/"
PATH_LEVEL_AEO = "level_aeo/"
PATH_IMG = "img/"


def log_level_aeo():
    print("Level AEO")
