Go
==

官方规范
--------

以下内容根据 `<https://golang.google.cn/doc/effective_go>`__ 撰写

可参考的现有中文翻译版本 `<https://learnku.com/docs/effective-go/2020>`__

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

命名 (Name)
```````````

- 包名使用单个小写单词，不适用驼峰和下划线
- 类对某一属性attr的getter和setter的命名格式为 ``Attr()`` 和 ``SetAttr()``
- 只包含一个方法的接口使用 ``er`` 结尾命名
- 使用驼峰命名法组合多个单词

控制结构
````````

.. code-block:: go
    :caption: break出指定区域

    Loop:
        for i := 0; i <= 10; i++ {
            if i == 5 {
                break Loop
            }
        }

Defer
:::::

defer在函数退出时执行，传入的参数是运行到defer行的时候立刻计算，
defer执行顺序是声明顺序的反向

.. code-block:: go
    :caption: defer调用时机示例

    func trace(s string) string {
        fmt.Println("entering:", s)
        return s
    }

    func un(s string) {
        fmt.Println("leaving:", s)
    }

    func a() {
        defer un(trace("a"))
        fmt.Println("in a")
    }

    func b() {
        defer un(trace("b"))
        fmt.Println("in b")
        a()
    }

    func main() {
        b()
    }

    /*
    entering: b
    in b
    entering: a
    in a
    leaving: a
    leaving: b
    */

数据结构
````````

- ``new`` : 生成类型的指针，并且指向的地址是零值
- ``make`` : 生成类型的对象，类型支持切片、映射、管道
- ``数组`` : 数组是值，因此在传参的时候穿的是对所有元素的拷贝值
- ``Printing`` : ``%+v`` 打印出每个字段的名称， ``%#v`` 按go语法打印值， ``%x`` 打印十六进制， ``%T`` 打印值的类型

初始化
``````

每个源文件可以通过无参数的 ``init`` 函数进行初始化操作

空白标识符 _
````````````

1. 多重赋值时丢弃无关的值
2. 为附加作用导入，如 ``import _ "net/http/pprof"``

并发
````

goroutine(go协程)是与其他goroutine并发运行在同一地址空间的轻量级函数，消耗几乎只有栈空间的分配

信道是用于协程传递的共享值

.. code-block:: go
    :caption: 信道使用

    ci := make(chan int)            // 整数无缓冲信道，同步交换数据
    cj := make(chan int, 0)         // 整数无缓冲信道，同步交换数据
    cs := make(chan *os.File, 100)  // 指向文件的指针的缓冲信道，缓冲区满之前不会阻塞发送者

    // 阻塞接收者
    <- ci

    // 不阻塞接收者
    select {
        case <- ci: // 直接获取到信道时操作
        default: // 不阻塞时操作
    }

异常
````

.. code-block:: go
    :caption: panic & recover

    defer func() {
        if err := recover(); err != nil {
            fmt.Println(err)
        }
    }()

    panic(errors.New("some error"))
    // 如果panic(nil)，err也不会为空而是返回*runtime.PanicNilError
