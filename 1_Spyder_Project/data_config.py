import os
import pyodbc
import time
import datetime

# DB Setting
DRIVER_Q = '{SQL Server}'
SERVER_Q = 'localhost'
DATABASE_Q = 'myDB'
TRUSTED_Q = 'yes'
CSTR = f'DRIVER={DRIVER_Q};SERVER={SERVER_Q};DATABASE={DATABASE_Q};TRUSTED_CONNECTION={TRUSTED_Q}'
CONN = pyodbc.connect(CSTR)

FOLDER_NAME = 'Sector'
TB_NAME = 'Sector'

# CSV Folder
FOLDER_PATH = 'D:/Data/'