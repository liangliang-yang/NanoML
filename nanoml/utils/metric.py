import os
import pandas as pd
import numpy as np
from sklearn.metrics import roc_curve, auc

import logging
logger = logging.getLogger(__name__)

def auc_roc(y, y_pred):
    """Compute the roc score

    Parameters
    ----------

    y: numpy array or DataFrame
        true labels

    y_pred: numpy.....
        predicted values

    Return
    ------
    auc score
    """
    fpr, tpr, thresholds = roc_curve(y, y_pred)
    return auc(fpr, tpr)