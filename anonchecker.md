<h2>Description:</h2>
anonchecker.sh is a minimal bash script that: <br>
- scans a CIDR for hosts with FTP (21) or SMB (445) open <br>
- checks anonymous FTP (attempts anonymous LIST using curl) <br>
- checks SMB null authentication (attempts smbclient -L //IP -N).<br>

<h2>Instructions: </h2><br>
Copy this file, save it as anonchecker.sh <br>
Make executable: chmod +x anonchecker.sh <br>

<h2>Usage</h2>
<code>./anonchecker.sh 192.168.0.0/24</code><br>
Replace 192.168.0.0/24 with your target CIDR (CTF Labs Only!!).<br>

<h2>Example</h2>
<img width="400" alt="image" src="https://github.com/user-attachments/assets/73023a3b-3362-489a-a162-8e91382b099d" />
