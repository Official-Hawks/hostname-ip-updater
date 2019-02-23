# hostname-ip-updater
auto change the ip of a hostname in the hosts file


Why?

I have an Android and copy files to/from my computer a lot. Android uses the MTP protocal for USB conections, but i run into many issues while using it.. So i use either FTP or SFTP (currently have https://github.com/Magisk-Modules-Repo/ssh installed) through my Android hotspot wifi.
Problem: Every time my Android phone starts a hotspot it uses a new ip for itself/gateway and everytime i want to connect via sftp i need to find the new ip and modify the "host" in filezilla (my sftp transfer client of choice)

My solution:

Have the new ip auto update the windows "hosts" file with the new ip, then i can put the hostname specified in that file in filezilla..

Instructions:

Download the "host-updater.ps1" file and save it anywhere on your computer (i put it in my Appdata folder)

Now to automate this use "Task Scheduler" 

1. Open Task Scheduler from start menu 

2. Click "Create Task.."

3. Give the task a name and description of your choice

4. Check of "Run with highest privileges" and "Hidden" 

5. Go to the "Triggers" tab and click New

6. Add this information
    Begin the task: "On an event"
    Log: "Microsoft-Windows-NetworkProfile/Operational"
    Source: "NetworkProfile"
    Event ID: "10000"
    
7. Go to the "Actions" tab and click New
    Program/script: type "powershell.exe"
    Add arguments (optional): type "-ExecutionPolicy Bypass <Loaction to File>\host-updater.ps1" - without the quotes

#I had issues with this setting where task scheduler wasnt able to run the task at all (even manually), if this is the case choose "Any Connection"

8. Go to the "Conditions" tab
    Choose power settings
    Network: check "start only if the following network connection is available"
    Choose the network connection that we care about
