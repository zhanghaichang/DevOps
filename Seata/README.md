<section class="content-section"><div class="sidemenu"><div class="sidemenu-toggle"><img src="https://img.alicdn.com/tfs/TB1E6apXHGYBuNjy0FoXXciBFXa-200-200.png"></div><ul><li class="menu-item menu-item-level-1"><span>概述</span><ul><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/overview/what-is-seata.html" target="_self">Seata 是什么？</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/overview/terminology.html" target="_self">术语表</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/overview/faq.html" target="_self">FAQ</a></li></ul></li><li class="menu-item menu-item-level-1"><span>用户文档</span><ul><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/quickstart.html" target="_self">快速启动</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/saga.html" target="_self">Saga 模式</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/configurations.html" target="_self">参数配置</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/transaction-group.html" target="_self">事务分组介绍</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/spring.html" target="_self">Spring 支持</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/api.html" target="_self">API 支持</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/microservice.html" target="_self">微服务框架支持</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/ormframework.html" target="_self">ORM 框架支持</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/user/datasource.html" target="_self">数据源类型支持</a></li></ul></li><li class="menu-item menu-item-level-1"><span>开发者指南</span><ul><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><span><!-- react-text: 69 -->各事务模式<!-- /react-text --><img class="menu-toggle" src="https://img.alicdn.com/tfs/TB15.Ilw2b2gK0jSZK9XXaEgFXa-26-16.png" style="transform: rotate(-90deg);"></span><ul><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/dev/mode/at-mode.html" target="_self">Seata AT 模式</a></li><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/dev/mode/tcc-mode.html" target="_self">Seata TCC 模式</a></li><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/dev/mode/saga-mode.html" target="_self">Seata Saga 模式</a></li></ul></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/dev/seata-mertics.html" target="_self">Metrics设计</a></li></ul></li><li class="menu-item menu-item-level-1"><span>运维指南</span><ul><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/ops/upgrade.html" target="_self">版本升级指南</a></li><li class="menu-item menu-item-level-2" style="height: 36px; overflow: hidden;"><a href="/zh-cn/docs/ops/operation.html" target="_self">Metrics配置</a></li><li class="menu-item menu-item-level-2" style="height: 252px; overflow: hidden;"><span><!-- react-text: 89 -->部署<!-- /react-text --><img class="menu-toggle" src="https://img.alicdn.com/tfs/TB15.Ilw2b2gK0jSZK9XXaEgFXa-26-16.png" style="transform: rotate(0deg);"></span><ul><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/ops/deploy-guide-beginner.html" target="_self">新人文档</a></li><li class="menu-item menu-item-level-3 menu-item-selected"><a href="/zh-cn/docs/ops/deploy-server.html" target="_self">直接部署</a></li><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/ops/deploy-by-docker.html" target="_self">Docker部署</a></li><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/ops/deploy-by-kubernetes.html" target="_self">Kubernetes部署</a></li><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/ops/deploy-by-helm.html" target="_self">Helm 部署</a></li><li class="menu-item menu-item-level-3"><a href="/zh-cn/docs/ops/deploy-ha.html" target="_self">高可用部署</a></li></ul></li></ul></li></ul></div><div class="doc-content markdown-body"><h1>部署 Server</h1>
<p>Server支持多种方式部署：直接部署，使用 Docker, 使用 Docker-Compose, 使用 Kubernetes,  使用 Helm.</p>
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
