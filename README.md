Computer Vision Feature Extraction Toolbox for Image Classification
-------------------------------------------------------------------

The goal of this toolbox is to simplify the process of feature extraction, of commonly used computer vision features such as HOG, SIFT, GIST and Color, for tasks related to image classification. 

In addition to providing some of the popular features, the toolbox has been designed for use with the ever increasing size of modern datasets - the processing is done in batches and is fully paralellized on a single machine, and can be easily distributed across multiple machines with a commmon file system (the standard cluster setup in many universities).

The provided code was used for feature extraction in the following papers:
 - <a href="http://undoingbias.csail.mit.edu">Undoing the Damage of Dataset Bias, ECCV 2012</a>
 - <a href="http://people.csail.mit.edu/khosla/projects/regionmem/">Memorability of Image Regions, NIPS 2012</a>
 - <a href="http://people.csail.mit.edu/khosla">Modifying the Memorability of Face Photographs, ICCV 2013</a>

Please cite a subset of the above papers when you use this code.

Disclaimer
----------

Questions and Comments
----------------------
If you have any feedback, please email <a href="http://people.csail.mit.edu/khosla">Aditya Khosla</a> at <a href="mailto:khosla@csail.mit.edu">khosla@csail.mit.edu</a>.

Reference
---------

Please cite our paper if you use this code:

    Undoing the Damage of Dataset Bias
    Aditya Khosla, Tinghui Zhou, Tomasz Malisiewicz, Alexei A. Efros, Antonio Torralba. 
    European Conference on Computer Vision (ECCV), 2012

<a href="http://people.csail.mit.edu/khosla/papers/eccv2012_khosla.pdf">[paper]</a> <a href="http://people.csail.mit.edu/khosla/bibtex/eccv2012.bib">[bibtex]</a> <a href="http://undoingbias.csail.mit.edu/">[project page]</a>

