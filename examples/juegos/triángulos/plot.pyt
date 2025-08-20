#!/usr/bin/env python3

import matplotlib
import matplotlib.pyplot as plt

matplotlib.use('pdf')

# Create a figure containing a single Axes
fig, ax = plt.subplots()
ax.set_xticks([])
ax.set_yticks([])

# plot fixed dots
ax.scatter(
    [0, 0, 0, 1, 1, 1, 2, 2, 2],
    [0, 1, 2, 0, 1, 2, 0, 1, 2],
)

# Plot some data on the Axes.
# ax.plot( [0, 0, 1, 0], [0, 1, 1, 0] )
###AXPLOT###

# Show the figure.
# plt.savefig('output.pdf')
plt.savefig('###OUTPUT###.pdf')
# plt.show()
