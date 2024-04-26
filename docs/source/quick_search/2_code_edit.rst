代码编辑
========

代码风格化
----------

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

