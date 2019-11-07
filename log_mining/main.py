"""
Log Processing
"""
from os import listdir
from os.path import isfile, join

import pandas as pd

PATH_ROOT = "log/"

PATH_LOG_LEVEL_A = "level_a/"
PATH_LOG_LEVEL_AE = "level_ae/"
PATH_LOG_LEVEL_AEO = "level_aeo/"

path_list = [PATH_LOG_LEVEL_A, PATH_LOG_LEVEL_AE, PATH_LOG_LEVEL_AEO]


def crawling():
    log_df = pd.DataFrame(columns=["level", "n", "iteracoes"])
    index = 0

    for i in range(len(path_list)):
        path = path_list[i]
        dir_path = PATH_ROOT + path
        list_files = [file for file in listdir(dir_path) if isfile(join(dir_path, file))]

        print(path, ":\t", len(list_files))

        for file_name in list_files:
            n = int(file_name.replace("log_n_", "").replace(".txt", ""))
            str_n = file_name.replace(".txt", "").split(sep="_")
            print(str_n)

            n = int(str_n[2])
            exp = int(str_n[3])

            file_path = dir_path + file_name

            iteracoes = -1
            tempo_exe = -1.0
            list_desiste = []

            with open(file_path, "r", encoding="utf-8") as file:

                # Read file
                for line in file.readlines():
                    split_line = line.split()

                    # print(split_line)

                    if len(split_line) < 2:
                        continue

                    # Numero de iteracoes
                    if split_line[1].find("Iteracoes") != -1:
                        iteracoes = int(split_line[2])
                    # Tempo de Execucao
                    elif split_line[1].find("Elapsed") != -1:
                        tempo_exe = float(split_line[2])
                    # Numero de desistentes por iteracao
                    elif split_line[1].find("Disistentes") != -1:
                        desistentes = split_line[2].replace(",", " ").split()
                        num_desistentes = len(desistentes)
                        print(desistentes)
                        print(num_desistentes)
                        list_desiste.append(n - num_desistentes)

            print(n, exp, iteracoes, tempo_exe, list_desiste)


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
