
import string
import os
import random
import json
from typing import Dict


def crypt(fileName):
    if os.path.exists(f"{fileName}"):
        crypted_chars = ...
        SfileName = fileName.split(".")[0]
        if not os.path.exists(f'{SfileName}.crypt'):
            with open(f"{SfileName}.crypt", "w") as file:
                spe_chars = "áàãăâéèêiíìĩóòõôơúùũyýỳđ"
                chars = string.printable + spe_chars + spe_chars.upper()
                crypted_chars = {}
                for char in chars:
                    random_crypt_num = None
                    canPass = False
                    while not canPass:
                        random_crypt_num = random.randint(0, 10000000)
                        if random_crypt_num in crypted_chars:
                            random_crypt_num = random.randint(0, 10000000)
                        else:
                            crypted_chars[random_crypt_num] = char
                            canPass = True
                crypted_chars["extension"] = fileName.split('.')[1]
                json.dump(crypted_chars, file)
        else:
            with open(f"{SfileName}.crypt", "r") as file:
                crypted_chars = json.load(file)

        readed_lines = ...
        with open(f"{fileName}", "r") as file:
            readed_lines = file.readlines()

        with open(f"{SfileName}.crypted", "a+") as file:
            index = 0
            for word in readed_lines:
                for char in word:
                    keys = ...
                    try:
                        keys = [k for k, v in crypted_chars.items() if v == char][0]
                    except:
                        keys = [k for k, v in crypted_chars.items() if v == " "][0]
                    file.write(str(keys) if index == 0 else f".{keys}")
                    index += 1
        os.remove(fileName)
        print(f"{fileName} crypted successfully !")
    else:
        print(f"Couldn't find {fileName}")


def decrypt(fileName):
    SfileName = fileName.split(".")
    if SfileName[1] != "crypted":
        print("The file is corrupted !")
        return
    if os.path.exists(f"{SfileName[0]}.crypt"):
        crypted_chars = ...
        crypted_file = ...
        with open(f"{SfileName[0]}.crypt", "r") as file:
            crypted_chars = json.load(file)
        with open(f"{SfileName[0]}.crypted") as file:
            crypted_file = file.readlines()
        with open(f"{SfileName[0]}.{crypted_chars['extension']}", "a+") as file:
            for index in crypted_file[0].split("."):
                if index == "extension" : continue
                file.write(crypted_chars[index])
        print('The file was decrypted succesfully ;)')
    else:
        print(f"Couldn't decrypt the file, because {SfileName[0]}.crypt can't be found !")

shouldDecrypt = int(input("[Crypt: 1, Decrypt: 2]> "))
filename = input("[filename]> " if shouldDecrypt == 1 else "[filename.crypted]> ")

if shouldDecrypt == 1:
    crypt(filename)
else:
    decrypt(filename)
