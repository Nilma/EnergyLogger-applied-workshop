# EnergyLogger Applied Workshop – Running the Applications
This guide explains how to run and test the **JavaScript** and **Java** CakeShop applications on the Raspberry Pi 5 and how to run an EnergyLogger experiment.
The goal is to compare the energy consumption of different implementations of the same web application.
---
# 1. Project Structure
The Raspberry Pi project should have a structure similar to:
```text
energyLogger-experiment/
│
├── apps/
│   │
│   ├── javascript/
│   │   ├── cakeShop/
│   │   └── cakeShop-compressed/
│   │
│   └── java/
│       ├── cakeShop/
│       └── cakeShop-compressed/
│
├── energyLogger/
│   ├── pmic_raw_logger
│   ├── run_energy_experiment.sh
│   ├── results/
│   └── logs/
│
└── workloads/
    ├── run_cakeshop_workload.sh
    ├── run_cakeshop_compressed_workload.sh
    ├── run_java_cakeshop_workload.sh
    └── run_java_cakeshop_compressed_workload.sh

The apps directory contains the applications.

The workloads directory contains scripts that generate a repeatable workload.

The energyLogger directory contains the EnergyLogger measurement tool and experiment script.

⸻

2. Connect to the Raspberry Pi

Connect to the Raspberry Pi using SSH.

ssh pi3@<RASPBERRY-PI-IP>

Replace <RASPBERRY-PI-IP> with the IP address of your Raspberry Pi.

Example:

ssh pi3@192.168.1.100

⸻

3. Check the Required Software

Before running the experiments, check that the required tools are installed.

Python

The JavaScript version uses Python’s simple HTTP server.

python3 --version

Java

java --version

The Java applications currently use Java 21.

Maven

mvn --version

curl

curl --version

perf

perf --version

⸻

4. JavaScript CakeShop

The JavaScript CakeShop is a static website.

It can therefore be served using Python’s built-in HTTP server.

Run the normal version

Move to the application directory:

cd /home/pi3/Desktop/energyLogger-experiment/apps/javascript/cakeShop

Start the web server:

python3 -m http.server 8000

The terminal should display something similar to:

Serving HTTP on 0.0.0.0 port 8000

Test it directly on the Raspberry Pi:

curl -I http://localhost:8000/index.html

A successful request should return a response such as:

HTTP/1.0 200 OK

You can also open the application from another computer on the same network:

http://<RASPBERRY-PI-IP>:8000

Stop the server with:

Ctrl+C

⸻

5. JavaScript Compressed CakeShop

Move to:

cd /home/pi3/Desktop/energyLogger-experiment/apps/javascript/cakeShop-compressed

Start the server:

python3 -m http.server 8000

Test it:

curl -I http://localhost:8000/index.html

Then stop the server:

Ctrl+C

⸻

6. Java CakeShop

The Java version uses Spring Boot and its embedded Tomcat server.

Run the normal Java version

Move to:

cd /home/pi3/Desktop/energyLogger-experiment/apps/java/cakeShop

Run:

mvn spring-boot:run

Wait until Spring Boot reports that the application has started.

The normal version uses:

http://localhost:8080

Test it:

curl -I http://localhost:8080/index.html

Or open it from another computer:

http://<RASPBERRY-PI-IP>:8080

Stop Spring Boot with:

Ctrl+C

⸻

7. Java Compressed CakeShop

Move to:

cd /home/pi3/Desktop/energyLogger-experiment/apps/java/cakeShop-compressed

Run:

mvn spring-boot:run

The compressed version currently uses port:

8081

Test it:

curl -I http://localhost:8081/index.html

Or open:

http://<RASPBERRY-PI-IP>:8081

Stop it with:

Ctrl+C

⸻

8. Important: Application Test vs Energy Experiment

There are two different things we can do.

A. Test the application manually

This checks whether the website works.

For example:

mvn spring-boot:run

or:

python3 -m http.server 8000

B. Run an EnergyLogger experiment

This measures the application while a controlled workload is executed.

For an actual experiment, use:

./run_energy_experiment.sh <application>

Do not manually interact with the website during the measurement.

The workload script should generate the requests automatically so every experiment receives approximately the same workload.

⸻

9. Running EnergyLogger

Move to the EnergyLogger directory:

cd /home/pi3/Desktop/energyLogger-experiment/energyLogger

If necessary, make the experiment script executable:

chmod +x run_energy_experiment.sh

⸻

10. Measure JavaScript CakeShop

Normal version:

./run_energy_experiment.sh javascript-cakeshop

Compressed version:

./run_energy_experiment.sh javascript-cakeshop-compressed

The experiment should:

1. Start EnergyLogger.
2. Start the measurement.
3. Start the application/workload.
4. Send repeated HTTP requests.
5. Collect perf measurements.
6. Stop the measurement.
7. Save the results.

⸻

11. Measure Java CakeShop

Normal version:

./run_energy_experiment.sh java-cakeshop

Compressed version:

./run_energy_experiment.sh java-cakeshop-compressed

The Java workload scripts must exist in:

workloads/run_java_cakeshop_workload.sh
workloads/run_java_cakeshop_compressed_workload.sh

Make sure they are executable:

chmod +x /home/pi3/Desktop/energyLogger-experiment/workloads/*.sh

⸻

12. Check the Results

EnergyLogger measurements are stored under:

energyLogger/results/

For example:

results/
├── javascript/
│   ├── cakeshop/
│   └── cakeshop-compressed/
│
└── java/
    ├── cakeshop/
    └── cakeshop-compressed/

Performance measurements are stored under:

energyLogger/logs/

List the newest measurements:

ls -lt results/javascript/cakeshop

or:

ls -lt results/java/cakeshop

⸻

13. Check for Errors Before Using the Results

A completed script does not automatically mean that the experiment was successful.

Always inspect the terminal output.

For example, this is a problem:

GET /index.html HTTP/1.1" 404

404 means the workload requested a file that the server could not find.

For a valid experiment, the requests should successfully reach the application.

Before collecting experimental data, test the endpoint manually.

JavaScript:

curl -I http://localhost:8000/index.html

Java:

curl -I http://localhost:8080/index.html

The expected result is normally:

200 OK

Do not use an experimental measurement if the workload produced repeated 404 errors.

⸻

14. Port Already in Use

If Spring Boot reports:

Web server failed to start. Port 8080 was already in use.

check which process is using the port:

sudo lsof -i :8080

or:

sudo ss -ltnp | grep :8080

If an old application is still running, stop it before starting another experiment.

You can also test whether something is already responding:

curl -I http://localhost:8080/index.html

⸻

15. Recommended Student Workflow

For each application, follow the same process.

Step 1 – Check the application

Run it manually.

Step 2 – Open the application

Verify that the website loads correctly.

Step 3 – Test the endpoint

Use:

curl -I <URL>

Confirm that the application responds successfully.

Step 4 – Stop the manual server

Use:

Ctrl+C

Step 5 – Run the EnergyLogger experiment

For example:

cd /home/pi3/Desktop/energyLogger-experiment/energyLogger
./run_energy_experiment.sh javascript-cakeshop

Step 6 – Check for errors

Make sure the workload did not produce errors such as:

404
Connection refused
Address already in use

Step 7 – Check the generated files

Inspect:

results/
logs/

⸻

16. Current Experiment Matrix

The goal is to make the experiment structure consistent across programming languages.

Language	Normal	Optimized/Compressed
JavaScript	javascript-cakeshop	javascript-cakeshop-compressed
Java	java-cakeshop	java-cakeshop-compressed
C#	Coming next	Coming next
Laravel/PHP	Coming next	Coming next

This allows us to compare implementations using the same general experimental procedure.

⸻

17. Important Experimental Rule

When comparing applications:

Change one thing at a time.

Keep the following as consistent as possible:

* Raspberry Pi
* operating system
* EnergyLogger configuration
* sample period
* workload
* number of requests
* experiment duration
* network conditions
* background processes

The main variable should be the application or optimization being tested.

This makes the energy measurements easier to compare and explain.

⸻

Quick Reference

JavaScript

Test normal:

cd /home/pi3/Desktop/energyLogger-experiment/apps/javascript/cakeShop
python3 -m http.server 8000

Measure normal:

cd /home/pi3/Desktop/energyLogger-experiment/energyLogger
./run_energy_experiment.sh javascript-cakeshop

Measure compressed:

./run_energy_experiment.sh javascript-cakeshop-compressed

Java

Test normal:

cd /home/pi3/Desktop/energyLogger-experiment/apps/java/cakeShop
mvn spring-boot:run

Test compressed:

cd /home/pi3/Desktop/energyLogger-experiment/apps/java/cakeShop-compressed
mvn spring-boot:run

Measure normal:

cd /home/pi3/Desktop/energyLogger-experiment/energyLogger
./run_energy_experiment.sh java-cakeshop

Measure compressed:

./run_energy_experiment.sh java-cakeshop-compressed

⸻


Copyright © 2026 Nilma Abbas All rights reserved.

