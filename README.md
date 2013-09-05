Feature Extraction Toolbox for Image Classification
---------------------------------------------------

The goal of this toolbox is to simplify the process of feature extraction, of commonly used computer vision features such as HOG, SIFT, GIST and Color, for tasks related to image classification. 

In addition to providing some of the popular features, the toolbox has been designed for use with the ever increasing size of modern datasets - the processing is done in batches and is fully parallelized on a single machine (using parfor), and can be easily distributed across multiple machines with a common file system (the standard cluster setup in many universities).

Details of included features
----------------------------

The following features are provided in this toolbox:
 - <b>Color</b>: 
 - <b>Gist</b>: 
 - <b>Dense HOG2x2, HOG3x3</b>: 
 - <b>LBP</b>: 
 - <b>Dense SIFT</b>:
 - <b>SSIM</b>:

Installation
------------
Before you can use the code, you need to download this repository and compile the mex code:

    $ git clone http://github.com/adikhosla/feature-extraction
    $ cd feature-extraction
    $ matlab
    >> compile
    
To the best of my knowledge, there should be no issues compiling on Linux, Mac or Windows.

Demo
----

There is a demo script provided in this code to extract color features on a provided set of train and test images. Then the features are used in a nearest neighbor classifier to classify the test images.

    >> demo

The demo above will show the train and test images, and the nearest neighbors of the test images from the training set.

Basic usage
-----------




Disclaimer
----------

Most of the features included in this toolbox have not been designed by me. I have either fine-tuned them or used them as is from existing work. This toolbox simply unifies existing code bases (which are credited in the bundled libraries section) in an easy to use architecture. I have done my best to highlight where different snippets of code originate from, but please do not hesitate to contact me if you find that I have missed anything. <b>Most importantly: please cite the original inventors of the different features when you use them in your work.</b>

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

Questions and Comments
----------------------
If you have any feedback, please email <a href="http://people.csail.mit.edu/khosla">Aditya Khosla</a> at <a href="mailto:khosla@csail.mit.edu">khosla@csail.mit.edu</a>.
