代码编辑
========

Pre Commit
----------

git commit前进行的校验等工作

安装
````

.. code:: sh

    pip install pre-commit
    pre-commit install

配置文件.pre-commit-config.yaml
```````````````````````````````

.. literalinclude:: _codes/code_edit/.pre-commit-config.python.yaml
    :caption: python开发配置
    :linenos:

代码风格化
----------

Python
``````

black
:::::

基于PEP8编码规范的python代码风格化工具，具有少量的配置项

flake8
::::::

静态代码风格检查器

React
`````

安装: (阿里云流水线使用全局安装，局部安装会导致阿里云流水线失败，原因是阿里云node版本不够用)

.. code:: sh

    npm i -g eslint-config-ali @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-import eslint-import-resolver-typescript eslint-plugin-react eslint-plugin-react-hooks

查看文档: ``npx eslint -h``

添加到React项目中:

.. code-block:: sh

    vi .eslintrc.json

    # 编辑开始
    {
        "extends": [
            "eslint-config-ali/typescript/react"
        ]
    }
    # 编辑结束

