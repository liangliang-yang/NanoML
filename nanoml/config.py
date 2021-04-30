import pkg_resources
import yaml
import logging
from box import Box 
CONFIG = None

logger = logging.getLogger(__name__)

def load_config_file(path=None):
    logger.info('load config file')

    global CONFIG

    if not path:
        path = pkg_resources.resource_filename('nanoml', 'config/configs.yaml')
    with open(path, 'r') as ymlfile:
        configs = yaml.safe_load(ymlfile)
    CONFIG = Box(configs)

# config_path = pkg_resources.resource_filename('nanoml', 'config/configs.yaml')
# CONFIG = load_config_file(config_path)

def read_config_file(path=None):
    logger.info('read config file')
    if not path:
        path = pkg_resources.resource_filename('nanoml', 'config/configs.yaml')
    
    configs = {}
    with open(path) as f:
        contents = f.read()
        configs = yaml.full_load(contents)
    
    return configs