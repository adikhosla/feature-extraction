Computer Vision Feature Extraction Toolbox for Image Classification
-------------------------------------------------------------------

The goal of this toolbox is to simplify the process of feature extraction, of commonly used computer vision features such as HOG, SIFT, GIST and Color, for tasks related to image classification. The details of the included features are available in <a href="FEATURES.md">FEATURES.md</a>.

In addition to providing some of the popular features, the toolbox has been designed for use with the ever increasing size of modern datasets - the processing is done in batches and is fully parallelized on a single machine (using parfor), and can be easily distributed across multiple machines with a common file system (the standard cluster setup in many universities).

The features extracted in a bag-of-words manner ('color', 'hog2x2', 'hog3x3', 'sift', 'ssim') are encoded using Locality-Constrained Linear Coding to allow the use of a linear classifier for fast training + testing.

In my experients, I have found 'hog2x2' or 'hog3x3' to be most effective as global image features, and tend to perform even better when combined with 'color' features which contain complementary information.

The toolbox works on Matlab and Octave. Octave may still have some compatibility issues though and doesn't
support paralell processing.

Installation
------------
Before you can use the code, you need to download this repository and compile the mex code:

    $ git clone http://github.com/adikhosla/feature-extraction
    $ cd feature-extraction
    $ matlab
    >> compile
    
To the best of my knowledge, there should be no issues compiling on Linux, Mac or Windows.
Octave currently isn't able to compile, but most features should be working.

Basic usage
-----------

The basic usage is relatively simple:
    
    >> addpath(genpath('.'));
    >> datasets = {'pascal', 'sun'};                                     % specify name of datasets
    >> train_lists = {{'pascal1.jpg'}, {'sun1.jpg', 'sun2.jpg'}};        % specify lists of train images
    >> test_lists = {{'pascal2.jpg', 'pascal3.jpg'}, {'sun3.jpg'}};      % specify lists of test images
    >> feature = 'hog2x2';                                               % specify feature to use 
    >> c = conf();                                                       % load the config structure
    >> datasets_feature(datasets, train_lists, test_lists, feature, c);  % perform feature extraction
    >> train_features = load_feature(datasets{1}, feature, 'train', c);  % load train features of pascal
    >> test_features = load_feature(datasets{2}, feature, 'test', c);    % load test features of sun

The list of available features is: <pre>'color', 'gist', 'hog2x2', 'hog3x3', 'lbp', 'sift', 'ssim'</pre> 

Details are given <a href="FEATURES.md">here</a>. The <i>datasets_feature</i> function can be run on multiple machines in parallel to speed up feature extraction. This function handles the complete pipeline of building a dictionary (for bag-of-words features), coding features to the dictionary, and pooling them together in a spatial pyramid.

You can use a single or multiple datasets as shown above. A seperate folder will be created for each dataset and a different dictionary will be learned, unless specified otherwise in the <a href="#config-structure">configuration structure</a>.

Demo
----

There is a demo script provided in this code to extract color features on a provided set of train and test images. Then the features are used in a nearest neighbor classifier to predict the class of the test images.

    >> demo

The demo above will show the train and test images, and the nearest neighbors of the test images from the training set.

Config structure
----------------

There are various options available through the config structure created using the <i>conf()</i> function:
 - <b>cache</b>: main folder where all the files will be stored
 - <b>feature_config.(feature_name)</b>: contains the configuration of feature_name such as dictionary size
 - <b>batch_size</b>: batch size for feature processing (reduce for less RAM usage)
 - <b>cores</b>: specify number of cores to use for parfor (0 = use all)
 - <b>verbosity</b>: used to change how much is output to screen during feature computation (0 = low, 1 = high)
 - <b>common_dictionary</b>: used to share a common dictionary across datasets. Dictionary is learned using equal number of samples from each dataset (useful for ECCV 2012 paper).

Additional options are described in <i><a href="util/conf.m">conf.m</a></i>.

Bundled code
------------
There are functions or snippets of code included with or without modification from the following packages:
 - Feature coding: <a href="http://www.ifp.illinois.edu/~jyang29/codes/CVPR10-LLC.rar">Locality-constrained linear coding</a>
 - Pixelwise HOG/Gist: <a href="http://labelme.csail.mit.edu/LabelMeToolbox/LabelMeToolbox.zip">LabelMe Toolbox</a>
 - For color features: <a href="http://lear.inrialpes.fr/people/vandeweijer/code/ColorNaming.tar">Color Naming</a>
 - SIFT features: <a href="http://www.cs.illinois.edu/homes/slazebni/research/SpatialPyramid.zip">Spatial pyramid matching code</a>
 - LBP features: <a href="http://www.cse.oulu.fi/CMV/Downloads/LBPMatlab">LBP Matlab code</a>
 - SSIM: <a href="http://www.robots.ox.ac.uk/~vgg/software/SelfSimilarity/">VGG SSIM package</a>
 - <a href="http://cseweb.ucsd.edu/~elkan/fastkmeans.tar">Fast k-means</a>

Disclaimer
----------

Most of the features included in this toolbox have not been designed by me. I have either fine-tuned them or used them as is from existing work. This toolbox simply unifies existing code bases (which are credited in the <a href="#bundled-code">bundled code</a> section) in an easy to use architecture. I have done my best to highlight where different snippets of code originate from, but please do not hesitate to contact me if you find that I have missed anything. <b>Most importantly: please cite the <a href="FEATURES.md">original inventors</a> of the different features (in addition to a subset of the <a href="#reference">references</a> below) when you use this toolbox in your work.</b>

Reference
---------

The provided code was used for feature extraction in the following papers:
 - Aditya Khosla, Tinghui Zhou, Tomasz Malisiewicz, Alexei A. Efros, Antonio Torralba.
 <br><a href="http://undoingbias.csail.mit.edu">Undoing the Damage of Dataset Bias</a>, ECCV 2012

 - Aditya Khosla, Jianxiong Xiao, Antonio Torralba, Aude Oliva.
 <br><a href="http://people.csail.mit.edu/khosla/projects/regionmem/">Memorability of Image Regions</a>, NIPS 2012

 - Aditya Khosla, Wilma A. Bainbridge, Antonio Torralba, Aude Oliva. 
 <br><a href="http://people.csail.mit.edu/khosla">Modifying the Memorability of Face Photographs</a>, ICCV 2013

Please cite a subset of the above papers if you use this code.

Acknowledgements
----------------

I am extremely grateful to Oscar Beijbom, Hamed Pirsiavash and Tinghui Zhou for being the initial users of this toolbox, and providing useful comments and various bug-fixes.

Questions and Comments
----------------------
If you have any feedback, please email <a href="http://people.csail.mit.edu/khosla">Aditya Khosla</a> at <a href="mailto:khosla@csail.mit.edu">khosla@csail.mit.edu</a>.
