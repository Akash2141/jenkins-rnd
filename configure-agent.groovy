import jenkins.model.Jenkins
import hudson.slaves.DumbSlave
import hudson.model.Computer
import hudson.model.Node
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
// 🟢 FIX: Import the inner class used to pass the private key string
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey.StringCredentialsSource 

// --- Configuration Variables ---
def privateKeyFile = new File("/var/lib/jenkins/.ssh/id_rsa")
def privateKey = privateKeyFile.getText('UTF-8')

def sshCredId = "jenkins-agent-ssh-key"
def agentName = "jenkins-agent-node"
def agentIp = "192.168.56.20"
def remoteRootDir = "/home/jenkins/agent-workspace"
def labels = "linux-slave"
def numExecutors = 2 // Set based on your agent's resources (2 vCPUs recommended)

// 1. Create Jenkins SSH Credentials for the Agent
println "1. Creating SSH Credentials (ID: ${sshCredId}) for agent..."
def sshCred = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    sshCredId,
    "jenkins", // The user created on the agent VM
    new StringCredentialsSource(privateKey), // 🟢 FIX: Correct usage of the imported inner class
    null, // Passphrase (empty in this setup)
    "SSH Key for Jenkins Agent (${agentIp})"
)

// Add the credential to the system store
def credentialsStore = SystemCredentialsProvider.getInstance().getCredentials()
// Remove if it exists to allow re-provisioning
credentialsStore.removeIf { it.getId() == sshCredId }
credentialsStore.add(sshCred)
println "SSH Credentials created and saved."


// 2. Define and Add the Agent Node
println "2. Adding Agent Node '${agentName}'..."

def slave = new DumbSlave(
    agentName,
    "Jenkins Agent for R&D pipelines running