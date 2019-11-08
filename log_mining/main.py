"""
Log Processing
"""
import re
from os import listdir
from os.path import isfile, join

import pandas as pd
import matplotlib.pyplot as plt

PATH_ROOT = "log/"

PATH_LOG_LEVEL_A = "level_a/"
PATH_LOG_LEVEL_AE = "level_ae/"
PATH_LOG_LEVEL_AEO = "level_aeo/"
PATH_IMG = "img/"
path_list = [PATH_LOG_LEVEL_A, PATH_LOG_LEVEL_AE, PATH_LOG_LEVEL_AEO]


def crawling():
    log_df = pd.DataFrame(columns=["level", "n", "teste", "iter", "tempo_exe", "preco_final", "qtd_msg", "curv_desiste"])
    index = 0
    # [level, n, exp, iteracoes, tempo_exe, round(preco_final, 2), list_continua, qtd_msg]

    for i in range(len(path_list)):
        path = path_list[i]
        dir_path = PATH_ROOT + path
        list_files = [file for file in listdir(dir_path) if isfile(join(dir_path, file))]

        print("-----------------------------------------")
        print(path, ":\t", len(list_files))
        m = 0
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
            list_continua = [n]
            preco_final = -1.0
            qtd_msg = 0

            with open(file_path, "r", encoding="utf-8") as file:

                # Read file
                for line in file.readlines():
                    split_line = line.split()

                    if len(split_line) < 2:
                        continue

                    # Numero de iteracoes
                    if split_line[1].find("Iteracoes") != -1:
                        iteracoes = int(split_line[2])
                    # Tempo de Execucao
                    elif split_line[1].find("Elapsed") != -1:
                        tempo_exe = float(split_line[2])
                    # Numero de desistentes por iteracao
                    elif split_line[1].find("Presentes") != -1:
                        str_desist = split_line[2].replace(",", " ").replace("[", " ").replace("]", " ").split()
                        set_desistentes = list(set(str_desist))

                        num_desistentes = len(set_desistentes)
                        list_continua.append(num_desistentes)

                    elif split_line[1].find("Vencedor") != -1:
                        preco_final = float(split_line[7])

                    elif split_line[1].find("Broadcast") != -1:
                        qtd_msg += n
                    elif split_line[1].find("Tell") != -1:
                        qtd_msg += 1

            level = path.replace("/", "").replace("level_", "")
            print(level, n, exp, iteracoes, tempo_exe, round(preco_final, 2), qtd_msg, list_continua, "\n")

            # Inclusão no Dataframe
            arr = [level, n, exp, iteracoes, tempo_exe, round(preco_final, 2), qtd_msg, list_continua]
            log_df.loc[len(log_df)] = arr

            plt.xlabel("Iteração")
            plt.ylabel("Compradores")
            plt.plot(list_continua)
            fig_name = PATH_IMG + file_name.replace(".txt", ".png")
            plt.savefig(fig_name)

        plt.close()

    log_df.to_csv("log.csv")


def log_level_a():
    print("Level A")

    # Abrir arquivos do diretório

    # Para cada arquivo

    #     Encontrar o número de iterações

    #     Curva de Desistência

    #     Tempo de Execução

    # Preço final


if __name__ == "__main__":
    print("Log processing")
    crawling()
