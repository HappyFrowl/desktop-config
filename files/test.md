# Notes for LFCS/ Linux+/ LPIC-1

- [The boot process](#The-boot-process)



# The boot process:  

**1. BIOS/ UEFI**
* Hardware is booted 
* BIOS/UEFI runs POST 
    * Power On Self Test 
    * Tests whether all hardware pieces are working properly 
    * If there is an error it is shown on the screen 
* If no error was encountered, the BIOS/ UEFI must find the bootloader software 
    * Hard drive 
    * USB 
    * CD 
    * PXE 

**2. GRUB2** 
* GRand Unified Bootloader 
* Its jobs 
    * Locate the kernel on the disk 
    * Load the kernel into the computer memory  
    * Run the kernel code 
* The bootloader starts the OS by using initrd – initial ram disk 
    * This is a temporary file system which is loaded into memory to assist in the boot process 
    * It contains programs to perform hardware detection and load the necessary modules to get the actual file system mounted 
    * Once the actual file system is mounted, the OS continues to load from the real file system 
    * Initfs (initial file system) is the successor of initrd  

**3. Kernel** 
* Once the kernel is loaded into memory, the kernel takes to finish the startup process 
* It starts 
    * Kernel modules 
    * Device drivers 
    * Background processes 
* First it decompresses itself onto memory, check the hardware, and load device drivers and other device drivers 
* Then init takes off 

**4. Init**
* Initialization system 
* Brings up and maintains user space services 
* Once the kernel has attached the boot file system, init is run  
* Init is the first process run by Linux 
    * So process number is always pID 1 
    * Check with ps –aux | head 
    * Always run in the background 
* For many distros, systemd is the used init system 
    * Another is sysv or upstart 
    * Systemd was spearheaded by RedHat 
* Systemd is a collection of units (e.g. services, mounts, etc) 
    * Systemctl, journalctl, loginct, notify, analyze, cgls, cgtop, nspawn 
    * To query all units, run: systemctl list-unit-files 
    * Also see which are enabled, disabled, masked 
 

During the boot many messages are shows. Two ways of showing these are: 
* `dmesg` 
* `cat /var/log/dmesg`

 
![alt text](image-1.png)

# Linux System Architecture

## udev
- **Type**: Device Manager  
- **Purpose**: Responsible for dynamically managing device nodes in the `/dev/` directory.  
  - Device nodes represent hardware devices like disks, USB drives, network interfaces, and more.  
- **Capabilities**:  
  - Low-level access to the Linux device tree  
  - Handles user-space events (e.g., loading firmware, adding hardware)  
- **Example**:  
  - Access is provided by a temporary filesystem (`tmpfs`) mounted to `/dev/`

## dbus
- **Type**: Inter-Process Communication System  
- **Purpose**: Facilitates communication between applications and system services.  
  - Allows processes to send messages to each other.  
- **Example**:  
  - Applications like `NetworkManager` use D-Bus to communicate with the system's networking stack.

## sysfs
- **Type**: Virtual Filesystem  
- **Purpose**: Exposes kernel device and subsystem information to user space.  
  - Mounted at `/sys` and provides a structured way to view and manipulate kernel objects.  
  - Presents information about:  
    - Various kernel subsystems  
    - Hardware devices  
    - Drivers  
- **Example**:  
  - Check `/sys/class/net` for network interface details.

## procfs
- **Type**: Virtual Filesystem  
- **Purpose**: Provides an interface to kernel data structures.  
  - Mounted at `/proc` and allows user space to query or control the kernel.  
  - Presents information about:  
    - Processes  
    - System information  
- **Example**:  
  - Access `/proc/cpuinfo` for CPU details or `/proc/meminfo` for memory usage.  
  - Run `ls /proc` to list all running processes.  
  - Interface with the kernel to change parameters on the fly.  
  - The `cmdline` file contains options passed by GRUB during boot.  
  - Linux version and kernel are stored as files in `/proc`.

## tmpfs
- **Type**: Temporary Filesystem  
- **Purpose**: A memory-based filesystem used for temporary data storage that does not persist after reboot.  
- **Example**:  
  - The `/tmp` directory is often mounted as `tmpfs`.

## devtmpfs
- **Type**: Virtual Filesystem  
- **Purpose**: Automatically populates the `/dev` directory with device nodes at boot, which are then managed by `udev`.  
- **Example**:  
  - Provides base device nodes for hardware detected during boot.

## cgroups
- **Type**: Resource Management Subsystem  
- **Purpose**: Limits, prioritizes, and accounts for resources (CPU, memory, I/O) used by groups of processes.  
- **Example**:  
  - Docker and Kubernetes use `cgroups` to manage container resource allocation.

## FUSE (Filesystem in User Space)
- **Type**: Virtual Filesystem Framework  
- **Purpose**: Allows non-privileged users to create and manage filesystems in user space.  
- **Example**:  
  - Filesystems like `SSHFS` or `NTFS-3G` use FUSE.

## Modules
- **Type**: Loadable Kernel Module (LKM)  
- **Purpose**: Extend the running kernel without needing to recompile or reboot the system.  
  - LKMs are object files dynamically loaded and unloaded into the kernel as needed.  
- **Examples**:  
  - Use `lsmod` to list currently loaded kernel modules and their usage.  
  - Remove modules with `rmmod` and add them with `modprobe`.


# File System

# The Linux File System

`/` - Root
- The root directory is the top-level directory in the Linux filesystem hierarchy.

---

`/bin` - Essential Binaries
- Contains binaries or executables that are essential to the entire OS.
- Commands like `gzip`, `curl`, `ls` are stored here.
- All users can by default run these 

---

`/sbin` - System Binaries
- Contains system binaries or executables for the superuser (root).
- Example: `mount`.

---

`/lib` - Libraries
- Shared libraries for essential binaries in `/bin` and `/sbin` are stored here.

---

`/usr` - User Directory
- Contains non-essential binaries or executables intended for the end user.
- Includes:
  - `/usr/bin`: Non-essential binaries.
  - `/usr/sbin`: Non-essential system binaries.
  - `/usr/lib`: Libraries for `/usr/bin` and `/usr/sbin`.
- `/usr/local`:
  - Contains manually compiled binaries in `/usr/local/bin`.
  - Provides a safe place to avoid conflicts with system-installed packages.
- Path and Precedence
  - All these binaries are mapped together using the `PATH` environment variable (`$PATH`).
  - `which` command shows the location of a binary and gives precedence to `/usr/bin` if the command exists in multiple places.

---

`/etc` - Editable Text Config
- Stores system configuration files (e.g., `.config` files).

---

`/home` - User Files
- Contains user-specific files and configurations.

---

`/boot` - Boot Files
- Contains files required to boot the system:
  - `initrd`
  - The Linux kernel:
    - `vmlinux`: Uncompressed kernel.
    - `vmlinuz`: Compressed kernel.

---

`dev` - Device Files
- Provides access to hardware and drivers as if they are files.

---

`/opt` - Optional Software
- Stores optional or add-on software.

---

 `/var` - Variable Files
- Contains files that change while the OS is running:
  - Logs are stored here.

---

## `/tmp` - Temporary Files
- Stores temporary files.
- Files in `/tmp` are non-persistent between reboots.

---

## `/proc` - Process Filesystem
- An illusionary filesystem created in memory by the Linux kernel.
- Used to keep track of running processes.










# User and Group management
Root
    - super user
    - admin 
    - UID 0 

Regular user 
    - Runs apps
    - Configures databases, websites, etc

Service user:
- Specific to the service (webserver, database)
- No interactive login
- Runs in the background

Substitute/ switch user
- `su - <username>` - switch to another user account 
- `su - root` or `sudo su` - switch to root
- `sudoedit` - gain elevated editing permissions to a specific file if, and only if, the user is member of `editors` group and the group has editing permissions to the file
    - `%editors ALL = sudoedit /path/to/file`
- `visudo`
    - edits `/etc/sudoers`
    - Add users to `sudo` group 
    - `visudo -c` checks the sudoers file for errors
    - add user to sudoers
        - `username ALL=(ALL) All:ALL`
    - ensure all user can use command `
        - `ALL ALL=(ALL) /bin/last`
    - give user access to <command> and to `updatedb`
        - `user ALL=/path/to/command, /bin/updatedb`
    - let user use `updatedb` without prompting for password
        - `username ALL=NOPASSWD:/bin/updatedb`


- `wheel` 
    - Group for granting users `sudo` right
    - Used on distros that do not by default have the `sudo` group
    - e.g. Centos

**Managing users and groups:**
- `useradd` - add a user
    - users are stored in `/etc/passwd`
        - it contains: `user:password:uid:gid:comment:homedir:defaultshell
    - if a home directory is created, folders stated in `/etc/skel` are created in it by default
    - `-D` - show default settigns for cerating a user
    - `-u` - choose a specific uid
    - `-s` - choose a specific shell
    - `-m` - explicitely create a home directory
    - `-r` - create system user
    - `-e` - set expiration date for the user
    - `-c` - add comment to the user, e.g. full name
- `userdel` - delete a user
    - `-r` - delete the home directory also
- `usermod` - modify a user
    - `-l` - set new login name
    - `-u` - set new uid
    - `-a -G` - add the user to a group
    - `-L` - lock user
    - `-U` - unlock user
- `groupadd` - create a group
    - groups are stored in `/etc/group`
        - `groupname:grouppassword:gid:usersingroup`
    - `--system` - create a system group
    - `--gid` - set gid
    - `-o` - create group with duplicate gid
- `groupmod` - modify group
    - `-g` - change name
    - `-u` - change gid
- `gpasswd` - modify group membership
    - `-A user1,user2 group` - define group admins
    - `-M user1,user2 group` - set list of group members
    - `-a user group` - add user to group
    - `-d user group` - delete user from group
- `chage` - change expiration date 
    - `-E` - set expiration date for user account
    - `-l` - list expiration date for user
    - `-w` - set a warning for a user
- `passwd` - change password for a user
    - passwords are stored in `/etc/shadow`
        - it contains:
            - user name
            - password
                - if the password is `!` and more nothing, the password is invalid
                - if it contains something lie `!$y$j9T$TW4`, **then the user is disabled**
            - total number of days since 1 jan 1970 since the password was changed
            - min days of days required between password changes 
            - max days of days a password is valid 
            - Number of days after password is expired that the account will be disabled 
            - Days after jan 1 1970 that the account will be disabled 
    - `-l | -u` - lock or unlock a user 
    - `-d` - make password blank
    - `-S` - see password status for a user
    - `--expire` - immediately expire a user's password, force password change on next login
- `id`- get user id and group membership
- `getent` - read entry from `/etc/` files
    - `getent group <group>` -  get the group's entry from `/etc/group`


# File permissions and ownership
- `ls –la` results in something like this:

  - ```bash
    drwxrwxr-x 2 ismet ismet    4096  Nov 20 20:19 .
    drwxrwxr-x 3 ismet ismet    4096  Nov 13 09:46 ..
    -rw-rw-r-- 1 ismet learners 11324 Nov 20 20:25 NOTES.md
    -rw-rw-r-- 1 root  hackers  1135  Nov 21 17:25 important.blah
    ```
-
  - the first bit is the file type - `-` for file, and `d` for directory
  - the rest of the bits are grouped in pairs of three 
  - the first three being user permissons, second three group permissions, last three other

  - the last bit is the access method. 
    - `.` - SELinux 
    - `+` - other 

## Changing permissions
- chmod applies to 
  - `u` - users
  - `g` - group
  - `o` - other
  - `a` - all

- permissions operator 
  - `+` - add permissions
  - `-` - remove permissions
  - `=` - set exact permissions

- permissions attributes
  - `r` - read
  - `w` - write
  - `e` - execute

- `chmod` symbolic mode:
  - `chmod ug+w [file]` - add write permissions to user and group
  - `-v` - verbose for debugging
  - `-f` - change permissions recursively
  - `-f` - hide errors
  - `-c` - display output of changes

- `chmod` absolute mode
  - `4` - read
  - `2` - write 
  - `1` - execute
  - `chmod -c 777 file.txt` - give rwxrwxrwx permissions to file.txt. Everyone can read, write and execute 

- `umask`
  - This sets the default file permissions for newly created files
  - It specifies what permissions are restricted
  - So it works inverted compared to `chmod` 
  - `umask` shows current value in numerics
  - `umask -S` - view symbolic mode
  - `umask 777` - restrict `rwx` for everyone
  - `umask  a-e` - remove default execute permissions for everyone

## Access Control Lists
- More granular file control than permissions
- set access to one or multiple directories
- `getfacl` - Get file ACL It outputs:
  - file, owner, group, and user/group/other permissions
- `setfacl` - set file ACL for a user or group specifically
  - `setfacl -m u:username:rwx /path/to/file_or_directory` - give `username` read, write, and execute permissions to `file`
  - `setfacl -x -all path/to/file_or_directory` - remove all permissions for all users. Same as `chmod 0000 path/to/file_or_directory`
  - `-b` - Remove all entries except standard permissions

  ## File ownership 
-  `chown` / `chgrp`
  - `[chgrp|chown] user path/to/file_or_dir` change owner or group of a file or directory
  - `[chgrp|chown] -R path/to/file_or_dir` - change group recursively
  - `chown user:group path/to/file_or_dir` - change owner and group of the file or directory 


## Attributes and special permissions

- `lsattr`
  - list attibutes of files and directories

  | Position | Attribute | Meaning                                                                |
|----------|-----------|------------------------------------------------------------------------|
| 1        | a         | Append-only: File can only be opened in append mode.                  |
| 2        | c         | Compressed: File is compressed on disk automatically by the filesystem.|
| 3        | d         | No dump: File will not be backed up by the dump program.              |
| 4        | e         | Extents: File is using extents for mapping blocks (ext4-specific).    |
| 5        | i         | Immutable: File cannot be modified, deleted, or renamed.             |
| 6        | j         | Data journaling: All data is written to the journal first.            |
| 7        | s         | Secure deletion: File contents are erased securely (if supported).    |
| 8        | t         | No tail-merging: Disable tail-merging for this file.                  |
| 9        | u         | Undeletable: File can be recovered after deletion.                   |
| 10       | A         | No atime updates: Access timestamp is not updated.                   |
| 11       | D         | Synchronous directory updates.                                        |
| 12       | S         | Synchronous updates: File updates are written synchronously.         |
| 13       | T         | Top-level directory: Reserved for ext3/ext4 directory indexing.      |
| 14       | h         | Huge file: Indicates a huge file (specific to ext4).                 |
| 15       | E         | Encrypted: File is encrypted (ext4 encryption).                      |


- `chattr`
  - Change attributes of files or directories
  - `chattr +i path/to/file_or_directory` - make a file or directory imutable to changes and deletion, even by superuser
  - `chattr -i path/to/file_or_directory` - make it mutuable again
  - `chattr =abc /path/to/file_or_directory` - set the attributes to abc
  - `-R` - same but recursively



## Special permissions
Less privileged users are allowed to execute a file by assuming the privileges of the file's owner or group

1. **SUID - Set User ID** (`s`/ `S` on user position)
- **Purpose**: Allows a file to execute with the permissions of its owner, regardless of who runs it.
- **Applicable to**: Executable files.
- **Usage**: Commonly used for programs that require elevated privileges (e.g., passwd).
- **Symbol**:
  - `s` replaces `x` in the user execute field if executable `rws------`
  - `S` appears if the file lacks execute permissions `rwS------`

2. **SGID - Set Group ID** Set User ID (`s`/ `S` on group position)
- **Purpose:**
  - For files: Ensures the file executes with the permissions of its group.
  - For directories: Files created inside inherit the group ownership of the directory, not the creator’s primary group.
- **Applicable to:** Files and directories.
- **Symbol:**
-   `s` replaces `x` in the group execute field if executable `rwxr-sr-x`
-   `S` appears if the file lacks execute permissions `rwxr-Sr-x`


3. **Sticky Bit** (`t` / `T` on others execute position)
- **Purpose:** Restricts deletion of files within a directory. Only the owner of a file, the owner of the directory, or the root user can delete files in that directory.
- **Applicable to:** Directories (rarely used on files).
- **Symbol:**
  - `t` replaces `x` in the others execute field if executable `rwxr-xr-t`
  - `T` appears if the directory lacks execute permissions `rwxr-xr-T`





## System-wide environment profiles
* 




# Storage 










# Basic scripting


# Linux Commands and Features

## Man Pages

- Man pages may have multiple sources, indicated by the `(x)` in the corner.
- Sections are identified by their number:
  1. General commands  
  2. System calls  
  3. C library functions  
  4. Special files  
  5. File formats and conventions  
  6. Games and screensavers  
  7. Misc  
  8. System admin commands/daemons  

### Searching the Man Pages
- **Search**: Press `/` and type your query to search within a man page.
- **`apropos`**: Search the name section of all man pages (great for finding commands).
- **`whatis`**: Display a brief description of a command.
- **`info`**: Display the info page of a command.

---

## GNU and Unix Commands

### Environment and Basics
- **`env`**: Display user environment variables (temporary, only for the session).
- **`pwd`**: Print working (current) directory.
- **`$HISTFILE`**: Path to the history file (e.g., `~/.bash_history`).
  - View history: `cat ~/.bash_history` or use the `history` command.
  - Export session history:
    ```bash
    export HISTFILE=<path>
    ```
  - Defaults back after logout.

### System Information
- **`uname`**: Print system information.

### File Operations
- **`cut`**: Extract portions of a file.
  - `-c`: Extract specific characters (e.g., `cut -c 3-5 file`).
  - `-d`: Specify delimiter.
  - `-f`: Specify field to extract (e.g., `cut -d, -f2 file`).

- **`expand / unexpand`**: Convert tabs to 8 spaces and vice versa.
  - Example: `expand file > file2`.

- **`wc`**: Count lines, words, and bytes in a file.

- **`fmt`**: Format text.

- **`head / tail`**: Display the first or last lines of a file.
  - `-n`: Specify the number of lines (default: 5).

- **`join`**: Join two files based on a common field.

- **`nl`**: Similar to `cat` but adds line numbers.

- **`od`**: Octal dump of a file.

- **`paste`**: Merge lines of files.

- **`pr`**: Format files for printing.

- **`sed`**: Stream editor for substitutions.
  - Example: `sed 's/old/new/' file`.

- **`split`**: Split a file (default: 1000 lines per split).
  - Example: `split file newfile`.

- **`tr`**: Translate or delete characters.

- **`uniq`**: Remove duplicate adjacent lines.
  - Use `sort` to make duplicates adjacent before using `uniq`.

- **`expr`**: Perform mathematical operations.
  - Example: `expr 5 \* 3`.

---

## Disk and Archive Management
- **`df`**: Display filesystem usage.
  - Use `df -h` for human-readable format (e.g., MiBs, GiBs).

- **`tar`**: Archive files.
  - Common options:
    - `c`: Create an archive.
    - `v`: Verbose (list files being processed).
    - `f`: Specify the filename.
    - `z`: Compress or decompress with gzip.
    - `t`: List archive contents.
  - Examples:
    ```bash
    tar cvf archive.tar file1 file2
    tar zcvf archive.tar.gz file1 file2
    tar tvf archive.tar
    ```

- **`gzip`**: Compress files using the DEFLATE algorithm.
  - Use `gunzip` to decompress.

- **`dd`**: Copy and convert files.
  - Example: Backup the MBR (Master Boot Record):
    ```bash
    dd if=/dev/sda of=mbr.bak bs=446 count=1
    ```

- **`xxd`**: Hexdump files.

---

## Streams and Redirection
- **Streams**:
  - `STDIN` (0): Input.
  - `STDOUT` (1): Output.
  - `STDERR` (2): Error.

- **Redirection**:
  - `>`: Redirect output to a file (overwrites existing content).
    ```bash
    command > file
    ```
  - `>>`: Append output to a file.
    ```bash
    command >> file
    ```
  - `<`: Redirect a file as input to a command.
    ```bash
    command < file
    ```
  - `2>`: Redirect errors to a file.
    ```bash
    command 2> error.log
    ```
  - Redirect both `STDOUT` and `STDERR`:
    ```bash
    command > file 2>&1
    ```

- **Piping**:
  - Use `|` to chain commands.
  - Example:
    ```bash
    ls | wc -l
    ```

- **`xargs`**: Process input line by line.
  - Example:
    ```bash
    find . -name "*.txt" | xargs rm
    ```

- **`tee`**: Redirect output to a file while also displaying it.
  - Example:
    ```bash
    ls | tee output.txt
    ```

---


    





 

 