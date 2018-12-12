# git flow

Git分布式的工作机制以及强大的分支功能使得在团队中推广使用没有受到什么阻碍。一直以来都是采用的分支管理模式，我把项目的开发分为三个阶段：开发、测试和上线。

# gitlab 分支管理策略

#### 开发阶段
除了master分支创建一个供所有开发人员开发的dev分支；

开发人员在dev分支上进行工作，随时随地commit，每天push一次到服务器；

push代码前需要进行pull操作，因为有可能在之前有别的成员先进行了push操作，如果有冲突还需要进行冲突解决；

每天上班后所有成员对dev进行pull操作，获取所有成员push的代码，有冲突需要解决；

团队Leader每天将dev合并一次到master。


#### 测试阶段
测试进入后就需要添加test分支；

在开发人员将代码push到dev分支后，可以在dev基础上创建test分支，测试人员以test分支搭建测试环境，开始测试；

开发人员在接受到bug后，直接在测试分支上修改，然后让测试人员进行验证；

每天团队Leader将测试分支上修改的bug合并到dev分支上，这样所有团队成员当天修复的bug都会在第二天被团队其他人pull下来；

团队Leader每天将dev合并一次到master。


#### 上线阶段
系统上线后试运行阶段会存在两种改动：bug和优化需求，bug通常当天解决晚上部署，优化需求通常周末部署；

bug当天能修复的就直接在test分支上修复，然后进行测试，验证通过后合并到master；

bug当天不能修复的就针对该bug创建一个分支，修复完后合并到test分支进行测试，验证通过后合并到master；

每个优化需求都以master分支为基础创建一个feature分支，完成后合并到dev分支，开发人员可以先交叉测试，然后将dev合并到test进行测试，验证通过后合并到master；

master始终是一个干净的，可发布的分支。

### gitlab Merge Request模式

一直以来，都觉得Merge Request模式遥不可及，只有做开源软件才会采用这种模式，没想到这么快就已经在团队中开始推行使用了，先看一张图来了解下Merge Request的开发流程：

http://blog.sina.com.cn/s/blog_185a4b04b0102xqdk.html


http://blog.sina.com.cn/s/blog_185a4b04b0102xqdk.html
