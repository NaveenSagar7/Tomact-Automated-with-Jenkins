pipeline {
  agent {
    docker {
      image 'ci-maven-ssh:11'     // built from the Dockerfile above
      args '-u root'
      reuseNode false
    }
  }

  environment {
    // ---- where the source lives in your repo ----
    SRC_DIR      = 'java-webapp'

    // ---- SonarQube ----
    // SONAR_PROJECT_KEY = 'gts9'                 // create this project in SonarQube (or let Maven create)
    // withSonarQubeEnv('sonar') will inject SONAR_HOST_URL + auth

    // ---- Targeted EC2 / Tomcat ----
    REMOTE_HOST   = '10.11.12.80'              // private IP/DNS
    REMOTE_USER   = 'ec2-user'
    CATALINA_HOME = '/app/tomcat'
    WEBAPPS_DIR   = '/app/tomcat/webapps'
    WAR_NAME      = 'gts9.war'                  // artifact name after build
  }

/*  options {
    timestamps()
    disableConcurrentBuilds()
  }
*/
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build & Unit Test (Maven)') {
      steps {
        dir("${SRC_DIR}") {
          sh 'mvn -B -q clean test package'  // runs tests and produces target/gts9.war
        }
      }
      post {
        success {
          archiveArtifacts artifacts: "${SRC_DIR}/target/${WAR_NAME}", fingerprint: true
        }
      }
    }

/*    stage('SonarQube Analysis') {
      steps {
        dir("${SRC_DIR}") {
          withSonarQubeEnv('sonar') { // <-- name you configure in Manage Jenkins > System > SonarQube servers
            sh '''
              mvn -B -q verify sonar:sonar \
                -Dsonar.projectKey=''' + "${SONAR_PROJECT_KEY}" + '''
            '''
          }
        }
      }
    }

    stage('Quality Gate') {
      steps {
        // requires SonarQube webhook -> Jenkins (/sonarqube-webhook/)
        timeout(time: 5, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }
*/
    stage('Deploy to Tomcat') {
      steps {
        sshagent(credentials: ['ec2-ssh']) {
          sh '''
            set -e
            # Known hosts
            mkdir -p ~/.ssh && chmod 700 ~/.ssh
            touch ~/.ssh/known_hosts && chmod 600 ~/.ssh/known_hosts
            ssh-keyscan -H "${REMOTE_HOST}" >> ~/.ssh/known_hosts

            # Stop tomcat (ignore if already stopped)
            ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo ${CATALINA_HOME}/bin/shutdown.sh || true"

            # Backup existing
            ssh ${REMOTE_USER}@${REMOTE_HOST} "if [ -f ${WEBAPPS_DIR}/${WAR_NAME} ]; then mv ${WEBAPPS_DIR}/${WAR_NAME} ${WEBAPPS_DIR}/${WAR_NAME}.bak.$(date +%s); fi"

            # Upload new WAR
            scp "${SRC_DIR}/target/${WAR_NAME}" ${REMOTE_USER}@${REMOTE_HOST}:/tmp/${WAR_NAME}
            ssh ${REMOTE_USER}@${REMOTE_HOST} "mv /tmp/${WAR_NAME} ${WEBAPPS_DIR}/${WAR_NAME}"

            # Start tomcat (setenv.sh defines JAVA_HOME)
            ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo ${CATALINA_HOME}/bin/startup.sh"
          '''
        }
      }
    }

    stage('Health check (on target)') {
      steps {
        sshagent(credentials: ['ec2-ssh']) {
          sh '''
            ssh ${REMOTE_USER}@${REMOTE_HOST} 'bash -s' <<'REMOTE'
            set -e
            for i in $(seq 1 30); do
              curl -sf -m 2 http://localhost:8080/gts9/ >/dev/null && { echo "App is up"; exit 0; }
              sleep 2
            done
            echo "App did not become healthy within timeout"; exit 1
REMOTE
          '''
        }
      }
    }
  }

  post {
    success { echo '✅ Build analyzed, WAR deployed, app healthy.' }
    failure { echo '❌ Pipeline failed — open Console Output for the first error.' }
  }
}

