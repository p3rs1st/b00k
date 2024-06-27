代码编辑
========

Pre Commit
----------

git commit前进行的校验等工作，配置在本地

.. literalinclude:: _codes/code_edit/.pre-commit-config.python.yaml
    :caption: .pre-commit-config.yaml
    :language: yaml
    :linenos:

.. code:: sh

    # 保存配置文件后初始化pre-commit脚本
    pip install pre-commit
    pre-commit install

代码风格化
----------

Python
``````

.. literalinclude:: _codes/code_edit/python.pyproject.toml
    :caption: pyproject.toml
    :language: toml
    :linenos:

`black <https://black.readthedocs.io/en/stable/the_black_code_style/index.html>`__
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

基于PEP8编码规范的python代码风格化工具

`flake8 <https://flake8.pycqa.org/en/latest/>`__
::::::::::::::::::::::::::::::::::::::::::::::::

静态代码风格检查器，`flake8 code规则对应表 <https://www.flake8rules.com/>`__

`isort <https://pycqa.github.io/isort/>`__
::::::::::::::::::::::::::::::::::::::::::

格式化导入包

React
`````

安装: (阿里云流水线使用全局安装，局部安装会导致阿里云流水线失败，原因是阿里云node版本不够用)

.. code:: sh

    npm i -g eslint-config-ali @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-import eslint-import-resolver-typescript eslint-plugin-react eslint-plugin-react-hooks

查看文档: ``npx eslint -h``

添加到React项目中:

.. code-block:: bash

    vi .eslintrc.json

    # 编辑开始
    {
        "extends": [
            "eslint-config-ali/typescript/react"
        ]
    }
    # 编辑结束

