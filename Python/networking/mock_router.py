#!/usr/bin/python

# Name: Garrett Prentice
# Date: 11/4/23

import networkx as nx
import os

PROMPT = """
Assignment 5 - Main Menu (Enter a number)
1. Add Router to Network
2. Add Cost Connection
3. Run Link-State Algorithm
4. Run Distance Vector Algorithm
5. Exit
"""

# This is used for determining if a router has been changed or not
# Look up by router name
dirty = dict(str, bool)


# Adds a router to the current network
def add_router(graph, router_name) -> bool:
    # Router cannot already exist
    if router_name in graph.nodes:
        return False
    else:
        # router has been added to the list, so it starts dirty (no route table)
        dirty[router_name] = True
        graph.add_router(router_name)
        return True


# Adds a connection between two routers at some specified cost
def add_connection(graph, router1, router2, cost) -> bool:
    # Routers both must exist, otherwise we must add them.
    if router1 not in graph.nodes or router2 not in graph.nodes:
        return False

    # Both routers have changed, both are dirty.
    dirty[router1] = True
    dirty[router2] = True
    # Using 'weight' ensures the build-in algorithms work
    graph.add_edge(router1, router2, weight=cost)
    return True


# Runs the link-state algorithm on the graph, caching results to the router
def ls_algorithm(graph, source_router):
    # Run Dijkstras on the graph from src
    costs, paths = nx.single_dijkstra_path(graph, source_router)
    # Attribute the node with its routing table
    graph[source_router]['routes'] = {"costs": costs, "paths": paths}
    # Node has been "saved", so it is clean
    dirty[source_router] = False
    return costs, paths


# Runs the distance-vector algorithm on the graph, caching results to the router
def dv_algorithm(graph, source_router) -> tuple(dict, dict):
    # Run the bellman_ford algortihm from src to everywhere.
    costs, paths = nx.bellman_ford_path_length(graph, source_router)
    # attribute the node with its routing table as generated by bellman_ford
    graph[source_router]['routes'] = {"costs": costs, "paths": paths}
    # Node has been "saved", so its not dirty.
    dirty[source_router] = False
    return costs, paths


# utility method that clears the screen and waits for input after displaying a message
def clear(message: str):
    if len(str) != 0:
        print(str)
        input("press enter to continue...")
    if os.name == "Windows":
        os.system('cls')
    else:
        os.system('clear')


# Requests the router name from the user, displays error messages if the router already exits in the network
def getRouterName(graph: nx.Graph) -> str:
    # The graph is none when you want to add nodes
    if graph is not None:
        while True:
            name = str(input(f"Select a router: {graph.nodes}\nPress enter without anything to go back.\n"))
            if len(name) == 0:
                clear()
                break

            elif name not in graph.nodes:
                clear(f"${name} is not an existing router.")

        return name
    else:
        while True:
            name = str(input("Please enter a name for the router (Max 16 characters)\nPress enter without anything to go back.\n"))
            if len(name) > 16:
                clear(f"Name ${name} is too long.")

            elif len(name) == 0:
                clear()
                break

        return name


# Requests the cost between two different routers
def getRouterCost(name1, name2) -> int:
    while True:
        try:
            cost = int(input(f"Please enter the cost between ${name1} <-> ${name2}"))
        except ValueError:
            clear("Costs must be integers")

        if cost < 0:
            clear("Costs cannot be negative.")

    return cost


# Prints the routing table from start to the rest of the network
def printRoute(start: str, graph: nx.Graph):
    routes = graph[start]['routes'] # Routes stored after algorithm is ran
    costs = routes["costs"]
    paths = routes["paths"]

    # Print the routing table
    for end in graph.nodes:
        print(f"{start} -> {end}: Cost {costs[end]} (Path: {paths[end]})")


def main():
    G = nx.Graph()
    # Infinite Loop, based on user input
    while True:
        try:
            choice = int(input(PROMPT))
        except ValueError:
            clear(f"Not a valid input ${choice}")
            continue

        # Switching based on users choice [1 - 5]
        match choice:
            case 1:
                while True:
                    # Get the routers name from the user
                    name = getRouterName()
                    if add_router(G, name): # Attempt to add it
                        break
                    clear(f"${name} already exists, please specify another name")

            case 2:
                # Get the router name from the user
                name1 = getRouterName(G)
                # Name is empty indicates misinput
                if len(name1) == 0:
                    break
                name2 = getRouterName(G)
                if len(name2) == 0:
                    break
                cost = getRouterCost(name1, name2)
                if add_connection(G, name1, name2, cost): # Attempt to add connection
                    break
                choice = str(input(f"Either {name1} or {name2} are not on the network.\nWould you like to add them? (Y/n)"))
                
                # QOL ask to add the routers to the network
                # This will not add duplicates.
                match choice.lower():
                    case "n":
                        pass
                    case "no":
                        clear("Routers not added")
                        break
                    case _:
                        add_router(G, name1)
                        add_router(G, name2)
                        add_connection(G, name1, name2, cost)
                        clear(f"Routers {name1}, {name2} added to network")
                        break
                break

            case 3:
                name = getRouterName(G)
                # If the algorithm has not been run for this node
                # And there has been no change to the node, run the algo
                if dirty[name]:
                    ls_algorithm(G, name)

                print(f"DV Algorithm (from source {name})")
                printRoute(name, G)
                break

            case 4:
                name = getRouterName(G)
                # If the algorithm hasnt been run for this node, 
                # or the node has not been changed, run the algo.
                if dirty[name]:
                    dv_algorithm(G, name)
                
                print(f"DV Algorithm (from source {name})")
                printRoute(name, G)
                break

            case 5:
                print("Exiting....")
                exit(0)
            case _:
                clear(f"Not a valid input ${choice}")
        # continue
    #
#


if __name__ == "__main__":
    main()
