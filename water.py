# import time
# from typing import List, Callable

# class Pipe:
#     def __init__(self, capacity: int, name: str = "", on_full: Callable[["Pipe"], None] = None):
#         self.name = name or f"Pipe_{id(self)}"
#         self.open = False
#         self.water = 0.0
#         self.capacity = capacity
#         self.connections: List["Pipe"] = []
#         self.on_full = on_full  # optional callback when pipe fills up

#     def connect(self, other: "Pipe"):
#         """Connect this pipe to another (one-way)."""
#         self.connections.append(other)

#     def receive(self, amount: float):
#         """Receive water up to capacity."""
#         if self.water >= self.capacity:
#             return 0.0  # can't accept any more
#         accepted = min(amount, self.capacity - self.water)
#         self.water += accepted

#         # trigger event if newly full
#         if self.water == self.capacity and self.on_full:
#             self.on_full(self)
#         return accepted

#     def update(self):
#         """Simulate 1 second of flow if open."""
#         if not self.open or self.water <= 0 or not self.connections:
#             return

#         # 1 unit per second to each connected pipe
#         total_outflow = min(self.water, len(self.connections))
#         amount_per_child = total_outflow / len(self.connections)

#         self.water -= total_outflow
#         for child in self.connections:
#             child.receive(amount_per_child)

#     def __repr__(self):
#         return f"<{self.name}: open={self.open}, water={self.water}/{self.capacity}>"

# class PipeStateManager:
#     def __init__(self):
#         self.pipes: List[Pipe] = []

#     def add_pipe(self, pipe: Pipe):
#         self.pipes.append(pipe)

#     def open_all(self):
#         for pipe in self.pipes:
#             pipe.open = True

#     def close_all(self):
#         for pipe in self.pipes:
#             pipe.open = False

#     def tick(self):
#         """Run one simulation step (1 second)."""
#         for pipe in self.pipes:
#             pipe.update()

#     def run(self, seconds: int = 10, delay: float = 1.0):
#         """Run for a given number of seconds."""
#         for t in range(seconds):
#             print(f"\n--- Time {t+1} ---")
#             self.tick()
#             for pipe in self.pipes:
#                 print(pipe)
#             time.sleep(delay)



# def on_last_pipe_full(pipe):
#     print(f"🚨 {pipe.name} is full! Global signal triggered!")

# # Create pipes
# p1 = Pipe(capacity=5, name="p1")
# p2 = Pipe(capacity=5, name="p2")
# p3 = Pipe(capacity=5, name="p3")
# pEnd = Pipe(capacity=1, name="pE", on_full=on_last_pipe_full)

# # Connect them
# p1.connect(p2)
# p1.connect(p3)
# p2.connect(pEnd)


# # Add to manager
# manager = PipeStateManager()
# for p in (p1, p2, p3, pEnd):
#     manager.add_pipe(p)

# # Initialize
# p1.water = 5  # start full
# p1.open = True
# p2.open = True
# p3.open = False
# pEnd.open = False

# # Run simulation
# manager.run(seconds=10, delay=0.5)

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

            # Calculate how much this pipe can send out
            total_outflow = min(pipe.water, len(pipe.connections))
            amount_per_child = total_outflow / len(pipe.connections)

            # Record how much to send to each connection
            for child in pipe.connections:
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
p2 = Pipe(capacity=10, name="p2")
p3 = Pipe(capacity=10, name="p3")
pFinal = Pipe(capacity=5, name="pFinal", on_full=on_last_pipe_full)

# Connections
p1.connect(p2)
p1.connect(p3)
p3.connect(pFinal)

# Setup manager
manager = PipeStateManager()
for p in (p1, p2, p3, pFinal):
    manager.add_pipe(p)

# Initial states
p1.water = 5
p1.open = True
p3.open = True  # Note: p3 has no water yet
p2.open = False
pFinal.open = False

# Run
manager.run(steps=3)
