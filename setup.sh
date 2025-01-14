#!/bin/bash

# Define colors for logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m' # Reset color to default

# Logging function to display logs with different levels
log() {
    local LEVEL=$1
    local MESSAGE=$2
    
    # Define colors for each log level
    case "$LEVEL" in
        INFO)
            COLOR=$GREEN
            ;;
        ERROR)
            COLOR=$RED
            ;;
        NOTE)
            COLOR=$CYAN
            ;;
        WARN)
            COLOR=$YELLOW
            ;;
        *)
            COLOR=$RESET
            ;;
    esac

    # Print log message with colors and a border
    echo -e "${COLOR}--------------------------------------------------"
    echo -e "${COLOR}[$LEVEL] - $MESSAGE"
    echo -e "${COLOR}--------------------------------------------------${RESET}"
}

# Greeting function to display an ASCII art greeting
greet() {
    clear
    echo -e "${MAGENTA}   _____              .___             .__    .___"
    echo -e "${MAGENTA}  /  _  \   ____    __| _/______  ____ |__| __| _/"
    echo -e "${MAGENTA} /  /_\  \ /    \  / __ |\_  __ \/  _ \|  |/ __ | "
    echo -e "${MAGENTA}/    |    \   |  \/ /_/ | |  | \(  <_> )  / /_/ | "
    echo -e "${MAGENTA}\____|__  /___|  /\____ | |__|   \____/|__\____ | "
    echo -e "${MAGENTA}        \/     \/      \/                      \/ "
    echo -e "${MAGENTA}  _________       __                              "
    echo -e "${MAGENTA} /   _____/ _____/  |_ __ ________                "
    echo -e "${MAGENTA} \_____  \_/ __ \   __\  |  \____ \               "
    echo -e "${MAGENTA} /        \  ___/|  | |  |  /  |_> >  by @shahil-sk"
    echo -e "${MAGENTA}/_______  /\___  >__| |____/|   __/               "
    echo -e "${MAGENTA}        \/     \/           |__|                  ${RESET}"
    echo -e ""
}

outro() 
{
    echo ""
    echo -e " ${GREEN}      (        )     )      "
    echo -e "       )\ )  ( /(  ( /(      "
    echo -e "      (()/(  )\()) )\())(    "
    echo -e "       /(_))((_)\ ((_)\ )\   "
    echo -e "      (_))_   ((_) _((_|(_)  "
    echo -e "       |   \ / _ \| \| | __| "
    echo -e "       | |) | (_) | .\` | _|  "
    echo -e "       |___/ \___/|_|\_|___| "
    echo -e "                             ${RESET}"
    echo -e "${CYAN}--------------------------------------------------"
    echo " Run this to Start MobSF"
    echo "  1) docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest"
    echo "--------------------------------------------------"
    echo " Terminal Commands for non-cli tools"
    echo " Jadx    >  jadx"
    echo " APKTool > apktool"
    echo "--------------------------------------------------"
    echo -e "${GREEN}DONE! Enjoy Hacking :-))))${RESET}"
    echo ""
}

