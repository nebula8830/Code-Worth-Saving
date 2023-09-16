# pyinstaller --onefile --uac-admin maintenance.py

import platform
import subprocess
from time import sleep

def announce_script():
    print("┌──────────────────────────────────────────────────┐")
    print("│┼────────────────────────────────────────────────┼│")
    print("││                   Maintenance                  ││")
    print("││                                                ││")
    print("││ver. 230524D                                 -JT││")
    print("│┼────────────────────────────────────────────────┼│")
    print("└──────────────────────────────────────────────────┘")

def run_command(command, description):
    print("\n")
    print("┌──────────────────────────────────────────────────┼")
    print(f"| {description}")
    print("|                                                  ┼")
    try:
        completed_process = subprocess.run(command, capture_output=True, text=True, timeout=600, shell=True, check=True)
        print("|                                           (DONE) |")
        print("└──────────────────────────────────────────────────┘")
    except subprocess.CalledProcessError as e:
        print("|                                          (ERROR) |")
        print("└──────────────────────────────────────────────────┘")

def main():
    announce_script()
    os_version = platform.system()
    if os_version == "Windows":
        release_version = platform.release()
        if release_version.startswith("10"):
            run_command("dism /Online /Cleanup-image /Restorehealth", "Running: Deployment Image Servicing and Management")
            run_command("sfc /scannow", "Running: System File Checker")
            run_command("net stop wuauserv", "Stopping: Windows Update Service")
            run_command('del /s /q "C:/Windows/Temp"', "Cleaning: C:\Windows\Temp")
            run_command('del /s /q "C:/Windows/SoftwareDistribution"', "Cleaning: C:\Windows\SoftwareDistribution")
            run_command("sc config wuauserv start=auto", "Configuring: Windows Update Service")
            run_command("net start wuauserv", "Starting: Windows Update Service")
            run_command("USOCLIENT.EXE RefreshSettings StartScan StartDownload ScanInstallWait StartInstall", "Installing: Updates")
        else:
            print("┌──────────────────────────────────────────────────┐")
            print("│Unsupported Windows version               (ERROR) │")
            print("└──────────────────────────────────────────────────┘")
    else:
        print("┌──────────────────────────────────────────────────┐")
        print("│Unsupported Operating System              (ERROR) │")
        print("└──────────────────────────────────────────────────┘")
    print("\n")
    print("┌──────────────────────────────────────────────────┐")
    print("│                    Complete                      │")
    print("└──────────────────────────────────────────────────┘")
    sleep(14400)

if __name__ == '__main__':
    main()
