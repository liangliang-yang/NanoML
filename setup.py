import os
import nanoml

from setuptools import setup, find_packages
from codecs import open

here = os.path.abspath(os.path.dirname(__file__))

# get the dependencies and installs
with open(os.path.join(here, 'requirements.txt'), encoding='utf-8') as f:
    all_reqs = f.read().split('\n')

install_requires = [x.strip() for x in all_reqs if 'git+' not in x]
dependency_links = [x.strip().replace('git+', '') for x in all_reqs if x.startswith('git+')]

setup(
        name='nanoml',
        version=nanoml.__version__,
        packages=find_packages(),
        author='Liangliang Yang',
        author_email='liangliangyang1989@gmail.com',
        install_requires=['numpy', 'pandas'],
)
