from typing import List, Callable

class Pipe:
    def __init__(self, capacity: int, name: str = "", on_full: Callable[["Pipe"], None] = None):
        self.name = name or f"Pipe_{id(self)}"
        self.open = False
        self.water = 0.0
        self.capacity = capacity
        self.connections: List["Pipe"] = []
        self.on_full = on_full

    def connect(self, other: "Pipe"):
        """Connect this pipe to another (one-way)."""
        self.connections.append(other)

    def receive(self, amount: float):
        """Receive water up to capacity."""
        if self.water >= self.capacity:
            return 0.0
        accepted = min(amount, self.capacity - self.water)
        self.water += accepted
        if self.water == self.capacity and self.on_full:
            self.on_full(self)
        return accepted

    def __repr__(self):
        return f"<{self.name}: open={self.open}, water={self.water}/{self.capacity}>"

class PipeStateManager:
    def __init__(self):
        self.pipes: List[Pipe] = []

    def add_pipe(self, pipe: Pipe):
        self.pipes.append(pipe)

    def tick(self):
        """Run one simultaneous simulation step."""
        # Phase 1: Calculate all planned transfers
        transfers = {pipe: [] for pipe in self.pipes}

        for pipe in self.pipes:
            if not pipe.open or pipe.water <= 0 or not pipe.connections:
                continue
            # Count available children to send water to
            available_children = [
                child for child in pipe.connections if child.water < child.capacity
            ]

            # Calculate how much this pipe can send out
            if len(available_children) != 0:
                total_outflow = min(pipe.water, len(available_children))
                amount_per_child = total_outflow / len(available_children)
            else:
                total_outflow = 0
                amount_per_child = 0

            # Record how much to send to each connection
            for child in available_children:
                transfers[child].append(amount_per_child)

            # Deduct from parent immediately (so we don't double count)
            pipe.water -= total_outflow

        # Phase 2: Apply all inflows simultaneously
        for pipe, inflows in transfers.items():
            for amt in inflows:
                pipe.receive(amt)

    def run(self, steps: int = 5, verbose: bool = True):
        for t in range(steps):
            if verbose:
                print(f"\n--- Step {t+1} ---")
                for p in self.pipes:
                    print(p)

            self.tick()

        if verbose:
            print("\n--- Final State ---")
            for p in self.pipes:
                print(p)

def on_last_pipe_full(pipe):
    print(f"🚨 {pipe.name} is full! Global signal triggered!")

# Build your graph
p1 = Pipe(capacity=10, name="p1")
p2 = Pipe(capacity=1, name="p2")
p3 = Pipe(capacity=1, name="p3")
pFinal = Pipe(capacity=1, name="pFinal", on_full=on_last_pipe_full)

# Connections
p1.connect(p2)
p1.connect(p3)
p3.connect(pFinal)

# Setup manager
manager = PipeStateManager()
for p in (p1, p2, p3, pFinal):
    manager.add_pipe(p)

# Initial states
p1.water = 10

p1.open = True
p3.open = True  # Note: p3 has no water yet
p2.open = False
pFinal.open = False

# Run
manager.run(steps=5)



# from typing import List, Callable

# class Pipe:
#     def __init__(self, capacity: int, name: str = "", on_full: Callable[["Pipe"], None] = None):
#         self.name = name or f"Pipe_{id(self)}"
#         self.open = False
#         self.water = 0.0
#         self.capacity = capacity
#         self.connections: List["Pipe"] = []  # downstream pipes
#         self.parents: List["Pipe"] = []      # upstream pipes
#         self.on_full = on_full

#     def connect(self, other: "Pipe"):
#         """Connect this pipe to another (one-way)."""
#         self.connections.append(other)
#         other.parents.append(self)

#     def receive(self, amount: float):
#         """Receive water up to capacity."""
#         if self.water >= self.capacity:
#             return 0.0
#         accepted = min(amount, self.capacity - self.water)
#         self.water += accepted
#         if self.water == self.capacity and self.on_full:
#             self.on_full(self)
#         return accepted

#     def pull_from_parents(self):
#         """Pull water from upstream pipes (bottom-up flow)."""
#         if not self.open or self.water >= self.capacity or not self.parents:
#             return

#         # Calculate how much more this pipe can take
#         remaining_capacity = self.capacity - self.water
#         open_parents = [p for p in self.parents if p.open and p.water > 0]
#         if not open_parents:
#             return

#         # Ask each parent for equal contribution (like suction)
#         amount_per_parent = remaining_capacity / len(open_parents)
#         for parent in open_parents:
#             transferred = min(amount_per_parent, parent.water)
#             parent.water -= transferred
#             self.receive(transferred)

#     def __repr__(self):
#         return f"<{self.name}: open={self.open}, water={self.water}/{self.capacity}>"


# class PipeStateManager:
#     def __init__(self):
#         self.pipes: List[Pipe] = []
#         self._bottom_up_order: List[Pipe] = []

#     def add_pipe(self, pipe: Pipe):
#         self.pipes.append(pipe)

#     def build_bottom_up_order(self):
#         """Topologically sort pipes so deepest (end) nodes come first."""
#         order = []
#         visited = set()

#         def dfs(pipe: Pipe):
#             if pipe in visited:
#                 return
#             visited.add(pipe)
#             for child in pipe.connections:
#                 dfs(child)
#             order.append(pipe)

#         for pipe in self.pipes:
#             dfs(pipe)

#         # Reverse: we want deepest pipes first
#         self._bottom_up_order = order[::-1]
#         print(order)

#     def tick(self):
#         """One tick: deepest pipes pull from their parents."""
#         if not self._bottom_up_order:
#             self.build_bottom_up_order()

#         for pipe in self._bottom_up_order:
#             print(pipe.name)
#             pipe.pull_from_parents()

#     def run(self, steps: int = 5, verbose: bool = True):
#         self.build_bottom_up_order()
#         for t in range(steps):
#             if verbose:
#                 print(f"\n--- Step {t+1} ---")
#                 for p in self.pipes:
#                     print(p)
#             self.tick()

#         if verbose:
#             print("\n--- Final State ---")
#             for p in self.pipes:
#                 print(p)


# # Example usage
# def on_last_pipe_full(pipe):
#     print(f"🚨 {pipe.name} is full! Global signal triggered!")

# p1 = Pipe(capacity=10, name="p1")
# p2 = Pipe(capacity=1, name="p2")
# p3 = Pipe(capacity=1, name="p3")
# pE = Pipe(capacity=1, name="pE", on_full=on_last_pipe_full)

# # Connections
# p1.connect(p2)
# p1.connect(p3)
# p3.connect(pE)

# # Add to manager
# manager = PipeStateManager()
# for p in (p1, p2, p3, pE):
#     manager.add_pipe(p)

# # Initialize
# p1.water = 10
# p1.open = True
# p2.open = True
# p3.open = True
# pE.open = True

# # Run
# manager.run(steps=5)
