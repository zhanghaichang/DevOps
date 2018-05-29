https://www.kubernetes.org.cn/2711.html


### 控制流（Flow Control）

Helm模板语言提供了如下控制结构：

if/else 条件语句
with 指定范围
range, 提供了“for each”-形式的循环
除此之外，Helm还提供了一些命名模板的行为：

define 模板内部定义一个命名模板
template 导入一个命名模板
block declares a special kind of fillable template area
IF/ELSE
