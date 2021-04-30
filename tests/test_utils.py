import pytest
import os
import pandas as pd
from pandas.util.testing import assert_frame_equal
from nanoml.config import CONFIG
from nanoml.utils.data_io import save_train_data

@pytest.fixture(scope='session')
def temp_dir(tmpdir_factory):
    temp_dir = tmpdir_factory.mktemp('temp_dir')
    return temp_dir

@pytest.fixture(scope='session')
def my_mock_data(temp_dir):
    data = pd.DataFrame({'id': [1, 2],
                         'value': [100, 200]
                        })
    filepath = temp_dir.join('mock_data.parquet')
    data.to_parquet(filepath)

def test_mock_data(temp_dir, my_mock_data, monkeypatch):
    # pytest.set_trace() # use pdb debug
    monkeypatch.setattr(CONFIG.path, 'train_path', str(temp_dir))
    df = pd.read_parquet(temp_dir.join('mock_data.parquet'))
    save_train_data(df, 'train.parquet')

    expected_df = pd.DataFrame({'id': [1, 2],
                         'value': [100, 200]
                        })
    saved_df = pd.read_parquet(os.path.join(CONFIG.path.train_path, 'train.parquet'))
    assert_frame_equal(saved_df, expected_df)





class TestClass:
    @property
    def test_args(self):
        args = {}
        args['arg1'] = 'arg1'
        args['arg2'] = 'arg2'
        return args

    def test_set_comparison(self):
        set1 = set("1308")
        set2 = set("8031")
        assert set1 == set2

    def add(self, a, b):
        res = a+b
        return res

    def test_add(self):
        assert self.add(1, 3) == 4