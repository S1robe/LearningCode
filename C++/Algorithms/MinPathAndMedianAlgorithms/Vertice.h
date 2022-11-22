
#include <map>

class Vertice  : std::map<Vertice, int>{
  int id;
public:
  explicit Vertice(int id){this->id = id;}
}
