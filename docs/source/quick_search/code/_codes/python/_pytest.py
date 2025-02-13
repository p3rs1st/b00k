import pytest

"""main.py"""


def f():
    return 1


class G:
    @staticmethod
    def G1():
        return 2


"""conftest.py"""


@pytest.fixture(scope="session")
def fixture0():
    # scope取不同值范围不同
    # session表示全局相同, 即全局仅执行一次
    """生成fixture"""
    _fixture0 = object()
    yield _fixture0
    """fixture后处理"""


@pytest.fixture(autouse=True)
def fixture1():
    # 自动执行, 即使不声明也会执行
    """前处理"""
    yield
    """后处理"""


"""test_xxx.py"""


def test_0(fixture0):
    pass


# pip install pytest-order
# index越小越先执行
@pytest.mark.order(index=1)  # mypy: ignore
class TestXXX:
    def test_1(mocker, fixture1):
        mocker.patch("G.G1", return_value=0)
        # 注意mocker使用的时候在不清楚的情况下尽量对类下的方法进行mock
        # 如果直接mock的module下的函数可能会出现mock失败的问题
        # 具体情况如下，assert代表最终出现的情况

        # """a.py"""
        # def a():
        #     return 1

        # """b.py"""
        # def b():
        #     from a import a
        #     return a()

        # """test_xxx.py"""
        # def test_mock(mocker):
        #     mocker.patch("a.a", return_value=0)
        #     from a import a
        #     assert a() == 1
        #     from b import b
        #     assert b() == 0
        #     import a as ia
        #     assert ia.a() == 0

        assert G.G1() == 0
