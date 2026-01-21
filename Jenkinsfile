pipeline{
    agent any

    environment {
        SRC_DIR       = 'cricket-world'                     //jenkins workspace path where code is checked out
        REMOTE_HOST   = '10.11.12.80'                        // private IP/DNS of ec2 instance
        REMOTE_USER   = 'ec2-user/tomcat/anything'
        CATALINA_HOME = '/opt/tomcat'
        WEBAPPS_DIR   = '/opt/tomcat/webapps'
        GENERATED_WAR = 'cricket-world/target/cricket-world*.war' //path of war file after build
        WAR_NAME      = 'cricket-world.war'                  // artifact name after build
    }

    stages{

        stage('Checkout scm')
        {
            steps{
                checkout scm
            }
        }

        stage('Build war file')
        {
            steps{
                sh 'mvn clean package' //have maven installed on jenkins agent or else install maven here first before this step
               //sh 'mvn deploy'       //this will push the artifact to nexus repo if configured in pom.xml/settings.xml
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent(credentials: ['ec2-ssh']) { //here we add private key of jenkins server in the jenkins/credentials/ec2-ssh and public key in ec2 instance under authorized_keys
                sh '''
                    set -e
                    # Known hosts 
                    mkdir -p ~/.ssh && chmod 700 ~/.ssh
                    touch ~/.ssh/known_hosts && chmod 600 ~/.ssh/known_hosts
                    ssh-keyscan -H "${REMOTE_HOST}" >> ~/.ssh/known_hosts  #this will avoid authenticity prompt

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
    }
        post
        {
            success{
                echo 'Deployed Successfully'
            }
            failure{
                echo 'Deployment Failed'
            }
        }
}