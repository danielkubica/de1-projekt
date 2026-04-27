# Project Repository for BPC-DE1 25/26L, Brno University of Technology FEEC

Authors:
- [Daniel Kubica](https://github.com/danielkubica) 
- [Adam Koutný](https://github.com/AdamRaccoon)

## Task
Create a module that smoothly changes LED brightness by generating a triangle waveform for the PWM duty cycle, simulating “inhale” and “exhale.”

# Breathing LED Controller (PWM)

The goal of this project is to create a "breathing" visual effect implemented on the Nexys A7-50T development board. The project utilizes Pulse Width Modulation (PWM) to smoothly change the brightness of LEDs.

### Key Features:

* **Smooth LED Breathing:** LED brightness changes based on a PWM signal that mimics a triangle wave, simulating a natural inhale and exhale cycle. The inhale duration is adjustable.
* **Spatial Inhale/Exhale:** Utilizes a row of 16 LEDs in four different modes that simulate breathing in various ways.
* **Adjustable Speed:** Using switches, the inhale time can be adjusted from 1s up to 8s.
* **Visual Feedback:** The currently selected inhale time and mode are displayed in real-time on a seven-segment display.

---

### Controls and Parameters:

The user interface is designed for maximum simplicity using onboard components:

| Component | Function | Description |
| :--- | :--- | :--- |
| **Switches [M13, L16, J15]** | Speed Setting | A 3-bit number (0-7 + 1) determining the cycle speed. |
| **Switches [V10, V11, V12]** | Mode Setting | A 3-bit number determining the breathing display mode. |
| **LED [15:0]** | Output Signal | Displays various breathing effects based on the selected mode. |
| **7-seg Display** | Indicator | Displays the current inhale time (1s, 2s, 3s, etc.) and mode (0 - 7). |

---

### Entity Functions and Details:

- **constant_pwm entity:** Generates a constant PWM signal with a specified duty cycle (an 8-bit number representing 0 - 100%).
- **breathing_pwm entity:** Generates a variable PWM signal with a specified inhale time, simulating inhale/exhale.
- **progress_bar entity:** Generates a "progress bar" inhale/exhale effect using 16 LEDs.
- **pyramid entity:** Generates a "pyramid" inhale/exhale effect using 16 LEDs. 
- **stars entity:** Generates a "star" effect with 16 differently pulsing LEDs. 
- **seg_decoder entity:** Decodes a 3-bit number (inhale time and mode) into a 7-bit signal representing the character for the 7-segment display. 
- **display_driver entity:** To "simultaneously" display two different numbers on the Nexys A7 board, the numbers must be multiplexed in time. This entity handles that logic.
* **Timing Logic:** Switches define the inhale/exhale duration (1-7s).
* **Implementation:** Developed in VHDL for Artix-7 FPGA (Nexys A7-50T/100T).

---

### How to Run the Project:

**Vivado:**
1. Use the provided vivado-project for the **Xilinx Vivado** IDE from the GitHub repository.
2. You may need to adjust the maximum simulation time in Vivado settings tools -> settings -> simulation -> simulation (in the tabbed menu) -> xsim.simulate.runtime set to 4ms.
3. For the actual implementation on the board, you have (un)comment the relevant constants in /hdl/config.vhd (change of clock frequency, etc.)
4. Run synthesis, implementation, and bitstream generation.
5. Upload the program to the board and use the switches to control speed and modes.

**GHDL+GTKWave (Simulation only):**
1. Clone the GitHub repository to a local directory.
2. Install **GHDL** and **GTKWave**, and ensure they are in your PATH.
3. Navigate to the simulation folder (e.g., `cd ~/Downloads/pwm-breathing-led/sim`).
5. In the Makefile (Linux/Unix) or run.ps1 (Windows), update the `TOP` variable to the name of the testbench you wish to simulate (e.g., `tb_breath_leds`).
4. Build the project in the console using `make` or running the `run.ps1` script and view the waveforms using `make view` or `run.ps1 view`.

## Block Diagram
![Breathing LED Block Diagram](/img/block_diagram.svg)

## Simulations
Constant PWM signal simulation
![constant_pwm_view](/img/signal_views_imgs/constant_pwm_view.png)

"Breathing LED" mode simulation (variable PWM signal)
![breathing_pwm_view](/img/signal_views_imgs/breathing_pwm_view.png)

"Progress bar" mode simulation
![progress_bar_view](/img/signal_views_imgs/progress_bar_view.png)

"Pyramid" mode simulation
![pyramid_view](/img/signal_views_imgs/pyramid_view.png)

"Stars" mode simulation
![stars_view](/img/signal_views_imgs/stars_view.png)

Top-level entity `breathing_led_top` simulation
![top_level_view](/img/signal_views_imgs/top_level_view.png)

## Poster, etc.
:TODO

## Video
:TODO