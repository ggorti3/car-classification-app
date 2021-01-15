# car-classification-app
iOS app for classifying make and model of vehicles from images

# About
Uses a neural network to accurately classify images of cars by make and model. The current version only works for Hondas and Toyotas.

# Dataset

This app uses a dataset which I created by scraping images from the internet. I wrote scripts and downloaded over a million images from sites where users would upload images of a car along with its make and model. Therefore, the images were already labelled in a sense, but I still had to manually check each label and verify if it was correct -- users would often post images and label them as a certain vehicle make and model that was entirely incorrect. Due to the tediousness of verifying these labels, I stopped after verifying labels for Hondas and Toyotas, two of the largest makes in the dataset. This seemed like a good way to test a general proof-of-concept for this project without spending months relabelling data.

Once the dataset was sufficiently prepared, I then fed each image into an object detection network that I trained to only detect cars. Then, I cropped the image to only include the largest car in the image before feeding into my classification network. According to [[1]](#1), this procedure significantly boosts accuracy of classification.

# Installation
Currently, the only way to use the app is to clone this repository in xcode then download onto a device.

# Usage
Take pictures of a car, or choose a picture from your library.

<img src="./sample_images/IMG_4089.PNG" width="250">

Then, crop the box around the car.

<img src="./sample_images/IMG_4091.PNG" width="250">

The app will then predict make and model of the car with confidence scores.

<img src="./sample_images/IMG_4092.PNG" width="250">

# References 
<a id="1">[1]</a> 
Satar, Burak, and Ahmet Emir Dirik. "Deep Learning Based Vehicle Make-Model Classification." International Conference on Artificial Neural Networks. Springer, Cham, 2018.
