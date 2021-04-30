from __future__ import print_function, division
import numpy as np
import math

class LogisticRegression():
    """ Logistic Regression classifier.
    weight:
    -----------
    learning_rate: float
        The step length that will be taken when following the negative gradient during
        training.
    gradient_descent: boolean
        True or false depending if gradient descent should be used when training. If
        false then we use batch optimization by least squares.
    """
    def __init__(self, learning_rate=.1, gradient_descent=True):
        self.w = None
        self.learning_rate = learning_rate
        self.gradient_descent = gradient_descent

    def sigmoid(z):
        return 1.0 / (1.0 + np.exp(-z))

    def _initialize_weight(self, X):
        n_features = np.shape(X)[1]
        # Initialize weight between [-1/sqrt(N), 1/sqrt(N)]
        limit = 1 / math.sqrt(n_features)
        self.w = np.random.uniform(-limit, limit, (n_features,))

    def fit(self, X, y, n_iterations=4000):
        self._initialize_weight(X) #init weight
        # Tune weight for n iterations
        for i in range(n_iterations):
            # Make a new prediction
            y_pred = self.sigmoid(X.dot(self.w))
            if self.gradient_descent:
                # Move against the gradient of the loss function with
                # respect to the weight to minimize the loss
                grad_w = (y_pred - y).dot(X)
                self.w = self.w - self.learning_rate * grad_w

    def predict(self, X):
        y_pred = np.round(self.sigmoid(X.dot(self.w))).astype(int)
        return y_pred