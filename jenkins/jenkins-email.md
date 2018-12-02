```
Default Subject：构建通知:$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!

Default Content：

<hr/>

(本邮件是程序自动下发的，请勿回复！)<br/><hr/>

项目名称：$PROJECT_NAME<br/><hr/>

构建编号：$BUILD_NUMBER<br/><hr/>

svn版本号：${SVN_REVISION}<br/><hr/>

构建状态：$BUILD_STATUS<br/><hr/>

触发原因：${CAUSE}<br/><hr/>

构建日志地址：<a href="${BUILD_URL}console">${BUILD_URL}console</a><br/><hr/>

构建地址：<a href="$BUILD_URL">$BUILD_URL</a><br/><hr/>

变更集:${JELLY_SCRIPT,template="html"}<br/><hr/>

下面解释一下常用的属性。

全局属性详解
1. Override Global Settings：如果不选，该插件将使用默认的E-mail Notification通知选项。反之，您可以通过指定不同于( 默认选项)的设置来进行覆盖。

2. Default Content Type：指定构建后发送邮件内容的类型，有Text和HTML两种.

3. Use List-ID Email Header：为所有的邮件设置一个List-ID的邮件信头，这样你就可以在邮件客户端使用过滤。它也能阻止邮件发件人大部分的自动回复(诸如离开办公室、休假等等)。你可以使用你习惯的任何名称或者ID号，但是他们必须符合如下其中一种格式(真实的ID必须要包含在<和>标记里)：
<ci-notifications.company.org>
Build Notifications <ci-notifications.company.org>
“Build Notifications” <ci-notifications.company.org>
关于更详细的List-ID说明请参阅RFC-2919.

4. Add 'Precedence: bulk' Email Header：设置优先级,更详细说明请参阅RFC-3834.

5. Default Recipients：自定义默认电子邮件收件人列表。如果没有被项目配置覆盖,该插件会使用这个列表。您可以在项目配置使用$ DEFAULT_RECIPIENTS参数包括此默认列表，以及添加新的地址在项目级别。添加抄送：cc:电子邮件地址例如,CC:someone@somewhere.com

6. Reply To List：回复列表, A comma separated list of e-mail addresses to use in the Reply-To header of the email. This value will be available as $DEFAULT_REPLYTO in the project configuration.

7. Emergency reroute：如果这个字段不为空，所有的电子邮件将被单独发送到该地址（或地址列表）。

8. Excluded Committers：防止邮件被邮件系统认为是垃圾邮件,邮件列表应该没有扩展的账户名(如:@domain.com),并且使用逗号分隔

9. Default Subject：自定义邮件通知的默认主题名称。该选项能在邮件的主题字段中替换一些参数，这样你就可以在构建中包含指定的输出信息。

10. Maximum Attachment Size：邮件最大附件大小。

11. Default Content：自定义邮件通知的默认内容主体。该选项能在邮件的内容中替换一些参数，这样你就可以在构建中包含指定的输出信息。

12. Default Pre-send Script：默认发送前执行的脚本（注：grooy脚本，这是我在某篇文章上看到的，不一定准确）。

13. Enable Debug Mode：启用插件的调试模式。这将增加额外的日志输出，构建日志以及Jenkins的日志。在调试时是有用的，但不能用于生产。

14. Enable Security：启用时，会禁用发送脚本的能力，直接进入Jenkins实例。如果用户试图访问Jenkins管理对象实例，将抛出一个安全异常。

15. Content Token Reference：邮件中可以使用的变量，所有的变量都是可选的。具体介绍请查看全局邮件变量章节。

全局邮件变量

email-ext插件允许使用变量来动态插入数据到邮件的主题和内容主体中。变量是一个以$(美元符号)开始，并以空格结束的字符串。当一个邮件触发时，主题和内容主体字段的所有变量都会通过真实的值动态地替换。同样，变量中的“值”能包含其它的变量，都将被替换成真实的内容。

比如，项目配置页的默认主题和内容分别对应的是全局配置页面的DEFAULT_SUBJECT和DEFAULT_CONTENT，因此它会自动地使用全局的配置。同理，触发器中的Subject和Content分别对应的是项目配置页面的DEFAULT_SUBJECT和DEFAULT_CONTENT，所以它也会自动地使用项目的配置。由于变量中的“值”能包含其它的变量，所以就能为变量快速地创建不同的切入点：全局级别(所有项目)，专属级别(单一项目)，触发器级别(构建结果)。

如果你要查看所有可用的变量，你可以点击配置页的Content Token Reference的问号获取详细的信息。

所有的变量都是可选的，每个变量可以如下表示，字符串类型使用name=“value”，而布尔型和数字型使用name=value。如果{和}标记里面没有变量，则不会被解析。示例：$TOKEN,${TOKEN},${TOKEN,count=100},${ENV,var=”PATH”}

提示：用英文逗号分隔变量的参数。

下面我解释一下常用的属性。

 ${FILE,path="PATH"} 包括指定文件（路径）的含量相对于工作空间根目录。
path文件路径，注意：是工作区目录的相对路径。
 ${BUILD_NUMBER} 显示当前构建的编号。
 ${JOB_DESCRIPTION} 显示项目描述。
 ${SVN_REVISION} 显示svn版本号。还支持Subversion插件出口的SVN_REVISION_n版本。
 ${CAUSE} 显示谁、通过什么渠道触发这次构建。
 ${CHANGES } -显示上一次构建之后的变化。
showPaths 如果为 true,显示提交修改后的地址。默认false。
showDependencies 如果为true，显示项目构建依赖。默认为false
format 遍历提交信息，一个包含%X的字符串，其中%a表示作者，%d表示日期，%m表示消息，%p表示路径，%r表示版本。注意，并不是所有的版本系统都支持%d和%r。如果指定showPaths将被忽略。默认“[%a] %m\\n”。
pathFormat 一个包含“%p”的字符串，用来标示怎么打印路径。
 ${BUILD_ID}显示当前构建生成的ID。
 ${PROJECT_NAME} 显示项目的全名。（见AbstractProject.getFullDisplayName）
 ${PROJECT_DISPLAY_NAME} 显示项目的显示名称。（见AbstractProject.getDisplayName）
 ${SCRIPT} 从一个脚本生成自定义消息内容。自定义脚本应该放在"$JENKINS_HOME/email-templates"。当使用自定义脚本时会默认搜索$JENKINS_HOME/email-templatesdirectory目录。其他的目录将不会被搜索。
 script 当其使用的时候，仅仅只有最后一个值会被脚本使用（不能同时使用script和template）。
 template常规的simpletemplateengine格式模板。
 ${JENKINS_URL} 显示Jenkins服务器的url地址（你可以再系统配置页更改）。
 ${BUILD_LOG_MULTILINE_REGEX}按正则表达式匹配并显示构建日志。
 regex java.util.regex.Pattern 生成正则表达式匹配的构建日志。无默认值，可为空。
 maxMatches 匹配的最大数量。如果为0，将匹配所有。默认为0。
 showTruncatedLines 如果为true，包含[...truncated ### lines...]行。默认为true。
 substText 如果非空，就把这部分文字（而不是整行）插入该邮件。默认为空。
escapeHtml 如果为true，格式化HTML。默认为false。
 matchedSegmentHtmlStyle 如果非空，输出HTML。匹配的行数将变为<b style=”your-style-value”> html escaped matched line </b>格式。默认为空。
 ${BUILD_LOG} 显示最终构建日志。
 maxLines 日志最多显示的行数，默认250行。
 escapeHtml 如果为true，格式化HTML。默认false。
 ${PROJECT_URL} 显示项目的URL地址。
 ${BUILD_STATUS} -显示当前构建的状态(失败、成功等等)
 ${BUILD_URL} -显示当前构建的URL地址。
 ${CHANGES_SINCE_LAST_SUCCESS} -显示上一次成功构建之后的变化。
 reverse在顶部标示新近的构建。默认false。
 format遍历构建信息，一个包含%X的字符串，其中%c为所有的改变，%n为构建编号。默认”Changes for Build #%n\n%c\n”。
 showPaths,changesFormat,pathFormat分别定义如${CHANGES}的showPaths、format和pathFormat参数。
 ${CHANGES_SINCE_LAST_UNSTABLE} -显示显示上一次不稳固或者成功的构建之后的变化。
reverse在顶部标示新近的构建。默认false。
 format遍历构建信息，一个包含%X的字符串，其中%c为所有的改变，%n为构建编号。默认”Changes for Build #%n\n%c\n”。
 showPaths,changesFormat,pathFormat分别定义如${CHANGES}的showPaths、format和pathFormat参数。
 ${ENV} –显示一个环境变量。
 var– 显示该环境变量的名称。如果为空，显示所有，默认为空。
 ${FAILED_TESTS} -如果有失败的测试，显示这些失败的单元测试信息。
 ${JENKINS_URL} -显示Jenkins服务器的地址。(你能在“系统配置”页改变它)。
 ${HUDSON_URL} -不推荐，请使用$JENKINS_URL
 ${PROJECT_URL} -显示项目的URL。
 ${SVN_REVISION} -显示SVN的版本号。
 ${JELLY_SCRIPT} -从一个Jelly脚本模板中自定义消息内容。有两种模板可供配置：HTML和TEXT。你可以在$JENKINS_HOME/email-templates下自定义替换它。当使用自动义模板时，”template”参数的名称不包含“.jelly”。
 template模板名称，默认”html”。
 ${TEST_COUNTS} -显示测试的数量。
var– 默认“total”。
total -所有测试的数量。
 fail -失败测试的数量。
 skip -跳过测试的数量。
```
