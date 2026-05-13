import cv2
import numpy as np

class ImageValidator:
    @staticmethod
    def is_blurry(image, threshold=100):
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        laplacian_var = cv2.Laplacian(gray, cv2.CV_64F).var()
        return laplacian_var < threshold

    @staticmethod
    def get_brightness(image):
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        return np.mean(gray)

    @staticmethod
    def is_too_dark(image, threshold=50):
        return ImageValidator.get_brightness(image) < threshold

    @staticmethod
    def is_too_bright(image, threshold=200):
        return ImageValidator.get_brightness(image) > threshold