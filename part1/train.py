import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # noqa

import argparse
import tensorflow as tf


def load_mnist_data():
    mnist = tf.keras.datasets.mnist

    (x_train, y_train), (x_test, y_test) = mnist.load_data()
    x_train, x_test = x_train / 255.0, x_test / 255.0

    return (x_train, y_train), (x_test, y_test)


def train_mnist_model(epochs):
    (x_train, y_train), (x_test, y_test) = load_mnist_data()

    model = tf.keras.models.Sequential([
        tf.keras.layers.Flatten(input_shape=(28, 28)),
        tf.keras.layers.Dense(128, activation='relu'),
        tf.keras.layers.Dropout(0.2),
        tf.keras.layers.Dense(10)
    ])

    predictions = model(x_train[:1]).numpy()

    loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
    loss_fn(y_train[:1], predictions).numpy()

    model.compile(optimizer='adam', loss=loss_fn, metrics=['accuracy'])

    model.fit(x_train, y_train, epochs=epochs)
    model.evaluate(x_test,  y_test, verbose=2)

    return model


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--model-path', type=str,
                        required=False, default='/tmp/mnist_model/')
    parser.add_argument('--epochs', type=int, required=False, default=2)
    args = parser.parse_args()

    print('Training MNIST model')
    model = train_mnist_model(epochs=args.epochs)

    print('Saving model to', args.model_path)
    tf.saved_model.save(model, args.model_path)
