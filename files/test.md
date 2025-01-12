# Notes for LFCS/ Linux+/ LPIC-1

- The boot process (#The-boot-process)



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





 

 