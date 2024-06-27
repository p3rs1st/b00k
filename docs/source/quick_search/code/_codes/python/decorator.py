import functools


def decorator_noargs(func):
    """无参数装饰器"""

    @functools.wraps  # 保留原有函数的函数名等函数属性
    def wrapper(*args, **kwargs):
        print("before func")
        ret = func(*args, **kwargs)
        print("after func")
        return ret

    return wrapper


@decorator_noargs
def decorator_noargs_test():
    print("do something")


def decorator_args(arg0, arg1):
    """有参数装饰器"""

    def decorator(func):
        @functools.wraps
        def wrapper(*args, **kwargs):
            print("before func", arg0, arg1)
            ret = func(*args, **kwargs)
            print("after func", arg0, arg1)
            return ret

        return wrapper

    return decorator
