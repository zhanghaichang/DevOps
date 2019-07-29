# SOAP

> Simple Object Access Protocol(简单对象访问协议)，SOAP作为一个基于XML语言的协议用于有网上传输数据。SOAP = 在HTTP的基础上+XML数据。SOAP是基于HTTP的，使用POST方式。SOAP的组成如下：Envelope – 必须的部分。以XML的根元素出现。Headers – 可选的。Body – 必须的。在body部分，包含要执行的服务器的方法。和发送到服务器的数据（服务器相应的数据）。

## WSDL
> WebService Description Language – Web服务描述语言。通过XML形式说明服务在什么地方－地址。通过XML形式说明服务提供什么样的方法 – 如何调用。

SOAP1.1请求消息体

http header

```shell

POST /WebServices/MobileCodeWS.asmx HTTP/1.1
Host: webservice.webxml.com.cn
Content-Type: text/xml; charset=utf-8
Content-Length: length
SOAPAction: "http://WebXml.com.cn/getMobileCodeInfo"
```

```xml

<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getMobileCodeInfo xmlns="http://WebXml.com.cn/">
      <mobileCode>string</mobileCode>
      <userID>string</userID>
    </getMobileCodeInfo>
  </soap:Body>
</soap:Envelope>
```

SOAP1.1响应消息体

```shell

HTTP/1.1 200 OK
Content-Type: text/xml; charset=utf-8
Content-Length: length

```


```xml
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getMobileCodeInfoResponse xmlns="http://WebXml.com.cn/">
      <getMobileCodeInfoResult>string</getMobileCodeInfoResult>
    </getMobileCodeInfoResponse>
  </soap:Body>
</soap:Envelope>
```

SOAP1.2请求消息体

```
POST /WebServices/MobileCodeWS.asmx HTTP/1.1
Host: webservice.webxml.com.cn
Content-Type: application/soap+xml; charset=utf-8
Content-Length: length
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <getMobileCodeInfo xmlns="http://WebXml.com.cn/">
      <mobileCode>string</mobileCode>
      <userID>string</userID>
    </getMobileCodeInfo>
  </soap12:Body>
</soap12:Envelope
```

SOAP1.2响应消息体

```
HTTP/1.1 200 OK
Content-Type: application/soap+xml; charset=utf-8
Content-Length: length
```
```xml
<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <getMobileCodeInfoResponse xmlns="http://WebXml.com.cn/">
      <getMobileCodeInfoResult>string</getMobileCodeInfoResult>
    </getMobileCodeInfoResponse>
  </soap12:Body>
</soap12:Envelope>
```

SOAP1.1和1.2版本关系

> SOAP1.2客户端兼容1.1和1.2的SOAP服务端，SOAP1.1客户端只能用于1.2的服务端。wsimport命令只能识别1.1的WSDL文档，wsdl2java可以识别1.1和1.2的文档，后者在实际开发中使用更多。
