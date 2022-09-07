## markdown绘制flow流程图


基本语句：

> tag=>type: content:>url



tag就是元素名字，
type是这个元素的类型，有6中类型，分别为：

元素说明：

* 开始（椭圆形）：start
* 结束（椭圆形）：end
* 操作（矩形）：operation
* 多输出操作（矩形）：parallel
* 条件判断（菱形）：condition
* 输入输出（平行四边形）：inputoutput
* 预处理/子程序（圣旨形）：subroutine
* content就是在框框中要写的内容，注意type后的冒号与文本之间一定要有个空格。
* url是一个连接，与框框中的文本相绑定


关键字

* yes/true：condition类型变量连接时，用于分别表示yes条件的流向
* no/false：同上，表示否定条件的流向
* left/right：表示连线出口在节点位置（默认下面是出口，如op3），可以跟condition变量一起用：cond(yes,right)
* path1/path2/path3：parallel变量的三个出口路径（默认下面是出口）
节点状态

为节点设置不同的状态，可以通过不同的颜色显示，其中状态包括下面6个，含义如英文所示，

* past
* current
* future
* approved
* rejected
* invalid


```flow
st=>start: Start
e=>end: 需求变更备案
op1=>operation: 需求基线确定|past
op2=>operation: 内部需求变更|current
op3=>operation: 下一个版本|current
op4=>operation: 与客户协商需求变更|current
op5=>operation: 更新需求文档|current
op6=>operation: 通知项目组开发和测试|current
op7=>operation: 客户需求变更流程|current
 
 
 
cond1=>condition: 是否对实际业务产生影响
cond2=>condition: 是否接受当前版本变更
 
st->op1(right)->op1(right)->op2->cond1
cond1(no)->cond2
cond1(yes)->op4->op7
cond2(yes)->op5
cond2(no)->op3
op5->op6
op6->e
```
