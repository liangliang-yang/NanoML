import pytest
import pandas as pd
from pandas.util.testing import assert_frame_equal

@pytest.fixture(scope='session')
def temp_dir(tmpdir_factory):
    temp_dir = tmpdir_factory.mktemp('temp_dir')
    return temp_dir


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