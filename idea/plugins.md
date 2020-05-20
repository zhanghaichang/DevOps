# IDEA必备插件推荐

概览：

* IDE Features Trainer—IDEA交互式教程
* RestfulToolkit—RESTful服务开发
* Key Promoter X—快捷键
* Presentation Assistant—快捷键展示
* Codota—代码智能提示
* Alibaba Java Code Guidelines—阿里巴巴 Java 代码规范
* GsonFormat+RoboPOJOGenerator—JSON转类对象
* Statistic—项目信息统计
* Translation-必备的翻译插件
* CamelCase-多种命名格式之间切换


`注意：这只是第一弹，后面的文章中，我会继续推荐一些我在工作中必备的 IDEA 插件以及他们的使用方法。`


### IDE Features Trainer—IDEA交互式教程

有了这个插件之后，你可以在 IDE 中以交互方式学习IDEA最常用的快捷方式和最基本功能。 非常非常非常方便！强烈建议大家安装一个，尤其是刚开始使用IDEA的朋友。
当我们安装了这个插件之后，你会发现我们的IDEA 编辑器的右边多了一个“Learn”的选项，我们点击这个选项就可以看到如下界面。

我们选择“Editor Basics”进行，然后就可以看到如下界面，这样你就可以按照指示来练习了！非常不错！

### RestfulToolkit—RESTful服务开发
专为 RESTful 服务开发而设计的插件，有了它之后，你可以：
1.根据 URL 直接跳转到对应的方法定义 (Windows: ctrl+\ or ctrl+alt+n Mac:command+\ or command+alt+n )并且提供了一个 Services tree 的可视化显示窗口。 如下图所示:

2.作为一个简单的 http 请求工具来使用。

4.在请求方法上添加了有用功能: 复制生成 URL、复制方法参数...
我们选中的某个请求对应的方法然后右击，你会发现多了这样几个选项。我们选择Generate & Copy Full URL，这样你就把整个请求的路径复制下来了：http://localhost:9333/api/users?pageNum=1&pageSize=1 。

5.其他功能: java 类上添加 Convert to JSON 功能，格式化 json 数据 ( Windows: Ctrl + Enter; Mac: Command + Enter )。
我们选中的某个类对应的方法然后右击，你会发现多了这样几个选项。

当我们选择Convert to JSON的话，你会得到：
{
  "username": "demoData",
  "password": "demoData",
  "rememberMe": true
}
### Key Promoter X—快捷键
相信我！这一定是IDEA必备的一个插件。它的功能主要是在一些你本可以使用快捷键操作的地方提醒你用快捷键操作。 比如我直接点击tab栏下的菜单打开 Version Control(版本控制) 的话，这个插件就会提示我说你可以用快捷键 command+9或者shift+command+9打开，如下图所示：

除了这个很棒的功能之外，它还有一个功能我觉得非常棒，那就是展示出哪些快捷键你使用的次数最多！超级赞！！！
Guide哥：快捷键真的很重要！入职之后，每次看着同事们花里胡哨的快捷键操作，咔咔咔很快就完成了某个操作，我才深深意识到它的重要性。不夸张的说，你用IDEA开发，常用的快捷键不熟悉的话，效率至少降低 30%。

小伙，你使用快捷键进行操作的时候，是帅啊！但是，你给别人演示的时候，别人可能根本不知道你进行了什么快捷键操作。这个时候 Presentation Assistant 这个插件就站出来了！
Presentation Assistant—快捷键展示
安装这个插件之后，你用键盘快捷键所做的操作都会被展示出来，非常适合自己在录制视频或者给别人展示代码的时候使用。比如我使用快捷键 command+9打开 Version Control ，使用了这个插件之后的效果如下图所示：

### Codota—代码智能提示
Codota 这个插件用于智能代码补全，它基于数百万Java程序，能够根据程序上下文提示补全代码。相比于IDEA自带的智能提示来说，Codota 的提示更加全面一些,如下图所示。
我们创建线程池现在变成下面这样：

上面只是为了演示这个插件的强大，实际上创建线程池不推荐使用这种方式， 推荐使用 ThreadPoolExecutor 构造函数创建线程池。我下面要介绍的一个阿里巴巴的插件-Alibaba Java Code Guidelines 就检测出来了这个问题，所以，Executors下面用波浪线标记了出来。
除了，在写代码的时候智能提示之外。你还可以直接选中代码然后搜索相关代码示例。

Codota 还有一个在线网站，在这个网站上你可以根据代码关键字搜索相关代码示例，非常不错！我在工作中经常会用到，说实话确实给我带来了很大便利。网站地址：www.codota.com/code ，比如我们搜索 Files.readAllLines相关的代码，搜索出来的结果如下图所示：

