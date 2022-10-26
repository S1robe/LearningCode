//
// Created by owner on 10/23/22.
//

#include "Graph.h"

Graph::Graph(int v) {
    this->v = v;
    adjacent = new std::list<wPair>[v];
}

void Graph::addEdge(int u, int v, int weight) {
    // Create weight pair v, w indicating that the weight from u -> v is w
    adjacent[u].emplace_back(v,weight);
    //Create a weight pair u, w indicating that the weight from v -> u is also w
    adjacent[v].emplace_back(u,weight);
}

int Graph::getWeight(int u, int v) {
    return adjacent[u].front().second;
}

int Graph::size(){
    return v;
}