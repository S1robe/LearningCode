//
// Created by owner on 10/23/22.
//

#include "Node.h"
template<typename T>
Node<T>::Node(T data) {
    this->data = data;
}

template<typename T>
Node<T> *Node<T>::getNext() {
    return this->n;
}

template<typename T>
T Node<T>::getData() {
    return this->data;
}