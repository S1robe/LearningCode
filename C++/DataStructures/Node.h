//
// Created by owner on 10/23/22.
//

#ifndef DATASTRUCTURES_NODE_H
#define DATASTRUCTURES_NODE_H

template <typename T>

class Node {
    T data;
    Node* n;
public:
    explicit Node(T data);
    Node<T>* getNext();
    T getData();
};




#endif //DATASTRUCTURES_NODE_H
