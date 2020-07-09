# Seata 分布式事务

> Seata 是一款开源的分布式事务解决方案，致力于提供高性能和简单易用的分布式事务服务。Seata 将为用户提供了 AT、TCC、SAGA 和 XA 事务模式，为用户打造一站式的分布式解决方案。

###  Seata术语

* TC - 事务协调者
  维护全局和分支事务的状态，驱动全局事务提交或回滚。

* TM - 事务管理器
  定义全局事务的范围：开始全局事务、提交或回滚全局事务。

* RM - 资源管理器
  管理分支事务处理的资源，与TC交谈以注册分支事务和报告分支事务的状态，并驱动分支事务提交或回滚。
  
<section class="content-section"><div class="sidemenu"><div class="sidemenu-toggle">
  
<h2>直接部署</h2>
<ol>
<li>
<p>在<a href="https://github.com/seata/seata/releases">RELEASE</a>页面下载相应版本并解压</p>
</li>
<li>
<p>直接启动</p>
</li>
</ol>
<p>在 Linux/Mac 下</p>
<pre><code class="language-bash">$ sh ./bin/seata-server.sh
</code></pre>
<p>在 Windows 下</p>
<pre><code class="language-cmd">bin\seata-server.bat
</code></pre>
<h3>支持的启动参数</h3>
<table>
<thead>
<tr>
<th style="text-align:left">参数</th>
<th style="text-align:left">全写</th>
<th style="text-align:left">作用</th>
<th style="text-align:left">备注</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left">-h</td>
<td style="text-align:left">--host</td>
<td style="text-align:left">指定在注册中心注册的 IP</td>
<td style="text-align:left">不指定时获取当前的 IP，外部访问部署在云环境和容器中的 server 建议指定</td>
</tr>
<tr>
<td style="text-align:left">-p</td>
<td style="text-align:left">--port</td>
<td style="text-align:left">指定 server 启动的端口</td>
<td style="text-align:left">默认为 8091</td>
</tr>
<tr>
<td style="text-align:left">-m</td>
<td style="text-align:left">--storeMode</td>
<td style="text-align:left">事务日志存储方式</td>
<td style="text-align:left">支持<code>file</code>和<code>db</code>，默认为 <code>file</code></td>
</tr>
<tr>
<td style="text-align:left">-n</td>
<td style="text-align:left">--serverNode</td>
<td style="text-align:left">用于指定seata-server节点ID</td>
<td style="text-align:left">,如 <code>1</code>,<code>2</code>,<code>3</code>..., 默认为 <code>1</code></td>
</tr>
<tr>
<td style="text-align:left">-e</td>
<td style="text-align:left">--seataEnv</td>
<td style="text-align:left">指定 seata-server 运行环境</td>
<td style="text-align:left">如 <code>dev</code>, <code>test</code> 等, 服务启动时会使用 <code>registry-dev.conf</code> 这样的配置</td>
</tr>
</tbody>
</table>
<p>如：</p>
<pre><code class="language-bash">$ sh ./bin/seata-server.sh -p 8091 -h 127.0.0.1 -m file
</code></pre>
<h2>容器部署</h2>
<p>容器部署当前支持三种方式：</p>
<ul>
<li>
<p><a href="/zh-cn/docs/ops/deploy-by-docker.html">使用 Docker / Docker Compose 部署 </a></p>
</li>
<li>
<p><a href="/zh-cn/docs/ops/deploy-by-kubernetes.html">使用 Kubernetes 部署 </a></p>
</li>
<li>
<p><a href="/zh-cn/docs/ops/deploy-by-helm.html">使用 Helm 部署</a></p>
</li>
</ul>
</div></section>
