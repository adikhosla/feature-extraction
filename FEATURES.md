Details of included features
----------------------------

The following features are provided in this toolbox:
 - <b>Color</b>: Convert the image to color names [1,12] and extract dense overlapping patches of multiple sizes in the form of a histogram of color names. Then apply the bag-of-words + spatial pyramid pipeline explained below.
 - <b>Gist</b>: GIST descriptor describing the spatial envelope of the image [10]
 - <b>Dense HOG2x2, HOG3x3</b>: Extract HOG [9] in a dense manner (i.e. on a grid) [3] and concatenate 2x2 or 3x3 cells to obtain a descriptor at each grid location. Then apply the bag-of-words + spatial pyramid pipeline explained below. This feature is also used in [11].
 - <b>LBP</b>: Extract non-uniform Local Binary Pattern [8] descriptor (neighborhood: 8, transitions: 2), and concatenate 3 levels of spatial pyramid to obtain final feature vector.
 - <b>Dense SIFT</b>: Extract SIFT [5] descriptor in a dense manner (i.e. on a grid) at multiple patch sizes, and then apply the bag-of-words + spatial pyramid pipeline explained below.
 - <b>SSIM</b>: Extract Self-Similarity Image Matching [7] descriptor in a dense manner and apply the bag-of-words + spatial pyramid pipeline to obtain the final feature vector.

Bag-of-words pipeline: using a random sampling of the extracted features from various patches, learn a dictionary using k-means [2], and apply locality-constrained linear coding (LLC) [6] to soft-encode each patch to a some dictionary entries. Then, as shown in [6], we apply max pooling with a spatial pyramid [4] to obtain the final feature vector. We use LLC as it allows the use of a linear classifier for classification instead of using non-linear kernels.

The feature configurations can be accessed through the <i>conf</i> structure: <i>c.feature_config.(feature_name)</i>, where <i>feature_name</i> is one of the following:
<pre>'color', 'gist', 'hog2x2', 'hog3x3', 'lbp', 'sift', 'ssim'</pre> 

For the features using bag-of-words, some important feature configurations to consider are <i>pyramid_levels</i> and <i>dictionary_size</i>.

References
----------

[1] J. van de Weijer, C. Schmid, J. Verbeek Learning Color Names from Real-World Images, CVPR 2007<br/>
[2] C. Elkan, Using the Triangle Inequality to Accelerate k-Means<br/>
[3] B. C. Russell, A. Torralba, K. P. Murphy, W. T. Freeman, LabelMe: a database and web-based tool for image annotation, IJCV 2008<br/>
[4] S. Lazebnik, C. Schmid, and J. Ponce, Beyond Bags of Features: Spatial Pyramid Matching for Recognizing Natural Scene Categories, CVPR 2006<br/>
[5] D. Lowe, Distinctive image features from scale-invariant keypoints, IJCV 2004<br/>
[6] J. Wang, J. Yang, K. Yu, F. Lv, T. Huang, Y. Gong, Locality-constrained linear coding for image classification, CVPR 2010<br/>
[7] E. Shechtman, M. Irani, Matching Local Self-Similarities across Images and Videos, CVPR 2007<br/>
[8] T. Ojala, M. Pietikäinen, T. Mäenpää, Multiresolution gray-scale and rotation invariant texture classification with Local Binary Patterns, PAMI 2002<br/>
[9] N. Dalal, B. Triggs, Histograms of oriented gradients for human detection, CVPR 2005<br/>
[10] A. Oliva, A. Torralba, Modeling the shape of the scene: a holistic representation of the spatial envelope, IJCV 2001<br/>
[11] J. Xiao, J. Hays, K. Ehinger, A. Oliva, A. Torralba, SUN database: Large-scale scene recognition from abbey to zoo, CVPR 2010<br/>
[12] R. Khan, J. van de Weijer, F. Khan, D. Muselet, C. Ducottet, C. Barat, Discriminative Color Descriptors, CVPR 2013<br/>
