//
// Created by owner on 10/23/22.
//

#include "map"
#include "Vertice.h"
#include <cstddef>

class Graph : std::map<int, Vertice>{
public:
  explicit Graph() = default;
  void addEdge(int u, int v, int toV);
  void addDoubleEdge(int u, int v, int toV, int toU);
  void getWeightFrom(int u, int v);
  std::map<int, int> edgesOf(int u); 
};




void Graph::addEdge(int u, int v, int toV){
   Vertice i = this->at(u);
  
     

}



void Graph::addDoubleEdge(int u, int v, int toV, int toU){
   auto i = Vertice(u);
   auto j = Vertice(v);

}

