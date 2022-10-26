//
// Created by owner on 10/23/22.
//

#ifndef MINPATHANDMEDIANALGORITHMS_GRAPH_H
#define MINPATHANDMEDIANALGORITHMS_GRAPH_H

#include <utility>
#include <list>

typedef std::pair<int, int> wPair;

class Graph {
    int v; // # of vertices
    std::list<wPair> * adjacent;

public:
    // Generate graph with v vertices
    explicit Graph(int v);
    void addEdge(int u, int v, int weight);
    int getWeight(int u, int v);
    int size();
};


#endif //MINPATHANDMEDIANALGORITHMS_GRAPH_H
