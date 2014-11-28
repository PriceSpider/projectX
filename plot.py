import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm

flight_data = np.genfromtxt('FRA_MEL_trial2_timed.csv', delimiter=',')
n_data = len(flight_data)

price = np.zeros(n_data)
trip_length = np.zeros(n_data)
t_ahead = np.zeros(n_data)

for row in range(n_data):
   price[row] = flight_data[row][3]
   trip_length[row] = flight_data[row][4]
   t_ahead[row] = flight_data[row][5]
   
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.scatter(t_ahead, trip_length, price, c='r',marker='o')

ax.set_xlabel('t_ahead')
ax.set_ylabel('trip_length')
ax.set_zlabel('price')

plt.show()