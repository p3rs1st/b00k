杂记
====

topic
-----

ceph解压卡死
````````````

将ceph共享存储目录下的一个压缩文件解压到另一个目录时，会卡死，原因可能是文件解压后但是metadata信息还没有同步，
读取解压目录未能读取到压缩文件，从而反复解压，最终卡死。

git rebase
``````````

`git rebase -i HEAD~<n>`

编辑处理当前分支的最后n个commit

- squash: 合并commit，将除了第一个commit的pick，其他均改为squash，保存后处理第二个编辑文件，文件修改commit信息
- 修改commit内容: 将待修改的commit前面的pick改为reword，保存后编辑文件，修改commit信息

golang yaml多行字符串渲染
`````````````````````````

go中常使用的yaml包 ``gopkg.in/yaml.v3`` 在填入多行字符串时，如果希望在yaml中渲染出多行字符串而不是单行转义字符串，
则需要保证字符串的每一行尾没有空字符，行首不能有缩进字符

http post multipart/form-data
`````````````````````````````

在前端使用 ``fetch`` ``axios`` 发送 ``post`` 请求时，如果 ``Content-Type`` 为 ``multipart/form-data`` ，
则请求数据中的 ``text`` 类型字段的值如果包含 ``\n`` 将被替换为 ``\r\n`` ，目前已知处理办法是后端强制替换


linux环境变量控制文件
`````````````````````

- profile是交互式，登录进入时生效

    - ``/etc/profile``: 系统环境参数，所有用户有效
    - ``~/.bash_profile``: 针对用户的环境参数

- bashrc是交互式，非登录进入时也会生效，如 ``docker exec``

  - ``/etc/bashrc``: 系统bash环境设置，所有用户有效
  - ``~/.bashrc``: 针对用户的bash环境设置

nodejs在cicd中的镜像问题
````````````````````````

在cicd中使用node:18镜像进行npm操作可能会有以下报错，将镜像换成node:18-bullseye版本即可

.. code-block:: text
  :caption: 报错信息

  node[6]: ../src/node_platform.cc:68:std::unique_ptr<long unsigned int> node::WorkerThreadsTaskRunner::DelayedTaskScheduler::Start(): Assertion `(0) == (uv_thread_create(t.get(), start_thread, this))' failed.
    1: 0xb9c310 node::Abort() [node]
    2: 0xb9c38e  [node]
    3: 0xc0a49e  [node]
    4: 0xc0a581 node::NodePlatform::NodePlatform(int, v8::TracingController*, v8::PageAllocator*) [node]
    5: 0xb58233 node::InitializeOncePerProcess(std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > const&, node::ProcessFlags::Flags) [node]
    6: 0xb5888b node::Start(int, char**) [node]
    7: 0x7faa3c24b24a  [/lib/x86_64-linux-gnu/libc.so.6]
    8: 0x7faa3c24b305 __libc_start_main [/lib/x86_64-linux-gnu/libc.so.6]
    9: 0xad789e _start [node]
  Aborted (core dumped)


python3.12 pkg_resources
````````````````````````

用python3.12使用某些第三方库的时候会报错 ``No module named 'pkg_resources'.`` 解决方案为 ``pip insatll setuptools``


sso的跨域问题
`````````````

sso的一般流程为：

1. 应用前端访问应用后端，发现没有登录信息，跳转到单点登录前端
2. 成功输入账号密码后单点登录携带code信息跳转到重定向页面
3. 重定向页面解析code，并将code传给应用后端，应用使用code获取用户信息
4. 应用前端获取应用后端返回的用户信息，成功登录

一般sso与应用不同源，单点登录页面与应用前端页面存在跨域问题，不能使用后端接口返回单点登录地址302方式重定向，
只能让后端返回登录地址，前端通过修改 ``window.location.href`` 等方式重定向跳转到单点登录，
并设置 **回调地址为前端登录页面**，让单点登录成功后跳转到前端登录页面，
前端登录页面解析code并用code请求后端接口，后端接口使用code与sso通信获取信息

安装python注意事项
``````````````````

1. 源码安装时安装路径不能带有冒号

后端服务与后台任务
``````````````````

后端服务与后台服务分进程运行，方便分别更新以及防止相互干扰影响