check_internet() {
    # Check internet connection using ping to google.com
    if ping -c 1 google.com > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to install a package and log the result
install_package() {
    local PACKAGE=$1
    log "INFO" "Installing $PACKAGE"
    sudo apt install -y "$PACKAGE"
}

# Function to download and extract the latest Drozer agent APK
download_drozer_agent() {
    log "NOTE" "Pulling Drozer Agent APK"
    DROZER_APK_URL=$(wget -qO- https://api.github.com/repos/WithSecureLabs/drozer-agent/releases/latest | jq -r '.assets[] | select(.name | endswith(".apk")) | .browser_download_url')
    wget -O drozerAgent.apk "$DROZER_APK_URL"
    mkdir -p Drozer
    mv drozerAgent.apk ./Drozer
    log "INFO" "Drozer Agent APK downloaded successfully."
}

# Function to install tools using pip
install_pip_tool() {
    local TOOL=$1
    log "INFO" "Installing $TOOL"
    pipx install "$TOOL"
}

# Function to install and extract JADX
install_jadx() {
    wget "https://github.com/skylot/jadx/releases/download/v1.5.1/jadx-1.5.1.zip"
    mkdir -p jadx
    echo "Extracting JADX..."
    unzip jadx-1.5.1.zip -d ./jadx
    
    #delete jadx archive
    rm -f jadx-1.5.1.zip
    
    # Make the script executable
    sudo chmod +x ./jadx/bin/jadx-gui
    sudo chmod +x ./jadx/bin/jadx

    #move jadx to /opt for global access
    sudo mv ./jadx /opt
    sleep 2

    #jadx wrapper code 
    echo -e "#!/bin/bash\n/opt/jadx/bin/jadx-gui" > jadx
    chmod +x jadx
    sudo mv jadx /usr/local/bin

    echo "JADX version 1.5.1 installed successfully."

}

# Function to download APKTool
download_apktool() {
    log "NOTE" "Pulling APKTools"
    APKTOOL_URL=$(wget -qO- https://api.github.com/repos/iBotPeaches/Apktool/releases/latest| jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')
    wget -O apktool.jar "$APKTOOL_URL"
    chmod +x apktool.jar
    wget "https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool"
    chmod +x apktool
    sudo mv apktool /usr/local/bin/
    sudo mv apktool.jar /usr/local/bin/
}

# Function to install Docker and MobSF image
install_docker_mobsf() {
    log "INFO" "Installing Docker for MobSF"
    install_package "docker.io"
    log "NOTE" "Pulling MobSF Image from Docker"
    sudo docker pull opensecurity/mobile-security-framework-mobsf:latest
}

# Function to display the tools that will be installed and ask the user for confirmation
confirm_installation() {
    echo -e "${YELLOW}The following tools will be installed:${RESET}"
    echo -e "1. Drozer Agent"
    echo -e "2. Frida-tools"
    echo -e "3. Objection Tool"
    echo -e "4. ApkLeaks"
    echo -e "5. reFlutter"
    echo -e "6. OpenJDK 11"
    echo -e "7. JADX"
    echo -e "8. APKTool"
    echo -e "9. Docker & MobSF Image"
    echo ""
    log  "WARN" "PRE_REQUISITE : Pipx"
    echo ""
    read -p "Do you want to continue with the installation of these tools? (y/n): " choice
    case "$choice" in
        y|Y|yes|Yes)
            log "INFO" "User confirmed to continue installation."
            ;;
        n|N|no|No)
            log "NOTE" "User aborted the installation."
            exit 0
            ;;
        *)
            log "ERROR" "Invalid choice. Please enter 'y' or 'n'."
            confirm_installation
            ;;
    esac
}

system_package_installation()
{
        # System update
    read -p "Do you want to update the System Package? (y/n): " choice
    case "$choice" in
        y|Y|yes|Yes)
            sudo apt update
            return 0
            ;;
        n|N|no|No)
            log "WARN" "Skipping System package update. this might cause some error"
            ;;
        *)
            log "ERROR" "Invalid choice. Please enter 'y' or 'n'."
            confirm_installation
            ;;
    esac
}

# Main setup function to orchestrate the entire installation process
setup() {
    greet
    # Checking Internect Connection
    check_internet
    if [ $? -ne 0 ]; then  # Check if the exit status is not 0 (indicating failure)
        echo "[NOTE] No Internet Connection"
        exit 1  # Exit with failure status
    fi
    
    # Confirm installation
    confirm_installation
    system_package_installation
    echo "[INFO] - Starting the Setup"


    # Install Drozer
    install_pip_tool "drozer"
    
    # Download Drozer Agent APK
    download_drozer_agent
    
    # Install Frida-tools
    install_pip_tool "frida-tools"
    frida --version
    echo "Make sure you download the correct Frida-server file from"
    echo ">> https://github.com/frida/frida/releases"
    echo "--------------------------------------------------"
    
    # Install Objection Tool
    install_pip_tool "objection"

    # Install ApkLeaks
    install_pip_tool "apkleaks"

    # Install reFlutter
    install_pip_tool "reflutter"

    # Install OpenJDK 11
    install_package "openjdk-11-jdk"

    # Install JADX
    install_jadx

    # Install APKTool
    download_apktool

    # Install Docker and MobSF
    install_docker_mobsf

    outro
    
}

# Run the setup
setup
