# Java CakeShop Energy Experiment 

This folder contains the Java version of the CakeShop experiment used in the EnergyLogger Applied Workshop.

The experiment contains two versions of the same CakeShop website:

* cakeShop — uses the original, uncompressed images.
* cakeShop-compressed — uses compressed versions of the images.

Both applications use Spring Boot to serve the same static CakeShop website.

The purpose of having two versions is to investigate whether image compression affects the energy consumption associated with serving and loading the website.

⸻

Folder Structure

java/
├── cakeShop/
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/
│           │   └── CakeShopApplication.java
│           └── resources/
│               └── static/
│                   ├── images/
│                   ├── index.html
│                   ├── script.js
│                   └── style.css
│
├── cakeShop-compressed/
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/
│           │   └── CakeShopApplicationCompressed.java
│           └── resources/
│               ├── application.properties
│               └── static/
│                   ├── images/
│                   ├── index.html
│                   ├── script.js
│                   └── style.css
│
└── README.md

⸻

Requirements

The Java CakeShop applications require:

* Java 21 or newer
* Maven

Check that Java is installed:

java --version

Check that Maven is installed:

mvn --version

Installing Maven on macOS

If Maven is not installed and Homebrew is available:

brew install maven

Verify the installation:

mvn --version

⸻

Running the Standard CakeShop

Navigate to the standard CakeShop:

cd RP5-webshops/java/cakeShop

Start the application:

mvn spring-boot:run

When Spring Boot has started successfully, the terminal should report that Tomcat is running on port 8080.

Open:

http://localhost:8080

Stop the application with:

Ctrl+C

⸻

Running the Compressed CakeShop

Open another terminal and navigate to:

cd RP5-webshops/java/cakeShop-compressed

Start the application:

mvn spring-boot:run

The compressed CakeShop is configured to use port 8081.

Open:

http://localhost:8081

Stop the application with:

Ctrl+C

⸻

Running Both Applications at the Same Time

The two applications use different ports and can therefore run simultaneously.

Application	Port	URL
CakeShop	8080	http://localhost:8080
CakeShop Compressed	8081	http://localhost:8081

Terminal 1 — Standard CakeShop

cd RP5-webshops/java/cakeShop
mvn spring-boot:run

Terminal 2 — Compressed CakeShop

cd RP5-webshops/java/cakeShop-compressed
mvn spring-boot:run

You can then compare:

Standard CakeShop:
http://localhost:8080
Compressed CakeShop:
http://localhost:8081

⸻

Clean Build

If changes have been made or a clean build is required:

mvn clean
mvn spring-boot:run

Maven downloads the required Spring Boot dependencies automatically.

The first execution may therefore take longer than subsequent executions.

⸻

Experimental Difference

The two applications should remain as similar as possible.

The primary experimental difference is:

cakeShop
    ↓
Original images
cakeShop-compressed
    ↓
Compressed images

The following should remain equivalent between the two applications:

* HTML
* CSS
* JavaScript
* page content
* functionality
* application behaviour

The main variable being changed is the size of the image assets.

Keeping the applications equivalent helps isolate image compression as the variable being investigated during the EnergyLogger experiment.

⸻

Raspberry Pi 5

The Java CakeShop applications will also be deployed and tested on the Raspberry Pi 5 used in the EnergyLogger measurement environment.

The Raspberry Pi instructions will be added after the deployment procedure has been tested and verified.

Planned steps:

1. Verify Java on the Raspberry Pi 5.
2. Verify or install Maven.
3. Pull the EnergyLogger-applied-workshop repository.
4. Run both Java CakeShop applications.
5. Verify access over the local network.
6. Connect the experiment to the EnergyLogger measurement procedure.
7. Measure the standard CakeShop.
8. Measure the compressed CakeShop.
9. Compare the resulting energy measurements.

Status: Local macOS setup verified. Raspberry Pi 5 setup pending.

⸻

EnergyLogger Measurement

.

The procedure will document:

* sampling interval;
* baseline measurement;
* application startup;
* Sigmark markers;
* CakeShop workload;
* measurement duration;
* output file naming;
* repeated measurements;
* standard versus compressed comparison.

The same measurement procedure should be used for both CakeShop versions to produce comparable results.

⸻

Git

Maven creates a target directory when an application is built.

These generated files should not be committed to GitHub.

The repository .gitignore should contain:

# Maven build output
**/target/

⸻