Codota 插件的基础功能都是免费的。你的代码也不会被泄露，这点你不用担心。
Alibaba Java Code Guidelines—阿里巴巴 Java 代码规范
阿里巴巴 Java 代码规范，对应的Github地址为：github.com/alibaba/p3c 。非常推荐安装！
安装完成之后建议将与语言替换成中文，提示更加友好一点。

根据官方描述：

“
目前这个插件实现了开发手册中的的53条规则，大部分基于PMD实现，其中有4条规则基于IDEA实现，并且基于IDEA Inspection实现了实时检测功能。部分规则实现了Quick Fix功能，对于可以提供Quick Fix但没有提供的，我们会尽快实现，也欢迎有兴趣的同学加入进来一起努力。目前插件检测有两种模式：实时检测、手动触发。

上述提到的开发手册也就是在Java开发领域赫赫有名的《阿里巴巴Java开发手册》。
你还可以手动配置相关 inspection规则：

这个插件会实时检测出我们的代码不匹配它的规则的地方，并且会给出修改建议。比如我们按照下面的方式去创建线程池的话，这个插件就会帮我们检测出来,如下图所示。
img
这个可以对应上 《阿里巴巴Java开发手册》 这本书关于创建线程池的方式说明。

GsonFormat+RoboPOJOGenerator—JSON转类对象
这个插件可以根据Gson库使用的要求,将JSONObject格式的String 解析成实体类。
这个插件使用起来非常简单，我们新建一个类，然后在类中使用快捷键 option + s(Mac)或alt + s (win)调出操作窗口（必须在类中使用快捷键才有效），如下图所示。

这个插件是一个国人几年前写的，不过已经很久没有更新了，可能会因为IDEA的版本问题有一些小Bug。而且，这个插件无法将JSON转换为Kotlin（这个其实无关痛痒，IDEA自带的就有Java转Kotlin的功能）。

另外一个与之相似的插件是 ：RoboPOJOGenerator ，这个插件的更新频率比较快。
File-> new -> Generate POJO from JSON
复制代码
然后将JSON格式的数据粘贴进去之后，配置相关属性之后选择“Generate”

### Statistic—项目信息统计

有了这个插件之后你可以非常直观地看到你的项目中所有类型的文件的信息比如数量、大小等等，可以帮助你更好地了解你们的项目。

你还可以使用它看所有类的总行数、有效代码行数、注释行数、以及有效代码比重等等这些东西。

### Translation-必备的翻译插件
有了这个插件之后，你再也不用在编码的时候打开浏览器查找某个单词怎么拼写、某句英文注释什么意思了。
并且，这个插件支持多种翻译源：

Google 翻译
Youdao 翻译
Baidu 翻译

除了翻译功能之外还提供了语音朗读、单词本等实用功能。这个插件的Github地址是：github.com/YiiGuxing/T… （貌似是国人开发的，很赞）。
使用方法很简单！选中你要翻译的单词或者句子，使用快捷键 command+ctrl+u(mac) / shift+ctrl+y(win/linux) （如果你忘记了快捷的话，鼠标右键操作即可！）

如果需要快速打开翻译框，使用快捷键command+ctrl+i(mac)/ctrl + shift + o(win/linux)

如果你需要将某个重要的单词添加到生词本的话，只需要点击单词旁边的收藏按钮即可！
CamelCase-多种命名格式之间切换
非常有用！这个插件可以实现包含6种常见命名格式之间的切换。并且，你还可以对转换格式进行相关配置（转换格式），如下图所示：

有了这个插件之后，你只需要使用快捷键 shift+option+u(mac) / shift+alt+u 对准你要修改的变量或者方法名字，就能实现在多种格式之间切换了，如下图所示：

如果你突然忘记快捷键的话，可以直接在IDEA的菜单栏的 Edit 部分找到。

使用这个插件对开发效率提升高吗？拿我之前项目组的情况举个例子：
我之前有一个项目组的测试名字是驼峰这种形式:ShouldReturnTicketWhenRobotSaveBagGiven1LockersWith2FreeSpace 。但是，使用驼峰形式命名测试方法的名字不太明显，一般建议用下划线_的形式：should_return_ticket_when_robot_save_bag_given_1_lockers_with_2_free_space
如果我们不用这个插件，而是手动去一个一个改的话，工作量想必会很大，而且正确率也会因为手工的原因降低。



### Grep Console:控制台输出处理

可以说是必备的一个IDEA插件，非常实用！

这个插件主要的功能有两个：

* 1 自定义设置控制台输出颜色
我们可以在设置中进行相关的配置:

配置完成之后的 log warn 的效果对比图如下：

* 2 过滤控制台输出

### Rainbow Brackets:彩虹🌈括号

使用各种鲜明的颜色来展示你的括号，效果图如下。可以看出代码层级变得更加清晰了，可以说非常实用友好了！

