import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # noqa

import argparse
import tensorflow as tf
import imageio
import numpy as np


def load_image(path):
    if not os.path.exists(path):
        print(f'File {args.input} does not exist!')
        exit(1)

    img = np.array(imageio.imread(path)).reshape((1, 28, 28)) / 255.0
    return tf.convert_to_tensor(img, tf.float32)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', type=str, required=True)
    parser.add_argument('--model-path', type=str,
                        required=False, default='/tmp/mnist_model/')
    args = parser.parse_args()

    print('Loading model from:', args.model_path)
    model = tf.saved_model.load(args.model_path)

    print('Loading image from:', args.input)
    img = load_image(args.input)

    label = np.argmax(model(img))
    print('\nPrediction:', label)
