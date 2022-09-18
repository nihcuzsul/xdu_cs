# -*- coding: utf-8 -*-
import pickle
from PCV.localdescriptors import sift
from PCV.imagesearch import imagesearch
from PCV.geometry import homography
from PCV.tools.imtools import get_imlist

# list of downloaded filenames
imlist = get_imlist("D:/corel/pic/0/")
for i in range(1,10):
    tmpimlist = get_imlist("D:/corel/pic/{}/".format(i))
    imlist.extend(tmpimlist)
nbr_images = len(imlist)

#获取特征列表
featlist = [imlist[i][:-3]+'sift' for i in range(nbr_images)]

#载入词汇
with open("D:/corel/pic/vocabulary500-10.pkl",  'rb') as f:
    voc = pickle.load(f)

src = imagesearch.Searcher('testImage2.db',voc)

# index of query image and number of results to return
#查询图像索引和查询返回的图像数
q_ind = 518
nbr_results = 10

# regular query
# 常规查询(按欧式距离对结果排序)

#imlist_bytes=[str.encode(imlist[i]) for i in range(nbr_images)]
res_reg = [w[1] for w in src.query(imlist[q_ind])[:nbr_results]]
print ('top matches (regular):', res_reg)

# load image features for query image
#载入查询图像特征
q_locs,q_descr = sift.read_features_from_file(featlist[q_ind])

# 显示查询结果
#常规
imagesearch.plot_results(src,res_reg[:nbr_results])
