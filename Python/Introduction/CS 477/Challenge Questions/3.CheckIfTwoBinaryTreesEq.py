# Check whether two binary trees are identical
# this is done simply by comparing the data of each node to the respective node.
class Node:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None


def swapEveryKLevelUtil(root, level, k):
    if root is None or (root.left is None and root.right is None):
        return

    if (level + 1) % k == 0:
        root.left, root.right = root.right, root.left

    swapEveryKLevelUtil(root.left, level + 1, k)
    swapEveryKLevelUtil(root.right, level + 1, k)


def swapEveryKLevel(root, k):
    swapEveryKLevelUtil(root, 1, k)


def areTreesIdentical(a, b):
    # Both empty
    if a is None and b is None:
        return True
    # Both non-empty
    if a is not None and b is not None:
        return ((a.data == b.data) and
                areTreesIdentical(a.left, b.left) and
                areTreesIdentical(a.right, b.right))
    # One Empty
    return False
