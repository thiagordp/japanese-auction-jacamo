"""
Log Processing
"""
import level_a, level_ae, level_aeo

PATH_ROOT = "log/"

PATH_LEVEL_A = "level_a/"
PATH_LEVEL_AE = "level_ae/"
PATH_LEVEL_AEO = "level_aeo/"
PATH_IMG = "img/"

if __name__ == "__main__":
    print("Log processing")
    level_a.log_level_a()
    level_ae.log_level_ae()
    level_aeo.log_level_aeo()
