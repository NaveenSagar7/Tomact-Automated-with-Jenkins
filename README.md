🚀 Setup-3: Jenkins Automated WAR Build and Deployment to Tomcat
📘 Overview

This setup is designed to eliminate the need for developers to manually build .war files locally.
Instead, Jenkins will automatically compile, package, analyze, and deploy your Java web application whenever code is pushed to GitHub.

This pipeline demonstrates a real-world CI/CD flow:

Developers push Java source files (like HelloServlet.java, web.xml) to GitHub.

Jenkins automatically builds a .war file using Maven.

Code quality is analyzed using SonarQube.

The WAR is deployed to a running Tomcat server on an EC2 instance.

A health check confirms that deployment succeeded.

1️⃣ Developer Action

Developer commits code changes to the GitHub repo.

The webhook immediately notifies Jenkins of the new commit.

2️⃣ Jenkins Pipeline Trigger

Jenkins receives the webhook payload at /github-webhook/.

Jenkins triggers a new build automatically (no manual “Build Now” needed).

3️⃣ Jenkins Build Process

The pipeline performs the following stages:

Stage 1 — Checkout

Pulls the latest source code from the configured GitHub branch.

Stage 2 — Build

Uses Maven inside a Jenkins agent (or container) to:

mvn clean package


This step compiles the Java source code and creates a .war file inside the target/ directory.

Stage 3 — SonarQube Code Analysis

Analyzes code quality and security vulnerabilities:

mvn sonar:sonar


SonarQube sends results to the dashboard, showing metrics such as:

Code coverage

Code smells

Bugs and vulnerabilities

Stage 4 — Deployment

Transfers the built WAR to the Tomcat webapps directory on an EC2 instance using SSH or SCP:

scp target/gts9.war ec2-user@<ec2-ip>:/app/tomcat/webapps/

Stage 5 — Health Check

Verifies successful deployment:

curl -sf -m 2 http://<ec2-ip>:8080/gts9/


If the app responds with HTTP 200, the build is marked as SUCCESS ✅.



💡 In short:
Maven automates building, testing, and packaging Java applications while ensuring consistency across environments.

☁️ SonarQube Integration (Static Code Analysis)
Why SonarQube?

SonarQube ensures code quality and security by performing static analysis on your Java codebase.

Setup Steps

Install SonarQube Scanner for Jenkins plugin.

Configure server:

Manage Jenkins → System → SonarQube servers

Add server name: sonar

Server URL: http://<your-sonarqube-server>:9000

Add authentication token (create one in SonarQube → My Account → Security → Tokens)

In your Jenkinsfile, reference the SonarQube tool:

withSonarQubeEnv('sonar') {
    sh 'mvn sonar:sonar'
}



🔁 Webhook Configuration
In GitHub

Go to your repo → Settings → Webhooks → Add webhook

Set:

Payload URL: http://<jenkins-public-ip>:8080/github-webhook/

Content type: application/json

Events: “Just the push event”

Active: ✅

Save the webhook.

In Jenkins

Manage Jenkins → System → Jenkins Location

Jenkins URL → http://<jenkins-public-ip>:8080/

Job → Configure → Build Triggers

Tick “GitHub hook trigger for GITScm polling”.

Result: Every Git push triggers an immediate build!

🧩 Example Developer Workflow
Step	Action
1	Developer edits HelloServlet.java and web.xml.
2	Pushes code to GitHub.
3	GitHub webhook notifies Jenkins instantly.
4	Jenkins builds and packages .war using Maven.
5	Jenkins runs SonarQube analysis.
6	Jenkins deploys WAR to Tomcat on EC2.
7	Health check verifies successful deployment.
✅ Benefits of this Setup

🚀 Fully automated CI/CD pipeline

🧱 Consistent WAR builds across environments

🧩 Integrated static code analysis via SonarQube

🔔 Real-time builds using GitHub webhooks

💡 Zero manual intervention from developers

