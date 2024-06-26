网络
====

DNS
---

简介
````

-  将域名翻译为IP地址
-  域名由字母, 数字, 连接符组成, 由点号分割, 从左往右域名级别下降

   -  ``根域名``: 空, 即没有限制
   -  ``顶级域名``: 通用域名(com, net, org), 国家域名(nz, us)
   -  ``二级域名``: 顶级域名的下一级域名

-  基于UDP实现, 端口53

域名服务器
``````````

-  ``根域名服务器``: 最高层次, 知道所有的顶级域名服务器,
   能够告知域名对应的顶级域名服务器
-  ``顶级域名服务器``: 管理在该服务器下注册的所有二级域名
-  ``权限域名服务器``: 每台主机在域名权限服务器登记,
   能将在旗下注册的主机名转为IP
-  ``本地域名服务器``: 主机最先发送DNS请求给的服务器

DNS解析过程
```````````

本地HOST文件 → 本地域名服务器的缓存 → 根域名服务器 → 顶级域名服务器 →
下级服务器

-  ``递归查询``: 本地域名服务器接收到主机的DNS请求后代替完成DNS查询
-  ``迭代查询``:
   根域名服务器接收到本地域名服务器的DNS请求后返回能完成当前DNS请求的服务器地址

DNS安全
```````

-  ``DNS劫持``: 劫持DNS服务器, 获得某域名的解析记录控制权, 修改解析结果
-  ``DNS污染``: 入侵检测UDP53端口, 发现匹配DNS查询后,
   篡改DNS查询返回记录

HTTP
----

报文结构
````````

**请求报文**:

-  ``请求行``: 请求方法, URL, 协议版本
-  ``请求头部``: (一行一对)头部字段名-值
-  ``空行``
-  ``请求包体``: 用于POST

**响应报文**:

-  ``状态行``: 协议版本, 状态码, 状态码描述
-  ``响应头部``: (一行一对)头部字段名-值
-  ``空行``
-  ``响应包体``: 响应内容

通信数据转发
````````````

-  代理: 接受客户端请求, 转发给其他服务器

   -  正向代理:
      通过代理服务器访问原始服务器资源(例如无法直接访问的服务器),
      客户端知道代理服务器
   -  反向代理: 代理服务器接受网络请求, 转发给内部服务器,
      客户端不知道是代理服务前正在代理

-  网关: 将HTTP转化为其他协议通信
-  隧道: 使用SSL等加密手段, 建立安全通信线路

HTTPS
`````

加密
^^^^

1. 客户端向服务端获取服务端公钥
2. 客户端生成一个对称密钥, 通过公钥加密后发给服务端
3. 服务端使用公钥对应的私钥解密出对称密钥
4. 之后的通信使用密钥进行加密

认证
^^^^

通过使用证书对通信方进行认证

1. 服务器向CA(数字证书认证机构, 可信赖的第三方)申请公钥
2. CA对申请的公钥做数字签名, 将公钥放入公钥证书绑定
3. HTTPS通信时, 服务器发送证书给客户端,
   客户端获得其中的公钥以及数字签名, 验证数字签名后通信

完整性保护
^^^^^^^^^^

SSL提供MD5报文摘要进行完整性保护

HTTP/1.0 VS HTTP/1.1
````````````````````

HTTP/1.1默认长连接, 支持同时多个TCP连接, 新增状态码100,
支持分块传输编码, 新增缓存处理命令

HTTP/2.0
````````

-  ``二进制分帧层``: 将报文分为HEADERS帧和DATA帧, 帧可交错发送,
   消息是一系列帧的组装
-  ``服务端推送``: 客户端请求一个资源时, 同时返回相关资源
-  ``首部压缩``:
   要求客户端和服务端同时维护和更新首部字段表并进行Huffman编码压缩,
   避免重复传输

IP
--

数据包格式
``````````

.. figure:: images/dev-network-ip-2.jpeg
    :alt: IP数据报格式

-  ``版本``: 4代表IPV4, 6代表IPV6
-  ``首部长度``: 首部有多少个4字节, 最小值5, 最大值15
-  ``区分服务``: 获取更好的服务
-  ``总长度``: 当前IP数据包整个长度, 单位字节, 最大值65535字节
-  ``标识``: 分片数据包的相同标识
-  ``标志``: 第一位为0, 第二位为1表示允许分片/0表示不分片,
   第三位为1表示还有分片/0表示最后一个分片
-  ``片偏移``: 在分片前的数据位置, 单位为8字节
-  ``生存时间``: TTL, 允许的路由跳数
-  ``协议``: 传输层使用协议
-  ``首部校验和``: 每经过一个路由计算的头部校验
-  ``填充``: 使得头部总长度为4字节的倍数

IP地址编码
``````````

-  ``分类``: 网络号 + 主机号, 分为A(8位网络号), B(16位网络号),
   C(24位网络号), D(多播地址), E(保留地址)类地址

   -  主机号至少2bit, 且不能使用全0(本网络的网络地址),
      全1(本网络的广播地址)

-  ``子网划分``: 将主机号部分拿出作为子网号, 使用子网掩码表达
-  ``无分类CIDR``: ip地址后面加上网络前缀的比特长度,
   网络前缀长度表示连续ip地址的相同部分

相关协议
````````

**地址解析协议ARP**:

-  实现由IP地址得到MAC地址
-  每个主机都有ARP缓存, 如果没有相应映射, 则广播发送ARP请求分组得到

**网际控制报文协议ICMP**:

-  确定IP包成功到达目的地址, 若失败则通知失败原因

网络地址转换NAT
```````````````

