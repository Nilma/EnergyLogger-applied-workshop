# EnergyMeasurment-workshop

# Workshop: Measuring CPU Stress to Promote Sustainable Software Development

## Purpose

This workshop helps students understand how software behavior affects hardware load and energy-related resource use.  
The goal is to motivate students to write more sustainable code by showing how much stress their applications place on the CPU during execution.

Students will run their own applications while a prepared measurement setup records CPU-related stress and marks important moments during the experiment.  
By comparing different implementations, students can reflect on how design and coding choices influence runtime behavior.

## Learning Objectives

After this workshop, students should be able to:

- explain why CPU-intensive applications can be less sustainable
- run an application in a controlled measurement setup
- observe how software execution affects CPU stress
- compare different implementations based on measured behavior
- reflect on how code quality, efficiency, and design decisions relate to sustainability

## Workshop Idea

The workshop is based on a measurement experiment using a Raspberry Pi 5 (RP5) and a Siglent device.  
The Raspberry Pi runs the student application, while measurement markers are sent to the logging system so that activity in the software can be connected to measurement data.

The teacher prepares the measurement script in advance.  
Students only need to make sure their application can run on the Raspberry Pi 5 during the measurement period.

## Experimental Setup

The setup includes:

- **Raspberry Pi 5** for running the student application
- **Siglent measurement device** for collecting measurement data
- **Network switch** for communication between devices
- **Teacher laptop** (MacBook Pro or Windows laptop) for coordination, monitoring, and logging

### Setup Overview

- The **Raspberry Pi 5** is connected to the **Siglent**
- The **Raspberry Pi 5**, **Siglent**, and **teacher laptop** are connected through the **network switch**
- Measurement markers are sent through the logging API using the provided script
- The student application runs simultaneously with the measurement process

## Measurement Principle

The idea is simple:

1. Start the measurement setup
2. Run the student application on the Raspberry Pi 5
3. Send markers before, during, and after important actions
4. Compare the recorded CPU-related stress across runs

This makes it possible to connect application behavior to measurable system effects.

## Provided Script

The teacher provides a script called `sigmark.sh` that sends a log marker to the measurement system.

### `sigmark.sh`

