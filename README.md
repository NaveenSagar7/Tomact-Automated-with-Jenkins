# Cricket World Web Application

## Overview

Cricket World is a simple Java-based web application designed to be deployed on **Apache Tomcat**. The project focuses on a clean UI-first approach and a standard **Maven + Jenkins CI/CD** workflow. This repository is intentionally minimal and easy to revive even years later.

---

## Repository Structure

```
project-root/
├── pom.xml
├── Jenkinsfile
└── src/
    └── main/
        ├── java/
        │   └── com/example/cricket/servlet/
        │       └── HomeServlet.java
        ├── resources/
        │   └── application.properties
        └── webapp/
            ├── index.jsp
            └── WEB-INF/
                └── web.xml
```

project-root/
├── pom.xml
├── Jenkinsfile
└── src/
└── main/
└── webapp/
├── index.jsp
├── css/
│   └── style.css
└── images/

```

---

## pom.xml

**Purpose**
- Defines this project as a **Maven WAR application**
- Manages dependencies (Servlet/JSP API)
- Produces a `.war` file for Tomcat deployment

**Key Things to Remember (Future You)**
- Packaging type: `war`
- No Java source code is required for UI-only deployment
- Compatible with Tomcat 8/9

**Build Output**
```

target/cricket-world.war

````

---

## Jenkinsfile

**Purpose**
- Automates build and deployment
- Runs Maven build
- Deploys WAR to Tomcat

**Typical Flow**
1. Checkout code from GitHub
2. Run `mvn clean package`
3. Copy WAR to Tomcat `webapps/`
4. Restart or reload Tomcat

**Assumptions**
- Jenkins has Maven installed
- Tomcat is running on a VM or server
- Jenkins user has permission to deploy

---

## src Structure

### src/main/java
- Contains backend Java code
- `HomeServlet.java` is the entry servlet handling requests

### src/main/resources
- Configuration files
- `application.properties` for app-level settings

### src/main/webapp
- UI layer
- `index.jsp` is the landing page
- `WEB-INF/web.xml` defines servlet mappings and app config

---


## How to Build Locally

```bash
mvn clean package
````

WAR file will be generated in:

```
target/cricket-world.war
```

---

Author

Naveen Sagar
