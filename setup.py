import os
from setuptools import setup, find_packages
import nanoml

setup(
        name='Nano Machine Learning',
        version=nanoml.__version__,
        packages=find_packages(),
        author='Liangliang Yang',
        author_email='liangliangyang1989@gmail.com',
        install_requires=['numpy', 'pandas'],
)
