- [HTTP Method](#http-method)
  - [1. GET](#1-get)
    - [1.1. 长度限制](#11-长度限制)
    - [1.2. 编码过程](#12-编码过程)
  - [2. POST](#2-post)
    - [2.1. 长度限制](#21-长度限制)
    - [2.2. 编码过程](#22-编码过程)
      - [2.2.1. 客户端编码](#221-客户端编码)
      - [2.2.2. 服务端解码](#222-服务端解码)
      - [2.2.3. 常见编码方式](#223-常见编码方式)
  - [3. PUT](#3-put)
  - [4. HEAD](#4-head)
  - [5. DELETE](#5-delete)
  - [6. OPTIONS](#6-options)
  - [7. TRACE](#7-trace)
  - [8. CONNECT](#8-connect)
  - [9. Refer Links](#9-refer-links)

# HTTP Method

HTTP/1.1 协议规定的 HTTP 请求方法有 OPTIONS、GET、HEAD、POST、PUT、DELETE、TRACE、CONNECT。

## 1. GET

GET 方法用于请求访问已被 URI 识别的资源，指定的资源经服务器端解析后返回。

GET 方法将请求的参数信息直接添加在网址后面，网址与参数信息通过"?"号分隔。如：`http://www.test.com/hello?key1=value1&key2=value2`。因此，一些敏感信息（如密码等）建议不使用 GET 方法进行 HTTP 通信。

### 1.1. 长度限制

虽然 URL 规范不存在参数数量的上限，在 HTTP 协议的规范中也没有对 URL 长度进行限制，但**部分浏览器及服务器会对 URL 的长度进行限制**。如：IE 对 URL 长度的限制是 2083 字节 (2K+35)；对于其他浏览器，如 Netscape、FireFox 等，理论上没有长度限制，其限制取决于操作系统的支持。

[What is the maximum length of a URL in different browsers?](https://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url-in-different-browsers)
> If you keep URLs under 2000 characters, they'll work in virtually any combination of client and server software.
> 
> If you are targeting particular browsers, see below for more details specific limits.

### 1.2. 编码过程

客户端编码：
1. 对原始 URL（含有各种字符）进行 `URLEncode`（使得 URL 的所有字符都在 ASCII 字符范围内），得到 `%XY` 形式的 URL。
1. 将请求头以 UTF-8/ISO-8859-1 等编码方式转换为二进制。
1. 发送请求。

服务端解码：
1. 把数据用 ISO-8859-1/UTF-8 等编码方式进行解码，得到 `%XY` 形式的 URL。
1. 对 URL 进行 `URLdecode`，得到原始 URL（含有各种字符）。

P.S. 

在 JavaEE 的 Servlet 中使用 `request.getParameter("name")` 获取到参数数据时，实际上已经完成了第一步解码，且解码过程中程序里是无法指定，tomcat 默认缺省用的是 iso-8859-1，因此，在客户端一般都是用 UTF-8 或 GBK 对数据 URL encode，而 tomcat 服务器用 iso-8859-1 方式 URL decoder，导致了 GET 请求带中文参数在 tomcat 服务器端就会得到乱码，解决办法：
- `new String(request.getParameter("name").getBytes("iso-8859-1"),"客户端指定的 URL encode 编码方式")`: 先还原回字节码，然后用正确的方式解码数据。
- 修改 web.xml，使 tomcat 获取数据后用指定的方式 URL decoder：
  ```XML
  <Connector port="8080" protocol="HTTP/1.1" maxThreads="150" connectionTimeout="20000" redirectPort="8443" URIEncoding="GBK"/>   // 或 utf-8
  ```

## 2. POST

POST 方法用于传输实体的主体，由于 POST 提交数据在浏览器中是不可见的（但可被抓包工具获取），因此一些敏感信息（如密码）等一般都通过 POST 方法传递。

P.S. JSP 中使用 `getParameter()` 来获得传递的参数，`getInputStream()` 方法用来处理客户端的二进制数据流的请求。

### 2.1. 长度限制

POST 是没有大小限制的，HTTP 协议规范也没有进行大小限制。POST 数据是没有限制的；起限制作用的顶多是服务器的处理程序的处理能力，而这个限制是针对所有 HTTP 请求的，与 GET、POST 没有多少关系。

### 2.2. 编码过程

#### 2.2.1. 客户端编码

HTTP 协议以 ASCII 码传输，在 RFC 标准中把 HTTP 报文规范为以下格式：
```
<method> <request-URL> <version>
<headers>
<\r\n>
<entity-body>
```
协议标准规定 POST 传输时数据必须存放在消息主体 (entity-body) 中，但没有规定数据应采用什么编码格式，因此，开发者通常自己决定消息主体的格式，只要最后发送的 HTTP 请求满足 RFC 标准的格式就可以。

POST 一般用于传输表单数据，在 form 所在的 HTML 文件里如果有 `<meta http-equiv="Content-Type" content="text/html; charset= 字符集（GBK，utf-8 等）"/>` 的标签，那么 POST 就会用此处指定的编码方式编码，指定 form 表单的 POST 方法提交数据的 URL encode 编码方式。

从这里可以看出对于 GET 方法来说，URL encode 的编码方式是由浏览器设置来决定（但可以用 JavaScript 做统一指定），而 POST 方法可以由开发人员指定编码方式。

#### 2.2.2. 服务端解码

服务端通常是根据请求头部（headers）中的 Content-Type 字段来获知请求中的消息主体是用何种方式编码，再对主体进行解析。

一般服务端语言如 php、python 等，以及它们的 framework，都内置了自动解析常见数据格式的功能。如果用 tomcat 默认缺省设置，也没做过滤器等编码设置，那么他也是用 iso-8859-1 解码的，但是 request.setCharacterEncoding("字符集") 可以派上用场。

#### 2.2.3. 常见编码方式

- `application/x-www-form-urlencoded`

  最常见的 POST 提交数据的方式。浏览器的原生 `<form>` 表单如果不设置 enctype 属性，会默认以 `application/x-www-form-urlencoded` 方式提交数据。生成的请求报文如下（无关的请求头在本文中都省略掉了）：
  ```
  POST http://www.example.com HTTP/1.1
  Content-Type: application/x-www-form-urlencoded;charset=utf-8

  title=test&sub%5B%5D=1&sub%5B%5D=2&sub%5B%5D=3
  ```
  解析：

  1. 首先，Content-Type 被指定为 `application/x-www-form-urlencoded`。
  1. 其次，提交的数据按照 `key1=val1&key2=val2`的方式进行编码，key 和 val 都进行了 URL 转码。大部分服务端语言都对这种方式有很好的支持。例如 PHP 中，`$_POST['title']` 可以获取到 title 的值，`$_POST['sub']` 可以得到 sub 数组。

  很多时候我们用 Ajax 提交数据时，也是使用这种方式。例如 JQuery 和 QWrap 的 Ajax， Content-Type 默认值都是 `application/x-www-form-urlencoded;charset=utf-8`。HTML 中的 form 表单在你不写 enctype 属性时，也默认为其添加了 enctype 属性值，默认值就是 `enctype="application/x- www-form-urlencoded"`。

- `multipart/form-data`

  另一种常见的 POST 数据传输方式，这种方式一般用来上传文件，各大服务端语言对它也有着良好的支持。在 Html 中使用表单 `<form>` 时，使 `enctype=multipart/form-data`，即可采用此方法传输数据，生成的请求报文如下：
  ```
  POST http://www.example.com HTTP/1.1
  Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryrGKCBY7qhFd3TrwA

  ------WebKitFormBoundaryrGKCBY7qhFd3TrwA
  Content-Disposition: form-data; name="text"

  title
  ------WebKitFormBoundaryrGKCBY7qhFd3TrwA
  Content-Disposition: form-data; name="file"; filename="chrome.png"
  Content-Type: image/png

  PNG ... content of chrome.png ...
  ------WebKitFormBoundaryrGKCBY7qhFd3TrwA—
  ```
  解析：

  1. 首先生成了一个 boundary 用于分割不同的字段，为了避免与正文内容重复，boundary 很长很复杂，Content-Type 里指明了数据是以 multipart/form-data 来编码，本次请求所用的 boundary 是什么内容。
  1. 消息主体里按照字段个数又分为多个结构类似的部分，每部分都是以 `--boundary` 开始，紧接着是内容描述信息，然后是回车，最后是字段具体内容（文本或二进制）。如果传输数据中含有文件，还要包含文件名和文件类型信息。
  1. 消息主体最后以 --boundary-- 标示结束。

  关于 multipart/form-data 的详细定义，可在 RFC1867 中查看。

  上面提到的这两种 POST 数据的方式，都是浏览器原生支持的，而且现阶段标准中原生 `<form>` 表单也只支持这两种方式（通过 `<form> `元素的 enctype 属性指定，默认为 `application/x-www-form-urlencoded`。其实 enctype 还支持 `text/plain`，不过用得非常少）

  **随着越来越多的 Web 站点，尤其是 WebApp，全部使用 Ajax 进行数据交互之后，我们完全可以定义新的数据提交方式，给开发带来更多便利**。

- `application/json`

  `application/json` 这个 Content-Type 作为响应头大家肯定不陌生。实际上，现在越来越多的人把它作为请求头，用来告诉服务端消息主体是序列化后的 JSON 字符串。由于 JSON 规范的流行，除了低版本 IE 之外的各大浏览器都原生支持 `JSON.stringify`，服务端语言也都有处理 JSON 的函数，使用 JSON 不会遇上什么麻烦。

  JSON 格式支持比键值对复杂得多的结构化数据，这一点也很有用。记得我几年前做一个项目时，需要提交的数据层次非常深，我就是把数据 JSON 序列化之后来提交的。不过当时我是把 JSON 字符串作为 val，仍然放在键值对里，以 x-www-form-urlencoded 方式提交。

  Google 的 AngularJS 中的 Ajax 功能，默认就是提交 JSON 字符串。例如下面这段代码：
  ```JavaScript
  var data = {'title':'test', 'sub' : [1,2,3]};
  $http.post(url, data).success(function(result) {
      ...
  });
  ```
  最终发送的请求是：
  ```
  POST http://www.example.com HTTP/1.1 
  Content-Type: application/json;charset=utf-8

  {"title":"test","sub":[1,2,3]}
  ```
  这种方案，可以方便的提交复杂的结构化数据，特别适合 RESTful 的接口。各大抓包工具如 Chrome 自带的开发者工具、Firebug、Fiddler，都会以树形结构展示 JSON 数据，非常友好。但也有些服务端语言还没有支持这种方式，例如 php 就无法通过 $_POST 对象从上面的请求中获得内容。这时候，需要自己动手处理下：在请求头中 Content-Type 为 application/json 时，从 php://input 里获得原始输入流，再 json_decode 成对象。一些 php 框架已经开始这么做了。

  当然 AngularJS 也可以配置为使用 x-www-form-urlencoded 方式提交数据。如有需要，可以参考[这篇文章](http://victorblog.com/2012/12/20/make-angularjs-http-service-behave-like-jquery-ajax/)。

- `text/xml`

  XML-RPC（XML Remote Procedure Call）是一种使用 HTTP 作为传输协议，XML 作为编码方式的远程调用规范，典型的 XML-RPC 请求如下：
  ```
  POST http://www.example.com HTTP/1.1 
  Content-Type: text/xml

  <?xml version="1.0"?>
  <methodCall>
      <methodName>examples.getStateName</methodName>
      <params>
          <param>
              <value><i4>41</i4></value>
          </param>
      </params>
  </methodCall>
  ```
  XML-RPC 协议简单、功能够用，各种语言的实现都有。它的使用也很广泛，如 WordPress 的 XML-RPC Api，搜索引擎的 ping 服务等等。JavaScript 中，也有现成的库支持以这种方式进行数据交互，能很好的支持已有的 XML-RPC 服务。不过， XML 结构过于臃肿，一般场景用 JSON 会更灵活方便。

## 3. PUT

PUT 方法用于传输文件，要求在请求报文的主体中包含文件内容，然后保存到请求 URI 指定的位置。

## 4. HEAD

HEAD 方法等同于 GET 方法，区别在于要求响应不返回报文主体部分，只返回请求头部。

## 5. DELETE

DELETE 方法用于删除文件，是与 PUT 方法相反的方法。

## 6. OPTIONS

OPTIONS 方法用于查询针对指定 URI 服务器支持的所有 HTTP 方法。

## 7. TRACE

TRACE 方法要求 web 服务器端将之前的请求通信环回给客户端。

## 8. CONNECT

CONNECT 方法要求在与代理服务器通信时建立隧道，实现用隧道协议进行 TCP 通信。

## 9. Refer Links

[【Java EE】get 和 post 请求的编码过程](http://blog.csdn.net/yanwushu/article/details/8088260)
