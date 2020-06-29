from data_config import *
from create_db import Create_DB
from query_db import Data_SRC
from time import time
import logging

logging.basicConfig(level = logging.DEBUG,filename = 'myLog.log',filemode = 'w'
                    ,format = '%(asctime)s %(levelname)s: %(message)s')

def main_create_db():
    start = time()
    logging.info('Start')
    try:
        Create_DB().Auto_Create()
    except Exception as e:
        print(e)
    finally:
        Create_DB().Insert_DB()
    end = time()
    proc_time = round(end - start)
    logging.info(f'Create DB end with processing time = {proc_time} secs')
    

def main_query_db():
    start = time()
    logging.info('Start')
    try:
        res = Data_SRC().Comb_Range()        
    except Exception as e:
        print(e)
    end = time()
    proc_time = round(end - start)
    logging.info(f'Query DB end with processing time = {proc_time} secs')
    return res
    
if __name__ == '__main__':
    #main_create_db()
    result = main_query_db()
    







