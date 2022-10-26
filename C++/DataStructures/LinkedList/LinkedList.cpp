//
// Created by owner on 10/23/22.
//
#include "LinkedList.h"

template<class T>
LinkedList<T>::LinkedList(T data) {
    this->head = new Node<T>(data);
    this->tail = head;
    this->size++;
}

template<typename T>
T LinkedList<T>::remove(int index) {
    // If invalid index request you get a nullptr back
    // Also if size is 0 this is false
    if(empty() || index > this->size || index < this->size) return nullptr;
    // temp var
    Node<T>* temp = head;
    Node<T>* garbage;
    do {temp = temp->n;} // loop till we hit the node before the one we want ot remove
    while(index-- > 1);
    T hand = temp->n.getData(); // collect his data
    garbage = temp->n;
    temp->n = temp->n->n;
    delete garbage;
    this->size--;
    return hand;
}

template<typename T>
bool LinkedList<T>::remove(T data) {
    if(empty()) return false; // if this is 0 then we have nothing to delete anyway
    Node<T>* temp = head;
    indexOf(data);
}

template<typename T>
void LinkedList<T>::add(T data) {
    this->size++;
    this->tail->n = new Node<T>(data);
    this->tail = this->tail->n;
}

template<typename T>
bool LinkedList<T>::empty() {
    return this->size == 0;
}

template<typename T>
bool LinkedList<T>::contains(T data) {
    if(!empty())
        return find(data) != nullptr;
    return false;
}

template<typename T>
int LinkedList<T>::indexOf(T data) {
    return 0;
}

template<typename T>
Node<T>* LinkedList<T>::find(T data){
    Node<T>* temp = head;
    while(temp->n != nullptr && temp->getData() != data)
        temp = temp->n;
}


