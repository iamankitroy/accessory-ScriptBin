#!/Users/roy/anaconda3/bin/python

# This script is used to apply NL-Means denoising on a image series
# Input: <TIF-file image series>
# Output: <TIF-file image series>

import sys
import numpy as np
from skimage import img_as_float, io
from skimage.restoration import denoise_nl_means, estimate_sigma

# Read input image file
def readImg(filename):
    img = img_as_float(io.imread(filename))
    return img

# Denoise image
def denoiseImg(img):
    sigma_est = np.mean(estimate_sigma(img, channel_axis=None))             # Estimate noise standard deviation

    # Apply NL-Means denoising
    denoise = denoise_nl_means(img, h=1.15 * sigma_est, fast_mode=False, patch_size=5, patch_distance=6)

    return denoise

# Main function
def main():
    px_bitsize = 16                         # pixel bit size

    filename = sys.argv[1]                  # image file name
    img = readImg(filename)                 # read image data
    cleaned_img = np.zeros(np.shape(img))   # store cleaned image

    # denoise every frame of timeseries
    for t in range(len(img)):
        denoise = denoiseImg(img[t])        # denoise frame
        cleaned_img[t] = denoise            # store denoised frame
        print(f"Frame {t} processed")       # progress
    
    # output file name
    outname = f"{'.'.join(filename.split('.')[:-1])}_cleaned.tif"
    io.imsave(outname, np.uint16(cleaned_img * (2**px_bitsize - 1)))

main()

# Ankit Roy
# 22nd November, 2022