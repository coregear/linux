#nginx的location匹配

# 匹配类型
~ #波浪线表示执行一个正则匹配，区分大小写
~* #表示执行一个正则匹配，不区分大小写
^~ #^~表示普通字符匹配，如果该选项匹配，只匹配该选项，不匹配别的选项，一般用来匹配目录
= #进行普通字符精确匹配
@ #"@" 定义一个命名的 location，使用在内部定向时，例如 error_page, try_files

# 匹配优先级

1  = 精确匹配,优先级最高。如果发现精确匹配，nginx不再尝试他匹配。

2  ^~普通字符匹配,一旦匹配到指定的字符就不再尝试匹配其他location，优先级高于等效的正则匹配

3  ~和~* 正则表达式匹配，后边跟的必须是正则表达式。如果找到相应的匹配，则nginx停止搜索其他匹配；多个正则表达式都匹配的话按照location出现的先后顺序匹配。

4  不带^标记的普通字符匹配，【也就是location /image/这样的】优先级最低。当没有正则表达式或者没有正则表达式被匹配的情况下，那么匹配程度最高的逐字匹配指令会被使用。

5  也就是,=最高，其次是带^的普通字符匹配，然后是正则，最后才是普通的字符匹配。正则跟正则之间，先被读取的生效，字符与字符之间，匹配度最高的，也就是最长匹配生效。

#举例说明匹配顺序

location  = / {
  # 只匹配"/".
  [ configuration A ] 
}
location  / {
  # 匹配任何请求，因为所有请求都是以"/"开始
  # 但是更长字符匹配或者正则表达式匹配会优先匹配
  [ configuration B ] 
}
location ^~ /images/ {
  # 匹配任何以 /images/ 开始的请求，并停止匹配 其它location
  [ configuration C ] 
}
location ~* \.(gif|jpg|jpeg)$ {
  # 匹配以 gif, jpg, or jpeg结尾的请求. 
  # 但是所有 /images/ 目录的请求将由 [Configuration C]处理.   
  [ configuration D ] 
}

/ -> 符合configuration A
/documents/document.html -> 符合configuration B
/images/1.gif -> 符合configuration C
/documents/1.jpg ->符合 configuration D

# @location

error_page 404 = @fetch;

location @fetch(
proxy_pass http://fetch;
)
