conda env create -f setup/environment.yml
source activate nanoml

pip install ipykernel
python -m ipykernel install --user --name nanoml --display-name "Python nanoml"