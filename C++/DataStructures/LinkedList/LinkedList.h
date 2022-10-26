#include "../Node.h"

//
// Created by owner on 10/23/22.
//
template <typename T>

class LinkedList {
    Node<T>* head;
    Node<T>* tail;
    int size = 0;
public:
    explicit LinkedList(T data);
    T remove(int index);
    bool remove(T data);
    bool contains(T data);
    int indexOf(T data);
    void add(T data);
    bool empty();
private:
    Node<T>* find(T data);



};



