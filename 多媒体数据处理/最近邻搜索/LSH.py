import numpy as np
import random
import heapq
import time


# 返回点的坐标的汉明编码
def Embedding(C, line):
    # C:坐标最大值，line:点的坐标
    string = []
    for element in line:
        for i in range(element):
            string.append("1")
        for j in range(C - element):
            string.append("0")
    return string


# 生成哈希索引表
def set_table(H, C, B, data):
    # H：生成的k个随机数，C：取到的最大值，B：桶的最大数量
    # data：处理过的数据集
    table = {}
    f = {}
    for i, line in enumerate(data):
        pi = []
        # var是汉明编码
        var = ''.join(Embedding(C, line))
        # 取汉明编码的H对应位
        for j in H:
            pi.append(var[j])
        # f字典用于记录每个哈希桶包含的行数，小于B则+1
        if (''.join(pi)) in f:
            if f[''.join(pi)] < B:
                f[''.join(pi)] += 1
                table[i] = ''.join(pi)
        else:
            f[''.join(pi)] = 1
            table[i] = ''.join(pi)
    return table

#n*C的范围内生成k个随机数，存入表H
def set_H(Cn, k):
    H = []
    for i in range(k):
        H.append(random.randint(0, Cn - 1))
    H.sort()
    return H


# 求line的LSH最邻近点
def search(Hlist, tblist, var):
    # var：一行的汉明编码
    # 返回该行的所有匹配点（有重复项）
    keys = []
    # 用Hlist的每个H求对应位组合
    for i, h in enumerate(Hlist):
        p = []
        for hi in h:
            p.append(var[hi])
        # 寻找所以哈希相同的点
        for key, value in tblist[i].items():
            if value == ''.join(p):
                keys.append(key)
    return keys


def LSH(line, Hlist, tblist):
    array = line
    var = ''.join(Embedding(C, array))
    # keys是求得的最邻近点
    keys = search(Hlist, tblist, var)
    keys.sort()
    # 按照出现的次数从大到小排序，去除重复项
    set1 = set(keys)
    dict01 = {item: keys.count(item) for item in set1}
    sorted_x = sorted(dict01.items(), key=lambda x: x[1], reverse=True)
    keys = []
    num = 0
    for i, n in sorted_x:
        keys.append(i)
        num += 1
    return keys


def distance(line1, line2):
    dist = np.linalg.norm(line1 - line2)
    return dist


# 暴力搜索获得最近邻
def mindistancedata(linenum, data):
    dist = []
    for i, line in enumerate(data):
        dist.append(distance(data[linenum], data[i]))
    min_index_list = map(dist.index, heapq.nsmallest(10, dist))
    return list(min_index_list)


# LSH搜索获得近似最近邻
def mindistance(linenum, data, linelist):
    min_index_list = []
    dist = {}
    for i in linelist:
        dist[i] = distance(data[linenum], data[i])
    L = sorted(dist.items(), key=lambda item: item[1])
    for i in range(10):
        min_index_list.append(L[i][0])
    return min_index_list


# 数据预处理，乘上10的平方取整
bit = 2
odata = data = np.loadtxt('D:/corel/corel', usecols=range(1, 33), unpack=False)
data = np.loadtxt('D:/corel/corel', usecols=range(1, 33), unpack=False)
data = data * (10 ** bit)
data = data.astype(np.int)
k = input("input K:")
k = int(k)
L = input("input L:")
L = int(L)
B = input("input B:")
B = int(B)
# 最大值C 数据维数n
C = int(np.max(data) + 1)
n = data.shape[1]
hamming_code = []
Cn = C * n
Hlist = []
tblist = []

# 创建索引
for i in range(L):
    H = set_H(Cn, k)
    Hlist.append(H)
    tblist.append(set_table(H, C, B, data))
    print("创建索引哈希表： " + str(i))

while (True):
    true = []
    my = []
    #对前1000行的点进行最邻近搜索
    linenum = 1000

    # 暴力搜索，存入true
    for i in range(linenum):
        trueindex = []
        trueindex = mindistancedata(i, odata)
        true.append(trueindex)
    time_start = time.time()
    tinm = 0
    mint = 0

    # LSH索引搜索，记录正确匹配的点数
    for i in range(linenum):
        myindex = []
        line = data[i]
        keys = LSH(line, Hlist, tblist)
        myindex = mindistance(i, odata, keys)
        for ni in range(10):
            if true[i][ni] in myindex:
                tinm += 1
    time_end = time.time()
    # 输出结果
    print("K=" + str(k) + ",L=" + str(L) + "B=" + str(B))
    print("召回率" + str(tinm / linenum / 10))
    print("准确率" + str(1 - (linenum * 10 - tinm) * 2 / linenum / 68040))
    print('time cost', time_end - time_start, 's')
