import pandas as pd  
import os
from nanoml.config import CONFIG

def save_train_data(df, filename):
    path = CONFIG.path.train_path
    df.to_parquet(os.path.join(path, filename))