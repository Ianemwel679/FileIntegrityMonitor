File Monitor with GUI
File Monitor with GUI is a PowerShell script that allows you to monitor changes in files specified in a baseline CSV file. It provides a graphical user interface (GUI) to interact with the script, making it easy to load a baseline, check file changes, add new files, and create a new baseline.

File Monitor with GUI Screenshot

Features
-Load a baseline CSV file containing paths and corresponding file hashes.
-Check files in the baseline against their current hashes to detect changes.
-Add new files to the baseline and recalculate hashes.
-Create a new baseline from scratch.
-User-friendly graphical interface using Windows Presentation Framework (WPF).
Requirements
-Windows operating system.
-PowerShell 5.1 or later.
How to Use
-Clone the repository or download the FileMonitor.ps1 and MainWindow.xaml files.
-Open PowerShell and navigate to the folder containing the script files.
Usage
-Run the FileMonitor.ps1 script using PowerShell. A GUI window will appear.
-Load Baseline: Click the "Load Baseline" button and select a baseline CSV file. The baseline will be loaded, and files will be displayed in the list.
-Check Files: After loading the baseline, click the "Check Files" button to verify if any files have changed since the baseline was created. The results will be shown in the list.
-Add Path: To add a new file to the baseline, click the "Add Path" button and select the file to be added. The file will be added to the baseline with its hash recalculated.
-Create Baseline: Click the "Create Baseline" button to create a new baseline from scratch. You will be prompted to save the new baseline CSV file.
Example Baseline CSV Format
-The baseline CSV file should be in the following format:
 path,hash
C:\example\file1.txt,123456789abcdef
C:\example\file2.txt,987654321abcdef

Important Note
The File Monitor with GUI script uses SHA256 as the hashing algorithm for calculating file hashes.
License
This project is licensed under the MIT License.

Issues and Contributions
If you encounter any issues with the script or have suggestions for improvements, please open an issue or submit a pull request.
