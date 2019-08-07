# Gzip
> nginx服务器的gzip压缩配置，主要是由ngx_http_gzip_module模块处理的9个指令实现的，负责Gzip功能的开启和设置，对响应的数据进行在线实时压缩.


```shell

gzip on;            #开启gzip功能
gzip_min_length  1024;      #响应页面数据上限
gzip_buffers     4 16k;         #缓存空间大小
gzip_http_version 1.1;      #http协议版本
gzip_comp_level  4;         #压缩级别4
gzip_types       text/plain application/x-javascript text/css application/xml text/javascript;
gzip_vary on;       #启用压缩标识
gzip_static on;     #开启文件预压缩

```



1. 配置指令详细注释

gzip on|off 开启或者关闭gzip功能
gzip_buffers 32 4k | 16 8k  默认值: gzip_buffers 4 4k/8k
设置系统获取几个单位的缓存用于存储gzip的压缩结果数据流。 例如 4 8k 代表以8k为单位的4倍申请内存。
gzip_comp_level 4  默认值：1(建议选择为4)
gzip压缩比/压缩级别，压缩级别 1-9，级别越高压缩率越大，当然压缩时间也就越长（比较消耗cpu）。
gzip_types mime-type ...   默认值: gzip_types text/html (默认不对js/css文件进行压缩)
一般情况下，在压缩常规文件时可以设置为：
gzip_types text/plain application/x-javascript text/css application/xml text/javascript;
注意: 图片/mp3这样的二进制文件,不必压缩。因为压缩率比较小, 比如100->80字节,而且压缩也是耗费CPU资源的。
gzip_min_length 1k   默认值: 0 ，不管页面多大都压缩
设置允许压缩的页面最小字节数，页面字节数从header头中的Content-Length中进行获取。建议设置成大于1k的字节数，小于1k可能会越压越大。
gzip_http_version 1.0|1.1  默认值: gzip_http_version 1.1(就是说对HTTP/1.1协议的请求才会进行gzip压缩)
注：99.99%的浏览器基本上都支持gzip解压了。但是假设我们使用的是默认值1.1，如果我们使用了proxy_pass进行反向代理，那么nginx和后端的upstream server之间是用HTTP/1.0协议通信的，如果我们使用nginx通过反向代理做Cache Server，而且前端的nginx没有开启gzip，同时，我们后端的nginx上没有设置gzip_http_version为1.0，那么Cache的url将不会进行gzip压缩
gzip_proxied [off|expired|no-cache|no-store|private|no_last_modified|no_etag|auth|any] ...默认值：off
Nginx作为反向代理的时候启用，开启或者关闭后端服务器返回的结果，匹配的前提是后端服务器必须要返回包含"Via"的 header头。
off - 关闭所有的代理结果数据的压缩
expired - 启用压缩，如果header头中包含 "Expires" 头信息
no-cache - 启用压缩，如果header头中包含 "Cache-Control:no-cache" 头信息
no-store - 启用压缩，如果header头中包含 "Cache-Control:no-store" 头信息
private - 启用压缩，如果header头中包含 "Cache-Control:private" 头信息
no_last_modified - 启用压缩,如果header头中不包含 "Last-Modified" 头信息
no_etag - 启用压缩 ,如果header头中不包含 "ETag" 头信息
auth - 启用压缩 , 如果header头中包含 "Authorization" 头信息
any - 无条件启用压缩
gzip_vary on | off
开启时，将带着  'Vary: Accept-Encoding'头域的响应头部，主要功能是告诉浏览器发送的数据经过了压缩处理。开启后的效果是在响应头部添加了Accept-Encoding: gzip，这对于本身不支持Gzip压缩的浏览器是有用的。
gzip_disable "MSIE [1-6]."  禁用IE6的gzip压缩
针对不同类型的浏览器发起的请求，选择性地开启或关闭Gzip功能，支持使用正则表达式。
gzip_static on|off
nginx对于静态文件的处理模块
该模块可以读取预先压缩的gz文件，这样可以减少每次请求进行gzip压缩的CPU资源消耗。该模块启用后，nginx首先检查是否存在请求静态文件的gz结尾的文件，如果有则直接返回该gz文件内容。为了要兼容不支持gzip的浏览器，启用gzip_static模块就必须同时保留原始静态文件和gz文件。这样的话，在有大量静态文件的情况下，将会大大增加磁盘空间。我们可以利用nginx的反向代理功能实现只保留gz文件。
