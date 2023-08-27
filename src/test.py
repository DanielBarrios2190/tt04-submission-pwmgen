import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


@cocotb.test()
async def test_7seg(dut):
    clk_period = 2  # Clock period in nanoseconds
    rst_ns = 5     # Reset time in nanoseconds
    clk_ns = clk_period / 2

    # Apply reset
    dut.rst <= 1
    yield cocotb.utils.simulator_yield(rst_ns, 'ns')
    dut.rst <= 0

    # Test cases
    for bits_value in [0b011, 0b100, 0b111, 0b010, 0b000]:
        dut.bits <= bits_value
        duty_value = 0.5 * (2 ** bits_value)
        dut.duty <= duty_value

        yield ClockCycles(dut.clk, 200)  # Wait for some cycles

        duty_value = 0.25 * (2 ** bits_value)
        dut.duty <= duty_value
        yield ClockCycles(dut.clk, 400)

        duty_value = 0.75 * (2 ** bits_value)
        dut.duty <= duty_value
        yield ClockCycles(dut.clk, 400)

    # Wait for the simulation to complete
    yield ClockCycles(dut.clk, 400)
    yield cocotb.utils.simulator_yield(1, 'ns')
    cocotb.log.info("Simulation complete")