###  Save Actions:优化保存操作

真必备插件！可以帮助我们在保存文件的时候：

优化导入；
格式化代码；
执行一些quick fix
......

这个插件是支持可配置的，我的配置如下：

实际使用效果如下：

### SequenceDiagram:一键生成时序图

同样是一个必备的一个IDEA插件，非常实用。我一般用它来生成简单的方法时序图，方便我们阅读代码，特别是在代码的调用层级比较多的时候。
使用方法很简单，选中方法名（注意不要选类名），然后点击鼠标右键，选择 Sequence Diagram 选项即可！

配置完一些基本的选项比如调用深度之后，我们点击ok即可！在上面这张图中我们已经生成了调用方法之间的时序图。

时序图生成完成之后，你可以选择导出为图片或者text文件，你还可以通过生成的时序图来定位到相关的代码，这对于我们阅读源码的时候尤其有帮助！

### Maven Helper:分析Maven项目的相关依赖

主要用来分析Maven项目的相关依赖，可以帮助我们解决Maven依赖冲突问题。

何为依赖冲突？
说白了就是你的项目使用的2个jar包引用了同一个依赖h，并且h的版本还不一样,这个时候你的项目就存在两个不同版本的 h。这时Maven会依据依赖路径最短优先原则，来决定使用哪个版本的Jar包，而另一个无用的Jar包则未被使用，这就是所谓的依赖冲突。
大部分情况下，依赖冲突可能并不会对系统造成什么异常，因为Maven始终选择了一个Jar包来使用。但是，不排除在某些特定条件下，会出现类似找不到类的异常，所以，只要存在依赖冲突，在我看来，最好还是解决掉，不要给系统留下隐患。

### EasyCode:一键帮你生成所需代码

Easycode 可以直接对数据的表生成entity、controller、service、dao、mapper无需任何编码，简单而强大。

更多内容可以查看这篇文章：《懒人 IDEA 插件插件:EasyCode 一键帮你生成所需代码~》

### CheckStyle:代码格式检查

这个插件的作用主要是为了规范代码格式比如说项目中一行代码最长是多少、项目中有没有无用的引用等等。非常实用！
一般情况下我们会在项目中配置 CheckStyle，并且自定义规则，然后再配置一个Commit 的 Git 钩子，这样我们在Commit代码的时候就会跑一遍 CheckStyle，看看项目代码的格式有问题不。
这个插件的作用主要是帮助我们定位问题，示例如下：
我们使用一个自定义的规则，然后运行 CheckStyle ，可以看到这个插件就帮我们找到有一个无用的 import。

### SonarLint:帮你优化代码

SonarLint 帮助你发现代码的错误和漏洞，就像是代码拼写检查器一样，SonarLint 可以实时显示出代码的问题，并提供清晰的修复指导，以便你提交代码之前就可以解决它们。

并且，很多项目都集成了 SonarQube,SonarLint 可以很方便地与 SonarQube 集成。

### Lombok:帮你简化代码

之前没有推荐这个插件的原因是觉得已经是人手必备的了。如果你要使用 Lombok 的话，不光是要安装这个插件，你的项目也要引入相关的依赖。

```xml
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
```
复制代码使用 Lombok 能够帮助我们少写很多代码比如 Getter/Setter、Constructor等等。
关于Lombok的使用，可以查看这篇文章：《十分钟搞懂Java效率工具Lombok使用与原理》。

### CodeGlance:代码微型地图

提供一个代码的微型地图，当你的类比较多的时候可以帮忙你快速定位到要去的位置。这个插件在我们日常做普通开发的时候用处不大，不过，在你阅读源码的时候还是很有用的，如下图所示：

### Java Stream Debugger:Java8 Stream调试器

Stream API 让你的代码更加优雅，但是有一个缺点是代码更难阅读和理解，没关系，这个插件应该可以帮助到你！

### Git Commit Template:使用模板创建commit信息

没有安装这个插件之前，我们使用IDEA提供的Commit功能提交代码是下面这样的：

使用了这个插件之后是下面这样的，提供了一个commit信息模板的输入框：

完成之后的效果是这样的：

### 其他常用插件推荐

* leetcode editor :提供在线 Leetcode 刷题功能，比较方便我们刷题，不过我试用之后发现有一些小 bug，个人感觉还是直接在网站找题目刷来的痛快一些。
* A Search with Github ：直接通过 Github搜索相关代码。
stackoverflow : 选中相关内容后单击右键即可快速跳转到 stackoverflow 。
* CodeStream ：让code review变得更加容易。
* Code screenshots ：代码片段保存为图片。
* activate-power-mode : 写代码的时候自带动画效果！
* GitToolBox :Git工具箱
* OK, Gradle! ：搜索Java库用于Gradle项目
