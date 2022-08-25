class Deque:

    def __init__(self, value):
        self.head = self.Node(value)
        self.head.next = self.tail
        self.tail = self.head
        self.tail.prev = self.head
        self.sz = 1

    def enqueueFront(self, value):
        hold = self.Node(value)
        hold.next = self.head
        self.head.prev = hold
        self.head = hold
        self.sz += 1

    def enqueueBack(self, value):
        hold = self.Node(value)
        hold.prev = self.tail
        self.tail.next = hold
        self.tail = hold
        self.sz += 1

    def dequeueFront(self):
        hold = self.head.value
        self.head = self.head.next
        self.head.prev = None
        self.sz -= 1
        return hold

    def dequeueBack(self):
        hold = self.tail.value
        self.tail = self.tail.prev
        self.tail.next = None
        self.sz -= 1
        return hold

    def first(self):
        return self.head.value

    def last(self):
        return self.tail.value

    def isEmpty(self):
        return self.sz == 0

    def __len__(self):
        return self.sz

    def __str__(self):
        hold = self.head
        while hold is not None:
            print(hold)
            hold = hold.next

    class Node:

        def __init__(self, value):
            self.value = value
            self.next = None
            self.prev = None