-  有NAT软件的路由器成为NAT路由器, 至少有一个有效地外部IP地址
-  内部主机通过NAT以一个外部IP的身份与外界通信,
   NAT保存内部IP的通信与外部IP的映射关系表,
   使得通信返回时能找到对应内部主机

**实现方法**:

-  ``静态转换``: 私有IP转为公有IP, 一对一, 不变
-  ``动态转换``: 私有IP转为公有IP, 对应关系不确定
-  ``端口多路复用``: 私有IP共用公有IP, 但是对应不同的端口
-  ``ALG``: 应用级别网关技术, 在协议数据报文中包含地址信息

IPV6
````

-  128bit表示ip地址, 用冒号分割,
   连续0位段可以用两个冒号压缩(一个ip地址中只能出现一次双冒号)

**数据报格式**:

.. figure:: images/ipv6.webp
    :alt: IPV6数据报格式

-  ``Version``: 版本
-  ``Traffic Class``: 获得更好的服务
-  ``Flow Label``: 标记特殊处理的数据流
-  ``Payload Length``: 负载长度, 报文总长度-40, 最大65535字节
-  ``Next Header``: 扩展报头类型或传输层协议头
-  ``Hop Limit``: 跳转次数限定

IPV4过渡方式
^^^^^^^^^^^^

-  ``双协议栈``: 主机与IPV4通信时使用IPV4地址, IPV6同理
-  ``隧道技术``: IPV6数据报进入IPV4网络时封装为IPV4数据报,
   到达主机时将IPV6数据报交给IPV6协议栈

OSI7
----

    物理层 → 数据链路层 → 网络层 → 传输层 → 会话层 → 表示层 → 应用层

``物理层``: 提供物理连接, 透明的比特流传输

``数据链路层``: 通过控制协议, 将物理信道转为可靠的数据链路

-  MAC介质访问控制层: 解决共享网络中多用户对信道竞争的问题
-  LLC逻辑链路控制层: 建立维护网络连接, 差错校验

``网络层``: 通过路由选择算法, 完成寻址, 交换, 路由, 网络层协议ip

``传输层``: 差错和流量控制, 保证数据传输的可靠性，传输层协议TCP, UDP

``会话层``: 协调两会话进程通信, 管理数据交互

``表示层``: 处理数据格式, 数据编码, 压缩解压缩, 数据加密解密

``应用层``: 向用户提供网络服务接口, 应用层协议FTP, HTTP

**TCP/IP分层**: 网络接口层, 网间层, 传输层, 应用层

RPC
---

   RPC: Remote Procedure Call, 远程过程调用

-  采用客户端/服务端模式
-  RPC协议: 客户端调用接口, 传入参数, 通过clientsub将参数序列化为消息发送给服务端, 服务端接受消息通过serversub反序列化为参数, 调用服务端过程, 最后相同步骤返回给客户端
-  RPC框架: Dubbo, SpringCloud
-  通信协议: 可使用HTTP或TCP
-  序列化技术: Jackson, JSON, Hessian

TCP
---

-  传输的数据先打到TCP包中, TCP包再封装到IP包中,
   再到以太网的Frame中进行传输, 接受的数据根据各层协议依次解析处理

**数据包头部格式**:

.. figure:: images/dev-network-tcpip-1.jpg
    :alt: TCP数据报头格式

