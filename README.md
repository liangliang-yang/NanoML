# Machine Learning Web Platform

## Overview
Machine Learning Web Platform


## Install the conda environment
Run the below command
```
source setup/setup.sh
```

In order to use the package, run
``` 
pip install -e .
```

```
# List all kernels and grap the name of the kernel you want to remove
jupyter kernelspec list
# Remove it
jupyter kernelspec remove <kernel_name>

source activate myenv
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

```
# remove conda env
conda env remove --name nanoml
```
