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
    - `wheel` 
        - Group for granting users `sudo` right
        - Used on distros that do not by default have the `sudo` group
        - e.g. Centos

Managing users and groups:
    - `useradd` - add a user
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
    - `groupadd` - create a group
        - `--system` - create a system group
        - `--gid` - set gid
        - `-o` - create group with duplicate gid
    - `groupmod` - modify group
        - `-g` - change name
        - `-u` - change gid
    - `chage` - change expiration date 
        - `-E` - set expiration date for user account
        - `-l` - list expiration date for user
        - `-w` - set a warning for a user
    - `passwd` - change password for a user
        - `-l` - lock or unlock a user 
        - `-d` - make password blank
        - `-S` - see password status for a user
    - `id`- get user id and group membership
    



    





 

 