import os
import pandas as pd
import numpy as np
from sklearn import pipeline

from sklearn.base import TransformerMixin
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.feature_extraction import DictVectorizer
from sklearn.feature_extraction.text import CountVectorizer


class DataPipeline:
    def __init__(self, data):
        self.data = data
        self.pipeline = None

    def create_pipeline(self, continuous_cols=None, categorical_cols=None):
        column_types = self.get_column_types
        continuous_cols = continuous_cols or column_types['continuous']
        categorical_cols = categorical_cols or column_types['categorical']

        self.pipeline = UpdatedPipeline([
            ('features', FeatureUnion([ 
                ('continuous', UpdatedPipeline([
                    ('subset', SubsetExtractor(continuous_cols)),
                    ('values', ValueExtractor())
                ])),
                ('categorical', UpdatedPipeline([
                    ('subset', SubsetExtractor(categorical_cols)),
                    ('encode', DictVectorizerTransformer())
                ])) 
            ]))
        ])

        return self.pipeline

    @property
    def get_column_types(self):
        categorical_cols = []
        continuous_cols = []

        for col in self.data.columns.tolist():
            if col in self.data.select_dtypes(include=['number']).columns.tolist():
                continuous_cols.append(col)
            elif col in self.data.select_dtypes(include=[object]).columns.tolist():
                categorical_cols.append(col)
        return {'categorical': categorical_cols,
                'continuous':continuous_cols}


class UpdatedPipeline(Pipeline):
    """
    update sklean Pipeline to extract feature names
    """
    def extract_feature_names(self):
        return self.steps[-1][1].get_feature_names()


class DictVectorizerTransformer(TransformerMixin):
    """
    Apply DictVectorizer
    """
    def __init__(self):
        self.dict_vect = None

    def df_to_dict(self, X):
        return X.to_dict(orient='records')

    def transform(self, X):
        return self.dict_vect.transform(self.df_to_dict(X))

    def fit(self, X, y=None):
        self.dict_vect = DictVectorizer()
        self.dict_vect.fit(self.df_to_dict(X))
        return self

    def get_feature_names(self):
        return self.dict_vect.feature_names_


class SubsetExtractor(TransformerMixin):
    """
    Extract subset of columns
    """
    def __init__(self, columns):
        self.columns = columns

    def transform(self, X):
        return X[self.columns]

    def fit(self, X, y=None):
        return self 

    def get_feature_names(self):
        return self.columns


class ValueExtractor(TransformerMixin):
    """
    Extract values
    """
    def __init__(self):
        self.feature_names = None

    def transform(self, X):
        self.feature_names = X.columns.tolist()
        return X.values

    def fit(self, X, y=None):
        return self 

    def get_feature_names(self):
        return self.feature_names
