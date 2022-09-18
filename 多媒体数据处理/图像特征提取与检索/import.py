# -*- coding: utf-8 -*-
import pickle
from PCV.imagesearch import imagesearch
from PCV.localdescriptors import sift
from sqlite3 import dbapi2 as sqlite
from PCV.tools.imtools import get_imlist

# list of downloaded filenames
imlist = get_imlist("D:/corel/pic/0/")
for i in range(1,10):
    tmpimlist = get_imlist("D:/corel/pic/{}/".format(i))
    imlist.extend(tmpimlist)
nbr_images = len(imlist)

#获取特征列表
featlist = [imlist[i][:-3]+'sift' for i in range(nbr_images)]

# load vocabulary
#载入词汇
with open("D:/corel/pic/vocabulary500-10.pkl",  'rb') as f:
    voc = pickle.load(f)
#创建索引
indx = imagesearch.Indexer('testImage2.db',voc)
indx.create_tables()
#遍历所有的图像，并将它们的特征投影到词汇上
for i in range(nbr_images)[:1000]:#1000是因为有1000张图片
    locs,descr = sift.read_features_from_file(featlist[i])
    indx.add_to_index(imlist[i],descr)
# commit to database
#提交到数据库
indx.db_commit()

con = sqlite.connect('testImage.db')
print (con.execute('select count (filename) from imlist').fetchone())
print (con.execute('select * from imlist').fetchone())
