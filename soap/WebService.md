# WebService的常见标签

### 1、 @WebService标签

使用@WebService标签，需要配置在类上，代表这是一个提供WS的服务类。

endpointInterface：定义服务抽象WebService 协定的服务端点接口的完整名称。不允许在端点上使用此成员值，该元素的值必须有WebService标签。默认情况下，服务器自动生成服务端接口。

name：服务接口名称（对应wsdl: portType的name属性，用在服务接口上）；

serviceName：服务类名称。默认为，实现类名+Service（对应service的name和definition上的name属性对应，用在实现类上）。

portName：Web Service的端口名称。此名称被用作wsdl:port的名称。

targetNamespace：目标命名空间，描述服务的预定义WSDL的位置（同时用在实现类和服务接口上，需统一）。

wsdlLocation：WSDL地址（服务端除了WSDL优先的情况外可不写，客户端代理接口上必须配置此属性，指向web端WSDL文件地址）
