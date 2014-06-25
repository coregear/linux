关于mysql的查询缓存

mysql> show global status like 'qcache%';  
+-------------------------+-----------+  
| Variable_name | Value |  
+-------------------------+-----------+  
| Qcache_free_blocks | 22756 |  
| Qcache_free_memory | 76764704 |  
| Qcache_hits | 213028692 |  
| Qcache_inserts | 208894227 |  
| Qcache_lowmem_prunes | 4010916 |  
| Qcache_not_cached | 13385031 |  
| Qcache_queries_in_cache | 43560 |  
| Qcache_total_blocks | 111212 |  
+-------------------------+-----------+ 
MySQL查询缓存变量解释：
Qcache_free_blocks：缓存中相邻内存块的个数。数目大说明可能有碎片。FLUSH QUERY CACHE会对缓存中的碎片进行整理，从而得到一个空闲块。
Qcache_free_memory：缓存中的空闲内存。
Qcache_hits：每次查询在缓存中命中时就增大
Qcache_inserts：每次插入一个查询时就增大。命中次数除以插入次数就是不中比率。
Qcache_lowmem_prunes：缓存出现内存不足并且必须要进行清理以便为更多查询提供空间的次数。这个数字最好长时间来看;如果这个数字在不断增长，就表示可能碎片非常严重，或者内存很少。(上面的 free_blocks和free_memory可以告诉您属于哪种情况)
Qcache_not_cached：不适合进行MySQL查询缓存变量，通常是由于这些查询不是 SELECT 语句或者用了now()之类的函数。
Qcache_queries_in_cache：当前缓存的查询(和响应)的数量。
Qcache_total_blocks：缓存中块的数量。
我们再查询一下服务器关于query_cache的配置：

mysql> show variables like 'query_cache%';  
+------------------------------+-----------+  
| Variable_name | Value |  
+------------------------------+-----------+  
| query_cache_limit | 2097152 |  
| query_cache_min_res_unit | 4096 |  
| query_cache_size | 203423744 |  
| query_cache_type | ON |  
| query_cache_wlock_invalidate | OFF |  
+------------------------------+-----------+ 
各字段的解释：
query_cache_limit：超过此大小的查询将不缓存
query_cache_min_res_unit：缓存块的最小大小
query_cache_size：查询缓存大小
query_cache_type：缓存类型，决定缓存什么样的查询，示例中表示不缓存 select sql_no_cache 查询
query_cache_wlock_invalidate：当有其他客户端正在对MyISAM表进行写操作时，如果查询在query cache中，是否返回cache结果还是等写操作完成再读表获取结果。
query_cache_min_res_unit的配置是一柄”双刃剑”，默认是4KB，设置值大对大数据查询有好处，但如果你的查询都是小数据查询，就容易造成内存碎片和浪费。
查询缓存碎片率 = Qcache_free_blocks / Qcache_total_blocks * 100%
如果查询缓存碎片率超过20%，可以用FLUSH QUERY CACHE整理缓存碎片，或者试试减小query_cache_min_res_unit，如果你的查询都是小数据量的话。
查询缓存利用率 = (query_cache_size - Qcache_free_memory) / query_cache_size * 100%
查询缓存利用率在25%以下的话说明query_cache_size设置的过大，可适当减小;查询缓存利用率在80%以上而且Qcache_lowmem_prunes > 50的话说明query_cache_size可能有点小，要不就是碎片太多。
查询缓存命中率 = (Qcache_hits - Qcache_inserts) / Qcache_hits * 100%
示例服务器 查询缓存碎片率 = 20.46%，查询缓存利用率 = 62.26%，查询缓存命中率 = 1.94%，命中率很差，可能写操作比较频繁吧，而且可能有些碎片。