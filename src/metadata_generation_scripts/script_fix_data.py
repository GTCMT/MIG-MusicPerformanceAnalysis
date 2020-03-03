## Script to create individual folders for all .mp3 files within a directory and place those inside the
## respective folders

import os
import sys
from glob import glob
import shutil
from tqdm import tqdm

# specify input directory. this NEEDS to be changed based on the system
if len(sys.argv) == 1:
    input_directory = "/media/SSD/FBA/2017-2018"
else:
    input_directory = str(sys.argv)


list_mp3 = glob(os.path.join(input_directory, "*.mp3"))

for file in tqdm(list_mp3):
    sid = os.path.splitext(os.path.basename(file))[0]
    s_folder = os.path.join(input_directory, sid)
    if not os.path.exists(s_folder):
        os.mkdir(s_folder)
    shutil.move(file, s_folder)

