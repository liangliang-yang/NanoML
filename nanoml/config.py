import pkg_resources
import yaml
import logging
from box import Box 

def load_config_file(path):
    with open(path, 'r') as ymlfile:
        config = yaml.safe_load(ymlfile)
    return Box(config)

config_path = pkg_resources.resource_filename('nanoml', 'config/configs.yaml')

CONFIG = load_config_file(config_path)