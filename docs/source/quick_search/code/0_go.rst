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

Commands
::::::::

.. code-block:: go
    :caption: command示例

    /*
    Gofmt formats Go programs.

    *Description xxx*.

    Usage:

        gofmt [flags] [path ...]

    The flags are:

        -d
            *xxx*
        -w
            *xxx*

    *extra description*
    */
    package main

- ``补充`` : 缩进行会被视为预格式化文本

Types
:::::

.. code-block:: go
    :caption: type示例

    // *description of type*
    type Type struct {
        // *description of exported_field*
        ExportedField int
        ExportedField1 int // *description of exported_field can be written in line*
    }

- ``补充`` :

  - 一般类型仅被视为仅在一个协程中使用，如果支持多协程需要声明
  - 特殊意义的零值需要被说明

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
    // *Func do xxx*
    func Func(a int, b string) ([]byte, error)

- ``补充`` :

  - 注释中不要描述函数的具体实现方式，不利于替换内部实现
  - 注释要说明函数返回的内容、调用的副作用、调用的作用
  - 注释在引用参数和结果的时候不要在名称加上特殊语法如引号

Consts & Vars
:::::::::::::

常量与变量注释格式一致

.. code-block:: go
    :caption: const/var统一注释示例

    // *The meaning of constant*
    const (
        EOF = -(iota + 1)
        Ident
    )

.. code-block:: go
    :caption: const/var详细注释示例

    const (
        EOF = -(iota + 1) // *comment for constant EOF*
        Ident             // *comment for constant Ident*
    )

语法
::::

gofmt会对部分格式重排，并且会忽略 ``//go:`` 这样的指令

- ``段落`` : 一段无缩进无空行的多行，两个连续反引号 `````` 会被转义为中文左双引号 ``”``，两个连续单引号 ``''`` 会被转移为中文右双引号 ``”``
- ``标题`` : 用井号 ``#`` 加空格的格式表示，前后需要有空行
- ``链接`` : 将格式为 ``[文本]: http://xx`` 放在注释最后，在需要引用的时候使用 ``[文本]`` 的格式引用
- ``文档链接`` : 格式为 ``[pkg.name]``
- ``列表`` : 缩进 + 列表符号(``*,+,-,•`` 或数字)
- ``代码块`` : 缩进的多行文本
