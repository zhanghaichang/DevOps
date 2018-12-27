- [HTTP 报文](#http-报文)
  - [1. 报文格式](#1-报文格式)
    - [1.1. 请求报文](#11-请求报文)
    - [1.2. 响应报文](#12-响应报文)
  - [2. 首部字段](#2-首部字段)
    - [2.1. 基本概念](#21-基本概念)
    - [2.2. 请求首部字段](#22-请求首部字段)
    - [2.3. 响应首部字段](#23-响应首部字段)
    - [2.4. 通用首部字段](#24-通用首部字段)
    - [2.5. 实体首部字段](#25-实体首部字段)
    - [2.6. 其它非标准首部字段](#26-其它非标准首部字段)
  - [3. Refer Links](#3-refer-links)

# HTTP 报文

## 1. 报文格式

RFC2616 规定：**HTTP/1.1 的状态行和头区域只能包含 ASCII(iso-8859-1) 编码的字符，数据体可以是文本 (ASCII) 或二进制**。

### 1.1. 请求报文

- 报文首部
  - 请求行：请求方法、请求 URI、HTTP 版本
	- 首部字段
    - 请求首部字段
    - 通用首部字段
    - 实体首部字段
    - 其它非标准首部字段
- 空行（CR+LF）
- 报文主体

### 1.2. 响应报文

- 报文首部
  - 状态行：HTTP 版本、状态码（数字和原因短语）
	- 首部字段
    - 响应首部字段
    - 通用首部字段
    - 实体首部字段
    - 其它非标准首部字段
- 空行（CR+LF）
- 报文主体

## 2. 首部字段

### 2.1. 基本概念

首部字段结构：
```
首部字段名：字段值 1[，字段值 2[，字段值 3……]]
```

如果在 HTTP 首部中出现了多个相同的首部字段名，不同浏览器的处理方式不同，有的优先处理第一次出现的，有的优先处理最后出现的。

首部字段分类：
- 逐跳首部（Hop-by-hop Header）：只会这条请求 / 响应只转发一次。HTTP/1.1 中规定的逐跳首部字段只有 8 个：
  - Connection 
  - Keep-Alive 
  - Proxy-Authenticate 
  - Proxt-Authorization
  - Trailer 
  - TE 
  - Transfer-Encoding 
  - Upgrade
- 端到端首部（End-to-end Header）：会将这条请求 / 响应一直转发至最终接收目标。除以上 8 个以外的首部字段都是端到端首部。

### 2.2. 请求首部字段

- `Accept` 通知服务器客户端能接受的媒体类型（多种媒体类型用逗号“,”分隔）和相对优先级（0<=q<=1，可精确到小数点后三位，连接在其修饰的媒体类型之后，用分号“;”连接，q 缺省值为 1）。
  
  eg:
  ```
  Accept:text/html, application/xml;q=0.9, */*;q=0.8
  ```

- `Accept-Charset` 通知服务器客户端支持的字符集及其相对优先级。
  
  eg:
  ```
  Accept-Charset:iso-8859-5,unicode-1-1;q=0.85
  ```
- `Accept-Encoding`	通知服务器客户端支持的内容编码方式（用于压缩）及其相对优先级。
  - gzip：由 GNU zip 程序生成的编码格式
  - compress：由 compress 程序生成的编码格式
  - deflate：组合使用 zlib 和由 deflate 算法生成的编码格式
  - identity：不执行压缩或不会变化的默认编码格式

- `Accpet-Language`	通知服务器客户端支持的语言集及其相对优先级。eg:zh-cn、zh、en-us、en 等。

- `Authorization`	向服务器发送所质询的认证信息（以“用户名：密码”的形式组成字符串后用 base64 编码）。

- `Expect` 告知服务器希望出现的某种特定行为。eg: `Expect:100-continue`。

- `From` 告知服务器客户端用户的电子邮件地址。

- `Host` 服务器可能运行着多台虚拟主机，Host 字段告知服务器该请求是向哪一个域名的服务器发起的。**该字段是唯一一个必须包含的请求首部字段**。

- `If-Match` 条件判断，告知服务器当资源的‘ETag 值与指定的值相同时，才返回该资源，否则返回 412。
  
  eg:
  ```
  If-Match:“123456”
  If-Match:*   （只要资源存在就处理请求)
  ```

- `If-Node-Match` 条件判断，与 If-Match 相反。	

- `If-Modified-Since`	条件判断，告知服务器当资源在指定的时间之后发生过修改，才返回该资源，否则返回 304。
  
  eg:
  ```
  If-Modified-Since:Thu, 15 Apr 2004 00:00:00 GMT
  ```

- `If-Unmodified-Since`	条件判断，与 If-Modified-Since 相反；	在 GET 和 HEAD 方法中可利用该首部字段获取最新的资源。

- `If-Range` 条件判断，与 Range 字段搭配使用，如果服务器上指定范围的资源 ETag 值匹配成功，则返回 206 和这一范围的资源；若匹配失败，则返回 200 和全部资源。
  
  eg:
  ```
  If-Range:“123456”
  Range:bytes=5001-10000
  ```

- `Range`		
  
  eg:
  ```
  Range:bytes=5001-10000
  ```

- `Max-Forwards` 指定请求的最大转发次数。

- `Proxy-Authorization`	向代理服务器发送所质询的认证信息。

- `Referer`	告知服务器请求的 URI 是从哪个 web 页面发起的，但出于安全的考虑，可以不发送该首部字段。实际上，**正确拼写应为 Referrer，但习惯上沿用了错误拼写**。

- `TE` 告知服务器客户端所能支持的分块传输编码方式及其相对优先级。指定伴随 trailer 字段的分块传输编码的方式，只需把 trailer 赋值给该字段值。
  
  eg:
  ```
  TE:gzip,deflate;q=0.5
  ```

- `User-Agent` 告知服务器发起请求的客户端浏览器和用户代理名称等信息。
  
  eg:
  ```
  User-Agent: Mozilla/5.0(Windows NT 6.1; WOW64; rv:13.0) Gecko/=>20100101 Firefox/13.0.1
  ```

### 2.3. 响应首部字段

- `Accept-Ranges` 告知客户端能否处理范围请求，“可处理”为 bytes，“无法处理”为 none。
  
  eg:
  ```
  Accept-Ranges: bytes
  Accept-Ranges:none
  ```

- `Age` 告知客户端所返回的缓存在多久之前被源服务器创建（秒），代理创建响应时必须加上该首部字段。

- `ETag` 告知客户端所返回实体的实体标识（即 ETag 值）（ETag 值的生成没有特定的算法，仅仅是由服务器指定）。
  
  eg:
  ```
  ETag: “123456”       ->强 ETag
  ETag: W/“usagi-1234” ->弱 Etag
  ```

- `Loctaion` 引导客户端到某个与请求 URI 不同的资源 URI，常与 3xx 重定向搭配使用。	

- `Vary` 指定某个字段后，告知缓存服务器，若客户端的请求中被指定的字段与缓存服务器的该字段相同，才可返回缓存。
  
  eg:
  ```
  Vary:Accept-Language
  ```
  则只有当客户端请求的 Accept-Language 字段值与缓存服务器的 Accept-Language 字段值相同时，缓存服务器才会返回缓存。

- `Retry-After` 告知客户端可在多久之后再次发送请求，搭配 503 或 3xx 作为响应；	字段值可以是指定的具体日期，也可以是创建响应后的秒数。

- `Server` 告知客户端服务器的 HTTP 服务器应用程序信息。

- `Proxy-Authenticate` 质询客户端代理服务器需要认证信息，通常搭配 401 作为响应。
  
  eg:
  ```
  Proxy-Authenticate:Basic realm=”xxxxx”
  ```

- `WWW-Authenticate` 质询客户端服务器需要认证信息，通常搭配 401 作为响应。

### 2.4. 通用首部字段

- `Cache-Control` 通过该首部字段的指令，操作缓存的工作机制。

  网络模型：
  ```
  客户端<->缓存服务器<->源服务器
  ```
  
  Cache-Control 可用的指令可分为缓存请求指令和缓存响应指令：
  - 表示是否能缓存：
    - no-cache（请求 / 响应）：若请求中含有 no-cache，则强制缓存服务器向源服务器再次验证缓存有效性；若源服务器返回的响应中若带有 no-cache，则缓存服务器每次使用该缓存都需向源服务器确认有效性。另，若 no-cache 带有参数，则不可使用缓存。
    - no-store（请求 / 响应）：暗示请求 / 响应中含有机密信息，强制服务器不能进行任何缓存。
  - 表示缓存的可用范围：
    - public（响应）：缓存可供所有用户使用。 
    - private（响应）：缓存只可供特定用户使用。
    
    eg: Firefox 默认只在内存中缓存 HTTPS。但是，只要头命令中有 Cache-Control: Public，缓存就会被写到硬盘上。

  - 指定缓存的期限：
    - max-age= 秒（请求 / 响应）：向缓存服务器指定客户端所能接受的缓存时间值；告知缓存服务器在指定时间内不必向源服务器确认缓存有效性，可直接支配；另，使用该指令会直接忽略 Expires 首部字段。
    - s-maxage= 秒（响应）：功能同 max-age，但 s-maxage 只能用于多用户的公共缓存服务器；另，使用该指令也会直接忽略 Expires 首部字段。

    - min-fresh= 秒（请求）：要求缓存服务器返回至少还未过指定时间的缓存资源，即 xx 秒后仍不会过期的资源。
    - max-stale（请求）：告知缓存服务器只要缓存未过指定时间，即使过期也返回；（参数可省略）。
    - only-if-cached（请求）：要求缓存服务器只直接返回缓存，不验证有效性；若无缓存可返回，则返回 504。
    - must-revalidate（响应）：要求缓存服务器每次使用该缓存时都要向源服务器验证有效性；若无法连通源服务器，则返回给客户端 504。
    - proxy-revalidate（响应）：同上。

    - no-transform（请求）：要求缓存不能改变实体主体的媒体类型（如防止缓存或代理压缩图片等操作）。
  - 扩展：
    - cache-extension token（请求 / 响应）若对方服务器无法理解，则直接忽略。eg: `Cache-Control: private, community=”UCI”`。

- `Connection` 
  - 指定不再转发给下一级代理的字段（在下一级代理的转发中会删除被指定的字段一级 Connection 字段本身）即实现 Hop-by-hop 首部。
  - 管理持久连接，HTTP/1.1 的连接默认是持久连接（Connection：keep-Alive），若要断开连接，需指定 Connection：Close。
  eg:
  ```
  GET / HTTP/1.1
  Upgrade: HTTP/1.1
  Connection:Upgrade
  ```

- `Date` 表示创建 HTTP 报文的创建日期。
  
  eg:
  ```
  Date: Tue, 03-Jul-12 04:40:38 GMT
  (RFC1123 规定的日期时间格式)
  ```

- `Pragma` HTTP1.1 之前的版本遗留下的字段，要求所有中间服务器不返回缓存的资源。
  ```
  Pragma:no-cache
  Cache-Control:no-cache
  ```
  注：通常发送的请求会同时含有以上两个字段，以应对不同服务器的 Http 版本问题；

- `Trailer` 事先说明在报文主体后记录了哪些首部字段，用于分块传输编码时。

- `Transfer-Encoding` 说明了报文主体采用的传输编码方式（分块传输）。
  
  eg:
  ```
  Transfer-Encoding: chunked
  （采用分块传输编码）
  ```

- `Upgrade` 询问服务器是是否支持其它指定的协议；服务器处理请求后，返回 101 状态码和 Upgrade 字段，值为自身支持的协议。必须搭配 Connection：Upgrade 使用，使其作用仅在客户端与邻接服务器之间；	
  
  eg:
  ```
  Upgrade:TLS/1.0
  ```

- `Via` 每经过一个代理服务器，代理服务器会将自己的信息追加到该字段中，用于报文的追踪转发和防止请求回环的发生，一般使用代理服务器时必须含有该字段。

- `Warning` 告知用户一些与缓存有关的问题的警告。
  
  格式：
  ```
  Warning: 警告码 警告的主机：端口号 “警告内容”（日期时间）
  ```

### 2.5. 实体首部字段

实体首部字段用于说明实体内容的更新时间、所用语言等与实体有关的信息。

- `Content-Encoding` 告知对方实体的主体部分选用的内容编码方式（内容编码：对实体进行的压缩；传输编码：对实体进行分块传输）。
  - gzip
  - compress
  - deflate
  - identity

- `Content-Language` 实体主体所使用的语言，如 zh-CN 等。

- `Content-Length` 实体主体的大小，以字节为单位。当实体主体进行了内容编码即压缩传输时，不可再使用该字段。

- `Content-Location` 给出与报文主体相对应的 URI（即资源的 URI)。

- `Content-MD5` 用于检查报文主体在传输过程中是否保持完整的一串字符串。
  - 生成方法：对报文主体使用 MD5 算法生成 128 位的二进制数，再使用 base64 编码后可得（HTTP 首部无法记录二进制值，故必须使用 base64 处理）。
  - 局限性：如果报文被恶意篡改，MD5 值同样可以通过重新计算后篡改，而客户端无从发现，因此无法真正查证报文主体的完整和准确性。

- `Content-Range` 返回的是实体的哪个部分的范围（以字节为单位），eg: `Content-Range:bytes 501-1000/1000`。

- `Content-Type` 
  - 说明了实体主体内对象的媒体类型（MIME Type）。
  - 字段值采用 type/subtype 的形式。
  - 可在尾部使用分号，添加参数。例如：Content-Type: text/html;charset=UTF-8。通知客户端浏览器，服务器发送的数据格式是 text/html，采用 utf-8 编码，建议 / 要求浏览器使用 utf-8 进行解码。
  
  常用预定义的媒体类型：
  ```
  text/plain
  text/html
  text/css
  image/jpeg
  image/png
  image/svg+xml
  audio/mp4
  video/mp4
  application/javascript
  application/pdf
  application/zip
  application/atom+xml
  ```
  除了预定义的类型，厂商也可以自定义类型，如：`application/vnd.debian.binary-package`类型表明，发送的是 Debian 系统的二进制数据包。

- `Allow` 说明服务器支持的所有 request 方法。当收到服务器不支持的 request 方法时，会返回 405 状态码和 Allow 字段作为响应。eg: `Allow: GET, HEAD, OPITIONS`。

- `Expires` 说明资源失效的日期，超过有效日期后，缓存服务器若接收到该资源的请求，需重新向源服务器请求。不希望资源被缓存时，最好写入 Expires 字段，并将其值设为与 Date 字段值相同，若 Cache-Control 字段指定了 max-age，会优先处理 max-age 指令。eg: `Expires: Wed, 04 Jul 2017 08:27:08 GMT`。

- `Last-Modified`	说明资源的最后修改时间。eg: `Last-Modified: Wed, 04 Jul 2017 08:27:08 GMT`。

### 2.6. 其它非标准首部字段

- 与 cookie 相关的首部字段
  - `Set-Cookie`：服务器告知客户端，在客户端本地保存该 Cookie。

    格式：
    ```
    Set-Cookie：[NAME]=[value]; 『属性』=[value]; 『属性』=[value]……
    ```
    
    Cookie 属性：
    - `NAME=VALUE`（必需项）赋予此 Cookie 的名称和值。
    - `expires=DATE` 指定 Cookie 的有效期（缺省值为直到浏览器关闭）。另，不存在从服务器端直接显式删除客户端 Cookie 的方法，但可通过覆盖实现删除操作。
    - `path=PATH`	将服务器上的文件目录作为 Cookie 的适用对象。但有方法避开该限制，存在安全问题。
    - `domain= 域名`	指定 Cookie 适用对象的域名（缺省值为创建 Cookie 的服务器域名）。除针对具体指定多个域名发送 Cookie，不发送 domain 字段更加安全。
    - `secure` 要求仅在 https 通信时才会发送 cookie。
    - `HttpOnly` 使得 javascript 无法获取 cookie，以防止跨站脚本攻击（xss）对 cookie 信息的窃取（但该属性初衷不是针对 xss 开发的）。

  - `Cookie`：客户端向服务器发起请求时，若本地的 Cookie 未过期，会在请求中自动加入从服务器接收到的 Cookie 信息，告知服务器客户端的身份。

- `DNT` Do Not Track，即拒绝个人信息被服务器收集，是表示拒绝被精准广告追踪的一种方法。
  - 0：同意被追踪
  - 1：拒绝被追踪

- `P3P` 使 web 网站上的个人隐私成为一种仅程序可理解的形式，以达到保护用户隐私的目的。

- `X-XSS-Protection` 用于控制浏览器 XSS 防护机制的开关。
  - 0：关闭 XSS 过滤。
  - 1：开启 XSS 过滤。

- `X-Frame-Options` 用于防止点击劫持攻击（clickjacking）, 控制网站内容在其它 web 网站的 Frame 标签内的显示问题；能在所有 web 服务器预先设定好该字段是最理想的。
  - X-Frame-Options:DENY 拒绝。
  - X-Frame-Options:SAMEORIGIN 仅同源域名下的网页匹配时许可。

- `X-Forwarded-For` XFF 是用来识别通过 HTTP 代理或负载均衡方式连接到 Web 服务器的客户端最原始的 IP 地址的 HTTP 请求头字段。 Squid 缓存代理服务器的开发人员最早引入了这一 HTTP 头字段，并由 IETF 在 HTTP 头字段标准化草案 [1] 中正式提出。

  格式：
  ```
  X-Forwarded-For: client1, proxy1, proxy2
  ```
  当经过了多级代理的话，第二级代理会把前面一级代理的 XFF 值给覆盖吗？答案是不会。实际上可以保存多个 IP 地址其，中的值通过一个 逗号 + 空格 把多个 IP 地址区分开，最左边（client1）是最原始客户端的 IP 地址，代理服务器每成功收到一个请求，就把请求来源 IP 地址添加到右边。 在上面这个例子中，这个请求成功通过了三台代理服务器：proxy1, proxy2 及 proxy3。请求由 client1 发出，到达了 proxy3（proxy3 可能是请求的终点）。请求刚从 client1 中发出时，XFF 是空的，请求被发往 proxy1；通过 proxy1 的时候，client1 被添加到 XFF 中，之后请求被发往 proxy2; 通过 proxy2 的时候，proxy1 被添加到 XFF 中，之后请求被发往 proxy3；通过 proxy3 时，proxy2 被添加到 XFF 中，之后请求的的去向不明，如果 proxy3 不是请求终点，请求会被继续转发。XFF 中没有保存最后一级代理的 IP，即与服务器直连的 ip 地址，因为这个 IP 地址可以在 TCP 包（确切说是 IP 包）里的 Remote Address 字段中找到。
    
  鉴于伪造这一字段非常容易，应该谨慎使用 X-Forwarded-For 字段。正常情况下 XFF 中最后一个 IP 地址是最后一个代理服务器的 IP 地址，这通常是一个比较可靠的信息来源。

## 3. Refer Links

《图解 HTTP》

[阮一峰：HTTP 协议入门](http://www.ruanyifeng.com/blog/2016/08/http.html)
