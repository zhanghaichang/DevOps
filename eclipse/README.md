# eclipse  JAVA注释模板

编辑注释模板的方法：`Window->Preference->Java->Code Style->Code Template` 然后展开Comments节点就是所有需设置注释的元素啦。现就每一个元素逐一介绍：

* 1.文件(Files)注释标签：

```
/**  
 * All rights Reserved, Designed By www.tydic.com
 * @Title:  ${file_name}   
 * @Package ${package_name}   
 * @Description:    ${todo}(用一句话描述该文件做什么)   
 * @author: 张海昌    
 * @date:   ${date} ${time}   
 * @version V1.0 
 * @Copyright: ${year} www.topcheer.com Inc. All rights reserved. 
 * 注意：本内容仅限于上海天正软件公司内部传阅，禁止外泄以及用于其他的商业目
 */

```

* 2.类型(Types)注释标签（类的注释）：

```
/**   
 * @ClassName:  ${type_name}   
 * @Description:${todo}(这里用一句话描述这个类的作用)   
 * @author: 张海昌
 * @date:   ${date} ${time}   
 *   
 * ${tags}  
 * @Copyright: ${year} www.tydic.com Inc. All rights reserved. 
 * 注意：本内容仅限于上海天正软件公司内部传阅，禁止外泄以及用于其他的商业目 
 */
```


* 3.字段(Fields)注释标签：

```
/**   
 * @Fields ${field} : ${todo}(用一句话描述这个变量表示什么)   
 */   
```


* 4.构造函数标签：
```
/**   
 * @Title:  ${enclosing_type}   
 * @Description:    ${todo}(这里用一句话描述这个方法的作用)   
 * @param:  ${tags}  
 * @throws   
 */

```

* 5.方法(Methods)标签：

```
/**   
 * @Title: ${enclosing_method}   
 * @Description: ${todo}(这里用一句话描述这个方法的作用)   
 * @param: ${tags}      
 * @return: ${return_type}      
 * @throws   
 */
 ```
 
* 6.覆盖方法(Overriding Methods)标签:
 
 ```
 /**   
 * <p>Title: ${enclosing_method}</p>   
 * <p>Description: </p>   
 * ${tags}   
 * ${see_to_overridden}   
 */
 ```
 
 
* 7.代表方法(Delegate Methods)标签：
 
 ```
 /**  
 * ${tags}  
 * ${see_to_target}  
 */  
 ```
 
* 8.getter方法标签：
 
 ```
 /**  
 * @Title:  ${enclosing_method} <BR>  
 * @Description: please write your description <BR>  
 * @return: ${field_type} <BR>  
 */  
 ```
* 9.setter方法标签：
 
 ```
 /**  
 * @Title:  ${enclosing_method} <BR>  
 * @Description: please write your description <BR>  
 * @return: ${field_type} <BR>  
 */  
 
 ```
