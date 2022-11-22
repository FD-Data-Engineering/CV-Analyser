#!/usr/bin/env python3


####################################################
###### Import Data : FROM PDF to Delta-Lake   ######
####################################################
#####
####################################################

# Get data From Folder
#
from datetime import datetime

datepath=datetime.today().strftime('%Y-%m-%d')
pdf_daily_path ="/home/pkwame/Git/spark-on-kubernetes/jobs/job-dir/"+"data/raw_pdf/dt="+datepath+"/" 
#
json_daily_path="/home/pkwame/Git/spark-on-kubernetes/jobs/job-dir/"+"data/raw_json/dt="+datepath+"/"
delta_json_structure="/home/pkwame/Git/spark-on-kubernetes/jobs/job-dir/"+"data/delta/json-cv-pdf"



import numpy as np
import pandas as pd
#
import io
from pdfminer.converter import TextConverter
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfinterp import PDFResourceManager
from pdfminer.pdfpage import PDFPage
#
import json
import os
from lib.local_pdfminer.json_exporter import export_as_json
from lib.local_pdfminer.json_exporter import export_as_json_page_n
#
from lib.local_sh.functions import copy_raw_sh_to_local
from lib.local_sh.functions import copy_local_to_raw_sh
#
import os
pdf_files=[val for sublist in [[os.path.join(i[0], j) for j in i[2]] for i in os.walk(pdf_daily_path)] for val in sublist]
# Meta comment to ease selecting text
#
os.system('mkdir -p '+json_daily_path)
for i, pdf_file in enumerate(pdf_files):    
    json_path = json_daily_path+"extract-"+datepath+"-"+str(i)+".json"
    data_csv=export_as_json_page_n(pdf_file, json_path)
#

os.system('ls -listar'+json_daily_path)