-  ``Sequence Number``: 序列号, 解决乱序问题
-  ``Acknowledgement Number``: ACK, 确认收到
-  ``Offset``: 填充位
-  ``Reserved``: 保留位
-  ``TCP Flag``: 包类型, TCP状态
-  ``Window``: 滑动窗口
-  ``CheckSum``: 校验和
-  ``Urgent Pointer``: 紧急指针, 标识紧急数据

三次握手四次挥手
````````````````

.. figure:: images/dev-network-tcpip-4.jpg
    :alt: TCP34
    :width: 60%

状态机
``````

.. figure:: images/dev-network-tcpip-3.png
    :alt: TCP状态机
    :width: 60%

一些情况
````````

-  ``SYN超时``: 服务端收到了客户端第一次握手但没收到第三次握手,
   服务端处于SYN-RECEIVED, 服务端过一段时间重发SYN+ACK,
   每次重试后时间间隔翻倍
-  ``SYN攻击``: 大量的请求给服务端发送一个SYN后下线, 占用SYN队列

   -  解决方案(tcp_syncookies参数): SYN队列满后, TCP根据源端口,
      目的端口, 时间戳生成一个SYN(SYN Cookie), 从而使得服务端可以通过SYN
      Cookie建立连接(无需在SYN队列)

-  ``ISN(Initial SYN)``: 在TCP建立连接的时候,
   双方均需要初始化一个随机的SYN, 如果每次初始化相同的SYN,
   则两次TCP连接发送的数据包可能会被认为是同一次连接发送的数据包
-  ``MSL(Maximum Segment Lifetime)与TIME_WAIT``: ``MSL``\ 为TCP
   Segment最长存活时间(定义为2min, Linux 30s),
   TCP从TIME_WAIT到CLOSED需要等待2MSL

   -  目的: 确保有足够的时间对方收到ACK, 如果对方未收到会重发FIN,
      恰好2MSL; 防止和后面的连接混淆

-  ``TIME_WAIT过多``: 因为2MSL的等待时间可能会导致大量的TIME_WAIT

   -  解决方案: (不推荐)设置tcp_tw_reuse和tcp_tw_recycle,
      tcp_max_tw_buckets(TIME_WAIT最大并发数)

-  ``SYN变化``: 一次TCP中的SYN的变化与传输字节数有关

TCP重传
```````

-  ``超时重传``: 接收方不作任何操作, 等待发送方重传
-  ``快速重传``: 接收方没有连续到达时, 持续发送ACK,
   发送方收到连续3个相同的ACK时重传
-  ``SACK``: 在TCP头加一个SACK, 需要双方均开启,
   当没有接收到连续数据包时, ACK值保持不变, SACK记录非连续收到的包范围,
   当SACK记录变为连续后修改ACK, 删除SACK记录
-  ``D-SACK``:
   ACK覆盖了第一段的SACK或第二段的SACK覆盖了第一段的SACK则说明发生了重复接收,
   仅用于提醒发送方

RTT
```

重传需要有超时时间RTO, 通过计算RTT(数据包的往返时间)得到

**计算方法**:

-  ``经典算法``: 采样RTT, 做平滑计算SRTT(对上次SRTT与RTT加权),
   计算RTO(RTO的加权, 且限制上下界)
-  ``Karn/Partridge``: 忽略重传的RTT样本
-  ``Jacobson/Karels``: 计算SRTT的基础上,
   平滑计算DevRTT(DevRTT与|RTT-SRTT|加权), 计算RTO(SRTT和DevRTT加权)

TCP滑动窗口
```````````

-  告诉接收端自己还有多少缓冲区可以接收数据, 发送端据此发送数据
-  ``[已发送已ACK的数据, 滑动窗口结构(已发送未ACK的数据, 未发送的数据), 未读取的数据]``

UDP
---

**数据报头格式**: 源端口(16bit), 目的端口(16bit), 长度(16bit),
校验和(16bit)

**特点**:

-  ``无连接``: 不需要像TCP那样三次握手建立连接
-  ``首部开销小``, ``无拥塞控制``, ``无可靠交付``
-  ``面向报文``: 报文是UDP数据报处理最小单位

集线器, 交换机, 路由器
----------------------

``集线器``: 物理层, 数据广播到所有端口, 总线拓扑, 共用带宽

``交换机``: 数据链路层, 根据MAC地址转发, 独享带宽, 同一网段通信

``路由器``: 网络层, 根据ip地址转发, 防火墙, 不同网段通信

电路交换, 报文交换, 分组交换
----------------------------

``电路交换``: 建立通信独占信道, 独占带宽

``报文交换``: 以报文为数据单位交换, 存储转发, 报文长度差异导致时延大

``分组交换``: 将数据分组传输, 存储转发
