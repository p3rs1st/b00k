Go
==

官方规范
--------

以下内容根据 `<https://golang.google.cn/doc/effective_go>`__ 撰写

文档注释 (Doc Comments)
```````````````````````

文档注释是位于package、const、func、type、var的定义上方的注释，大写开头的名称需要有文档注释（因为向外导出）

下一级标题的顺序与 `官方文档 <https://golang.google.cn/doc/comment>`__ 顺序一致

**相关工具**

- ``go/doc`` 和 ``go/doc/comment`` 实现了从go代码中提取文档的能力
- ``golang.org/x/pkgsite/cmd/pkgsite`` 支持本地网页渲染文档
- ``gopls`` 支持在IDE中展示文档

Packages
::::::::

.. code-block:: go
    :caption: package示例

    // Package pkg implements *xxx*.
    //
    // *Here is description*
    package pkg

- ``位置`` : 如果package下只有一个文件则写在该文件下，如果package下有多个文件则写在单独的文件 ``doc.go``
- ``补充`` : 文档仅识别从 ``Package`` 开始的部分

Funcs
:::::

.. code-block:: go
    :caption: func返回boolean示例

    // Func reports whether *xxx*
    func Func() bool

.. code-block:: go
    :caption: func示例

    // Func return *xxx*
    //
    // Func do *xxx*
    func Func(a int, b string) ([]byte, error)

- ``补充`` :

  - 注释中不要描述函数的具体实现方式，不利于替换内部实现
  - 注释要说明函数返回的内容、调用的副作用、调用的作用
  - 注释在引用参数和结果的时候不要在名称加上特殊语法如引号
