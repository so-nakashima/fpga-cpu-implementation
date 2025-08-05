from .machine_state import MachineState
from .state_updater import StateUpdater


class CPU_Emulator:
    state: MachineState
    state_updater: StateUpdater
    history: list[MachineState]

    def __init__(self, state: MachineState):
        self.state = state
        self.state_updater = StateUpdater()
        self.history = [state]

    def run(self) -> None:
        while True:
            updated_state = self.state_updater.calc_updated_state(self.state)
            self.state = updated_state
            self.history.append(updated_state)
            if updated_state.halt:
                print(f"halt at {updated_state.program_counter}")
                break
