from os import listdir
from os.path import isfile, join

import pandas as pd
import matplotlib.pyplot as plt

PATH_ROOT = "log/"
PATH_LEVEL_AE = "level_ae/"
PATH_IMG = "img/"


def log_level_ae():
    print("-----------------------------------------")
    print("Level AE")

    index = 0
    # [level, n, exp, iteracoes, tempo_exe, round(preco_final, 2), list_continua, qtd_msg]

    dir_path = PATH_ROOT + PATH_LEVEL_AE
    list_files = [file for file in listdir(dir_path) if isfile(join(dir_path, file))]

    m = 0

    plt.rcParams["figure.figsize"] = (10, 5)

    for file_name in list_files:
        n = int(file_name.replace("log_n_", "").replace(".txt", ""))
        str_n = file_name.replace(".txt", "").split(sep="_")
        print(file_name)

        n = int(str_n[2])
        exp = int(str_n[3])

        if m != n:
            m = n
            plt.close()

        file_path = dir_path + file_name

        iteracoes = -1
        tempo_exe = -1.0
        list_continua = []
        preco_final = -1.0
        qtd_msg = 0

        with open(file_path, "r", encoding="utf-8") as file:

            # Read file
            for line in file.readlines():
                split_line = line.split()

                if len(split_line) < 2:
                    continue

                # Numero de desistentes por iteracao
                elif split_line[1].find("Presentes") != -1:
                    num_desistentes = int(split_line[2])
                    list_continua.append(num_desistentes)

                elif split_line[1].find("Vencedor") != -1:
                    preco_final = float(split_line[7])

                elif split_line[1].find("Broadcast") != -1:
                    qtd_msg += n
                elif split_line[1].find("Tell") != -1:
                    qtd_msg += 1

        level = PATH_LEVEL_AE.replace("/", "").replace("level_", "")
        print(level, n, exp, iteracoes, tempo_exe, round(preco_final, 2), qtd_msg, list_continua, "\n")

        plt.xlabel("Iteração")
        plt.ylabel("Compradores")

        plt.plot(list_continua, linewidth=3)
        fig_name = PATH_IMG + PATH_LEVEL_AE + file_name.replace(".txt", ".png")
        plt.savefig(fig_name)

    plt.close()
