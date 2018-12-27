- [HTTP Cookie && Session](#http-cookie--session)
  - [1. Cookie](#1-cookie)
    - [1.1. 基本概念](#11-基本概念)
    - [1.2. HTTP 首部字段](#12-http-首部字段)
      - [1.2.1. Set-Cookie](#121-set-cookie)
      - [1.2.2. Cookie](#122-cookie)
    - [1.3. 编码](#13-编码)
    - [1.4. Cookie 维护](#14-cookie-维护)
      - [1.4.1. 设置 cookie](#141-设置-cookie)
      - [1.4.2. 修改 cookie](#142-修改-cookie)
    - [1.5. 限制](#15-限制)
    - [1.6. 安全问题](#16-安全问题)
    - [1.7. Cookie 传输优化](#17-cookie-传输优化)
  - [2. Session](#2-session)
    - [2.1. 基本概念](#21-基本概念)
    - [2.2. 生命周期](#22-生命周期)
    - [2.3. sessionID](#23-sessionid)
    - [2.4. 安全问题](#24-安全问题)
      - [2.4.1. Session 攻击](#241-session-攻击)
      - [2.4.2. 防范措施](#242-防范措施)
    - [2.5. 限制](#25-限制)
  - [3. Refer Links](#3-refer-links)

# HTTP Cookie && Session

Cookie 和 Session 都是为解决 Http Stateless 所带来的问题而开发的技术，用于保存访问者的身份和与会话有关的一些数据，**两者最基本的区别在于 cookie 保存在客户端，而 session 保存在服务器端，但是两者也有联系，如 sessionID 的传递通常依赖于 cookie**。

## 1. Cookie

### 1.1. 基本概念

Cookie 最早由网景公司设计开发，**没有被编入标准化 HTTP/1.1 的 RFC2616 中，目前广泛使用的 cookie 标准是在网景公司制定的标准上进行扩展后的产物**。

Cookie 的工作机制是用户识别和状态管理，以纯文本的形式保存在客户端。

Cookie 分为两种：
- persistent cookie，设置有效期后保存在客户端硬盘中，也就是我们通常意义上所说的 cookie。
- session cookie，没有设置有效期且只保存在客户端内存中，浏览器关闭就会丢失。一般 sessionID 是借助于 seesion cookie 来和客户端交互的。

### 1.2. HTTP 首部字段

Cookie 在传输时以键值对的形式保存在 HTTP 报文的首部，利用 Set-Cookie 和 Cookie 这两个首部字段进行 B/S 交互。

#### 1.2.1. Set-Cookie

Set-Cookie：服务器告知客户端，在客户端本地保存该 Cookie。

格式：
```
Set-Cookie：[NAME]=[value]【; [Option 1]=[value]】【; [Option 2]=[value]……】
```

Cookie 选项（每个选项都规定了什么情况下应该进行 cookie 的交互）：
- `expires=DATE`
  - 指定 Cookie 的有效期（缺省值为直到浏览器关闭，即只加载到客户端内存中），过期后客户端将删除此 cookie。
  - DATE 格式：Wdy, DD-Mon-YYYY HH:MM:SS GMT。
  - **失效日期是以浏览器运行的电脑上的系统时间为基准进行核实的**，且没有任何办法来来验证这个系统时间是否和服务器的时间同步，所以当服务器时间和浏览器所处系统时间存在差异时这样的设置会出现错误。
- `domain=Domain`
  - 指定客户端 Cookie 可以发送到哪些域名（缺省值为创建 Cookie 的服务器域名），浏览器会把 domain 的值与请求的域名做一个尾部比较（即从字符串的尾部开始比较），并将匹配的 cookie 发送至服务器。
  - domain 选项的值必须是发送 Set-Cookie 消息头的主机名的一部分，例如不可在 google.com 上设置一个 cookie，因为这会产生安全问题。不合法的 domain 选择将直接被忽略。
  - 除针对具体指定多个域名发送 Cookie，不发送 domain 字段更加安全。
		`path=PATH`	
  - 指定了请求的资源 URL 中必须存在指定的路径时，才会发送 Cookie 消息头（缺省值是发送 Set-Cookie 消息头所对应的 URL 中的 path 部分）。
  - 通常是将 path 选项的值与请求的 URL 从头开始逐字符比较，如果字符匹配，则发送 Cookie 消息头。
  - 只有在 domain 选项核实完毕之后才会对 path 属性进行比较。
  - 有方法避开该限制，存在安全问题。
- `secure`
  - 要求仅在 SSL 或 https 通信时才会发送 cookie 至服务器。
  - **默认情况下，在 HTTPS 链接上传输的 cookie 都会被自动添加上 secure 选项**。
  - 事实上，机密且敏感的信息绝不应该在 cookie 中存储或传输，因为 cookie 的整个机制原本都是不安全的。
- `HttpOnly`
  - 使得 JavaScript 无法获取 cookie，以防止跨站脚本攻击（xss）对 cookie 信息的窃取（但该属性初衷不是针对 xss 开发的）。

#### 1.2.2. Cookie

Cookie：客户端向服务器发起请求时，若本地的 Cookie 未过期且没被禁止，会在每次请求时被发送至服务器，cookie 的值被存储在名为 Cookie 的 HTTP 消息头中，并且只包含了 cookie 的值，忽略全部设置选项。

格式：
```
Cookie: value
```
发送至服务器的 cookie 的值与通过 Set-Cookie 指定的值完全一样，不会有进一步的解析或转码操作。

如果请求中包含多个 cookie，它们将会被分号和空格分开：
```
Cookie: value1; value2; name1=value1
```
服务器端框架通常包含解析 cookie 的方法，可以通过编程的方式获取 cookie 的值。

若客户端存在多个 NAME 相同 value 不同的 cookie，发送时会全都发送，但会按照 domain-path-secure 的顺序，选项设置越详细的 cookie 越靠前。

### 1.3. 编码

[cookie 中文编码问题](http://yiminghe.iteye.com/blog/908141)

RFC2616 中规定：**HTTP 报文的状态行和头区域只能包含 ASCII(iso-8859-1) 编码的字符，再以 iso—8859-1 的编码方式转换为二进制 / 字节码在网络上传输；而 cookie 属于头区域，因此，cookie 编码必须使得编码后的字符在 ASCII 字符范围内**。

若内容全为英文字符，则符合编码规范（在 ASCII 字符范围内）。

若内容中包含了英文字符之外的字符（不在 ASCII 字符范围内），则需要经过其它编码以符合编码规范后，再存入 cookie 发送至客户端，到达客户端后，再进行解码（一般由客户端的 JavaScript 进行），常用的 cookie 编码方式有以下几种：

- base64

  服务器端（Java）：
  ```java
  (new BASE64Encoder()).encode(x.getBytes("utf-8"));// getBytes 得到使用 utf-8 编码的字节码
  ```
  客户端（JavaScript）：[base64_decode](http://www.webtoolkit.info/javascript-base64.html)

- URL

  服务器端（Java）：
  ```java
  String str = java.net.URLEncoder.encode(“xxxx”, “uft-8”);// 使用 utf-8，方便客户端 javascript 解码
  ```
  客户端（JavaScript）：[decodeURIComponent()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent)

- UNICODE

  由于 Java 与 Javascript 内部都是用 unicode 来表示字符，故可以直接使用 unicode 编码不在 ASCII 范围内的字符（如中文、日文等）。

  服务器端（JavaScript）：
  ```javascript
  static String unicode(char c) {  
          String str=Integer.toHexString((int)c);  
          while (str.length() < 4) {  
              str = "0" + str;  
          }  
          return "\\u" + str;  
  }
  ```
  客户端（JavaScript）：

  假设变量 v 的值为 `\\u6211`（编码后的），则常用的解码方式有：
  - `escape`：
    ```javascript
    unescape("\\u6211\\u6211".replace(/\\u([0-9]{4,5})/g,"%u$1"));  	
    ```
  - `eval`：
    ```javascript
    eval("'"+"\\u6211\\u6211"+"'")  
    ```
  - `json parser`：
    ```javascript
    JSON.parse('{"v":"'+"\\u6211\\u6211"+'"}').v;
    ```
  - `new Function`：
    ```javascript
    new Function("return '"+"\\u6211\\u6211"+"'")();  
    ```

  在实际应用当中，**几乎所有的服务器都对 cookie 进行 URL 编码**，对于 name=value 格式，通常会对 name 和 value 分别进行编码，而不对等号“=“进行编码操作。

### 1.4. Cookie 维护

#### 1.4.1. 设置 cookie

首先得明确一点：cookie 既可以由服务端来设置，也可以由客户端来设置。
- 服务端设置 cookie
  - 在服务端的 response header 中加上 set-cookie 字段，即可使客户端浏览器在本地设置和保存相应的 cookie 键值对；之后客户端向服务端特定路径的请求 header 都会带上 Cookies 字段，包含了由相应服务器在客户端设置的 cookie 键值对。
  - 一个 set-Cookie 字段只能设置一个 cookie，当你要想设置多个 cookie，需要添加同样多的 set-Cookie 字段。
  - 服务端可以设置 cookie 的所有选项：expires、domain、path、secure、HttpOnly。

- 客户端设置 cookie
  - 客户端通过 JavaScript 设置 cookie，如：
    ```javascript
    // 设置 cookie 键值，其它属性用默认值
    document.cookie = "name=Jonh; ";
    // 设置 cookie 的键值、expires、domain、path 属性
    document.cookie="age=12; expires=Thu, 26 Feb 2116 11:50:25 GMT; domain=sankuai.com; path=/";
    ```
  - 客户端可以设置 cookie 的下列选项：expires、domain、path、secure（有条件：只有在 https 协议的网页中，客户端设置 secure 类型的 cookie 才能成功），但无法设置 HttpOnly 选项。

#### 1.4.2. 修改 cookie

**Cookie 一旦在客户端设置成功后，无法从服务器端直接修改或删除，但可通过间接的方式，即修改 cookie**。

修改客户端 cookie：覆盖，即从服务器端发送一个除 value 值外完全相同的 cookie，将覆盖客户端对应的原有 cookie，达到修改 value 的目的。

注：用于覆盖的 cookie 除 value 外必须与目标 cookie 完全相同，否则会在客户端创建一个新的 cookie，请求时会将多个 NAME 相同 value 不同的 cookie 发送到服务器，造成混乱。

### 1.5. 限制

- 大小限制

  **大多数浏览器只支持发送最大为 4096 字节（4kB）的 Cookie**。

  由于限制了 Cookie 的大小，最好用 Cookie 来存储少量数据，或者存储用户 ID 之类的标识符。用户 ID 随后便可用于标识用户，以及从数据库或其他数据源中读取用户信息。

- 数量限制

  **大多数浏览器只允许每个站点存储 20 个 Cookie；如果试图存储更多 Cookie，则最旧的 Cookie 便会被丢弃。有些浏览器还会对它们将接受的来自所有站点的 Cookie 总数作出绝对限制，通常为 300 个**。

  在 IE7 中增加 cookie 的限制数量到 50 个，与此同时 Opera 限定 cookie 数量为 30 个，Safari 和 Chrome 对与每个域名下的 cookie 个数没有限制。

- subCookies

  鉴于 cookie 的数量存在限制，开发者提出 subcookies 的观点来增加 cookie 的存储量。Subcookies 是存储在一个 cookie 值中的多个 name-value 对，通常与以下格式类似：
  ```
  name=a=b&c=d&e=f&g=h
  ```
  这种方式允许在单个 cookie 中保存多个 name-value 对，而不会超出浏览器 cookie 数量的限制，但需要自定义解析方式来提取这些值，相比较而言更为复杂。很多服务器端框架已开始支持 subcookies 的存储。

### 1.6. 安全问题

- cookie 使用明文编码（如 URL 编码，Base64 编码等）传输，可能在传输过程中被劫持，可自定义加密算法以提高安全性。

- 客户端很容易篡改浏览器保存的 cookie。

  Cookie 防篡改方案举例：
  
  **服务器可以为每个 Cookie 项生成签名，由于用户篡改 Cookie 后无法生成对应的签名，服务器便可以得知用户对 Cookie 进行了篡改**。一个简单的校验过程可能是这样的：
  1. 在服务器中配置一个不为人知的字符串（我们叫它 Secret），比如：x$sfz32。
  1. 当服务器需要设置 Cookie 时（比如 authed=false），不仅设置 authed 的值为 false， 在值的后面进一步设置一个签名，最终设置的 Cookie 是 authed=false|6hTiBl7lVpd1P。
  1. 签名 6hTiBl7lVpd1P 是这样生成的：Hash('x$sfz32'+'true')。 要设置的值与 Secret 相加再取哈希。
  1. 用户收到 HTTP 响应并发现头字段 Set-Cookie: authed=false|6hTiBl7lVpd1P。
  1. 用户在发送 HTTP 请求时，篡改了 authed 值，设置头字段 Cookie: authed=true|???。 因为用户不知道 Secret，无法生成签名，只能随便填一个。
  1. 服务器收到 HTTP 请求，发现 Cookie: authed=true|???。服务器开始进行校验： Hash('true'+'x$sfz32')，便会发现用户提供的签名不正确。
  1. 通过给 Cookie 添加签名，使得服务器得以知道 Cookie 被篡改。
  
  **但因为 Cookie 是明文传输的，只要服务器设置过一次 authed=true|xxxx，客户端就知道 true 的签名是 xxxx 了，于是以后就可以用这个签名来欺骗服务器了**。

因此：
- **Cookie 始终无法保证绝对的安全，在 cookie 中不可存放敏感数据**。一般来讲 Cookie 中只会放一个 Session Id，而 Session 信息存储在服务器端。
- **为防止 XSS，一般都要在 cookie 中加入 httponly 属性，以禁止客户端使用 JavaScript 获取 cookie；同时加入 secure 属性，使得只在 https 下才使用 cookie**。

### 1.7. Cookie 传输优化

http://www.chinaz.com/web/2009/1012/94335.shtml

## 2. Session

### 2.1. 基本概念

**Session 是借 Cookie 实现的更高层的服务器与浏览器之间的会话**。

实现请求身份验证的方式很多，其中一种广泛接受的方式是使用服务器端产生的 Session ID 结合浏览器的 Cookie 实现对 Session 的管理。简单来说，一个请求到达的时候，服务器会先判断是否带有 Session 信息。如果有，则根据 Session ID 去数据库中查找是否具有对应的用户身份信息。此处可能会出现 Session 失效、非法的 Session 信息等可能性，那么服务器视同无 Ssession 信息的情况，重新的产生一个随机的字符串，并且在 Http 返回头中写入新的 Session ID 信息。另一者，如果服务器成功获取了用户的身份信息则以该身份为请求者提供服务。

Session 是存储在服务器端的，避免了在客户端 Cookie 中存储敏感数据。Session 可以存储在 HTTP 服务器的内存中，也可以存在内存数据库（如 redis）中，对于重量级的应用甚至可以存储在数据库中。

### 2.2. 生命周期

Session 生命周期：
- 创建：客户端首次访问服务器 jsp 页面 /servlet 时，服务器为当前会话创建一个 session 对象加载到服务器内存中，并将服务器引擎生成的唯一的 sessionID 告知客户端；之后在此会话中，客户端的每次请求都会携带 sessionID，从而在服务器上取得独有的会话信息。
- 活动：进行正常的 HTTP 通信。
- 死亡：session 被销毁的情况：
  - 服务器端调用 session.invalidate()，强制销毁 session。
  - 服务器关闭，内存被清空。
  - session 超时，即 session 的持有者（即客户端浏览器) 在最大无活动等待时间 (MaxInactiveInterval) 内无任何响应或请求（若客户端关闭了浏览器，客户端就主动结束了会话，但 session 仍旧存活在服务端，只不过再也没有客户端拥有对应的 sessionID 使用直至超时死亡）。

实例：存储在 Redis 中的 Session 管理过程：
1. 用户提交包含用户名和密码的表单，发送 HTTP 请求。
1. 服务器验证用户发来的用户名密码。
1. 如果正确则把当前用户名（通常是用户对象）存储到 redis 中，并生成它在 redis 中的 ID。
1. 这个 ID 称为 Session ID，通过 Session ID 可以从 Redis 中取出对应的用户对象， 敏感数据（比如 authed=true）都存储在这个用户对象中。
1. 设置 Cookie 为 sessionId=xxxxxx|checksum 并发送 HTTP 响应， 仍然为每一项 Cookie 都设置签名。
1. 用户收到 HTTP 响应后，便看不到任何敏感数据了。在此后的请求中发送该 Cookie 给服务器。
1. 服务器收到此后的 HTTP 请求后，发现 Cookie 中有 SessionID，进行防篡改验证。
1. 如果通过了验证，根据该 ID 从 Redis 中取出对应的用户对象， 查看该对象的状态并继续执行业务逻辑。

### 2.3. sessionID

- sessionID 的命名（默认情况，都可更改）：
  - 在 PHP 中：PHPSESSIONID
	- 在 JSP 中：JSESSIONID
	- 在 ASP.net 中：ASP.net_Sessionid

- 服务器与客户端交互 sessionID 的方法：

  - 通过 session cookie：以 cookie 的方式交互 sessionID，但此 cookie 只保存在客户端内存中，浏览器关闭即销毁，不存于硬盘；（但是客户端可能禁止了 cookie 使用）。

  - GET 方式 URL 重写（不安全）：
		- 一种是作为 URL 路径的附加信息，表现形式为 `http://...../xxx;jsessionid=ByD7...145788764`
		- 另一种是作为查询字符串附加在 URL 后面，表现形式为 `http://...../xxx?jsessionid=...ByD7...145788764`

  - POST 方式隐藏表单提交（有限制）：
    
    服务器会自动修改表单，添加一个隐藏字段，以便在表单提交时能够把 session id 传递回服务器。如：
    ```html
	  <form name="testform" action="/xxx">
    <input type="hidden" name="jsessionid" value="ByOK3vjFD75aPnrF7C2HmdnV6QZcEbzWoWiBYEnLerjQ99zWpBng!-145788764">
    <input type="text">
    </form>
    ```

### 2.4. 安全问题

SessionId 就如同请求者的身份证，一旦被攻击者恶意获得，攻击者便可以伪装成请求者对服务器发起请求，即会话劫持 (Session/Cookie Hijack)。

#### 2.4.1. Session 攻击

Session 常见的攻击方式有三种：

- 猜测 Session ID (Session Prediction)

  如果 Session ID 的长度、复杂度、杂乱度不够，就能够被攻击者猜测。攻击者只要不断暴力计算 Session ID，就有机会得到有效的 Session ID 而窃取使用者帐号。

  分析 Session ID 的工具可以用以下几种：OWASP WebScarab，Stompy，Burp Suite.

- 劫取 Session ID (Session Hijacking) 

  窃取 Session ID 是最常见的攻击手法。攻击者可以利用多种方式窃取 Cookie 获取 Session ID：
  - 跨站脚本攻击 ( Cross-Site Scripting (XSS) )：利用 XSS 漏洞窃取使用者 Cookie。
  - 网路窃听：使用 ARP Spoofing 等手法窃听网路封包获取 Cookie。
  - 透过 Referer 取得：若网站允许 Session ID 使用 URL 传递，便可能从 Referer 取得 Session ID。
  
  对于 Session 监听劫取的攻击，几种有效的防止办法是：
  - 禁止使用 URL (GET) 方式来传递 Session ID。
  
  - HTTPS
    
    很多网站仅仅在 Login 的阶段使用 Https 防止用户的用户名、密码信息被监听者获取，但是随后的 SessionId 同样有可能被监听者获取而伪造登录者的身份信息。因此更加推荐的方式是所有的信息传递全部使用 Https 实现，这样即使监听着截获了信息也无法破解其中的内容。
  
  - 设置 cookie 加强安全的属性：HttpOnly
    
    Express 在 options 中提供了 httpOnly 的属性，此属性默认值为 true，这个属性保证了 Cookie 的信息不能够通过 JavaScript 脚本获取。
  
  - 设置 cookie 加强安全的属性：Secure
    
    使得仅在 HTTPS/SSL 通信时才允许传递 cookie。

- 固定 Session ID (Session Fixation)

  攻击者诱使受害者使用特定的 Session ID 登入网站，而攻击者就能取得受害者的身分。
  
  流程：
  1. 攻击者从网站取得有效 Session ID。
  1. 使用社会工程等手法诱使受害者点选连结，使用该 Session ID 登入网站。
  1. 受害者输入帐号密码成功登入网站。
  1. 攻击者使用该 Session ID，操作受害者的帐号。

  防护措施：
  - 在使用者登入成功后，立即更换 Session ID，防止攻击者操控 Session ID 给予受害者。
  - 禁止将 Session ID 使用 URL (GET) 方式来传递。

#### 2.4.2. 防范措施

- 如果服务端单靠 sessionid 识别会话信息，那么一旦被窃取了 sessionid 后，就会泄露用户信息，因此**应该通过 IP，USERAGENT 信息、sessionID 三者结合加以校验，可以减少风险，提高安全性**。
- 防止 xss，一旦被拿到 xss，随时会被攻陷。
- HTTPS。
- cookie 安全属性：httponly 和 secure。

### 2.5. 限制

由于 session 存储在服务器端，只要服务器空间足够，session 信息没有大小限制。

## 3. Refer Links

[Cookie/Session 的机制与安全](http://harttle.com/2015/08/10/cookie-session.html)

[聊一聊 cookie](https://segmentfault.com/a/1190000004556040)

[HTTP cookies 详解](http://bubkoo.com/2014/04/21/http-cookies-explained/)

[Session 原理和 Tomcat 实现分析](http://www.blogjava.net/persister/archive/2010/08/24/329838.html)

[HTTP Session 攻击与防护](http://devco.re/blog/2014/06/03/http-session-protection/)
