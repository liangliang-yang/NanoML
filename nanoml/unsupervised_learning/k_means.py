# https://www.askpython.com/python/examples/k-means-clustering-from-scratch

# Step 1. Randomly pick k data points as our initial Centroids.

# Step 2. Find the distance (Euclidean distance for our purpose) between each data points in our training set with the k centroids.

# Step 3. Now assign each data point to the closest centroid according to the distance found.

# Step 4. Update centroid location by taking the average of the points in each cluster group.

# Step 5. Repeat the Steps 2 to 4 till our centroids don’t change.

# We can choose optimal value of K (Number of Clusters) using methods like the The Elbow method.

# 这个容易写 !!!!
# https://pythonprogramming.net/k-means-from-scratch-2-machine-learning-tutorial/?completed=/k-means-from-scratch-machine-learning-tutorial/

class K_Means:
    def __init__(self, k=2, max_iter=300):
        self.k = k
        self.max_iter = max_iter

    def fit(self, X):

        self.centroids = {}

        for i in range(self.k):
            self.centroids[i] = X[i]

        for i in range(self.max_iter):
            self.classes = {}

            for i in range(self.k):
                self.classes[i] = []

            # iterate each data to assign class
            for xi in X:
                # using linalg.norm() to find Euclidean distance: np.linalg.norm(point1 - point2)
                distances = [np.linalg.norm(xi-self.centroids[centroid]) for centroid in self.centroids]

                # find the closed centroid, assign as class
                c = np.argmin(distances)
                self.classes[c].append(xi)

            # update the centroids based on new classes
            for c in self.classes:
                self.centroids[c] = np.mean(self.classes[c],axis=0)


    def predict(self, new_X):
        distances = [np.linalg.norm(new_X-self.centroids[centroid]) for centroid in self.centroids]
        c = np.argmin(distances)
        return c

