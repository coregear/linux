Linux
From Wikipedia, the free encyclopedia
This article is about the operating system. For the kernel, see Linux kernel. For other uses, see Linux (disambiguation).
Linux Tux the penguin
Tux the penguin, mascot of Linux[1]
Developer 	Community
Written in 	Primarily C and assembly
OS family 	Unix-like
Working state 	Current
Source model 	Mainly open-source, proprietary software is also available
Initial release 	September 17, 1991; 25 years ago
Marketing target 	Personal computers, mobile devices, embedded devices, servers, mainframes, supercomputers
Available in 	Multilingual
Platforms 	Alpha, ARC, ARM, AVR32, Blackfin, C6x, ETRAX CRIS, FR-V, H8/300, Hexagon, Itanium, M32R, m68k, META, Microblaze, MIPS, MN103, Nios II, OpenRISC, PA-RISC, PowerPC, s390, S+core, SuperH, SPARC, TILE64, Unicore32, x86, Xtensa
Kernel type 	Monolithic (Linux kernel)
Userland 	GNU and various others[a]
Default user interface 	Many
License 	GPLv2[7] and other free and open-source licenses, except for the "Linux" trademark[b]

Linux (pronounced Listeni/ˈlɪnəks/ LIN-əks[9][10] or, less frequently, /ˈlaɪnəks/ LYN-əks[10][11]) is a Unix-like and mostly POSIX-compliant[12] computer operating system (OS) assembled under the model of free and open-source software development and distribution. The defining component of Linux is the Linux kernel,[13] an operating system kernel first released on September 17, 1991 by Linus Torvalds.[14][15][16] The Free Software Foundation uses the name GNU/Linux to describe the operating system, which has led to some controversy.[17][18]

Linux was originally developed as a free operating system for personal computers based on the Intel x86 architecture, but has since been ported to more computer hardware platforms than any other operating system.[19] Because of the dominance of Android on smartphones, Linux has the largest installed base of all general-purpose operating systems.[20] Linux is also the leading operating system on servers and other big iron systems such as mainframe computers and virtually all fastest supercomputers,[21][22] but is used on only around 2.3% of desktop computers[23][24] when not including Chrome OS, which has about 5% of the overall and nearly 20% of the sub-$300 notebook sales.[25] Linux also runs on embedded systems, which are devices whose operating system is typically built into the firmware and is highly tailored to the system; this includes smartphones and tablet computers running Android and other Linux derivatives,[26] TiVo and similar DVR devices, network routers, facility automation controls, televisions,[27][28] video game consoles and smartwatches.[29]

The development of Linux is one of the most prominent examples of free and open-source software collaboration. The underlying source code may be used, modified and distributed—​​commercially or non-commercially—​​by anyone under the terms of its respective licenses, such as the GNU General Public License. Typically, Linux is packaged in a form known as a Linux distribution (or distro for short) for

both desktop and server use. Some of the most popular mainstream Linux distributions are Arch Linux, CentOS, Debian, Fedora, Gentoo Linux, Linux Mint, Mageia, openSUSE and Ubuntu, together with commercial distributions such as Red Hat Enterprise Linux and SUSE Linux Enterprise Server. Distributions include the Linux kernel, supporting utilities and libraries, many of which are provided by the GNU Project, and usually a large amount of application software to fulfil the distribution's intended use.

Distributions oriented toward desktop use typically include a windowing system, such as X11, Mir or a Wayland implementation, and an accompanying desktop environment such as GNOME or the KDE Software Compilation; some distributions may also include a less resource-intensive desktop, such as LXDE or Xfce. Distributions intended to run on servers may omit all graphical environments from the standard install, and instead include other software to set up and operate a solution stack such as LAMP. Because Linux is freely redistributable, anyone may create a distribution for any intended use.
History
Main article: History of Linux
Antecedents
Linus Torvalds, principal author of the Linux kernel

The Unix operating system was conceived and implemented in 1969 at AT&T's Bell Laboratories in the United States by Ken Thompson, Dennis Ritchie, Douglas McIlroy, and Joe Ossanna.[30] First released in 1971, Unix was written entirely in assembly language as it was common practice at the time. Later, in a key pioneering approach in 1973, it was rewritten in the C programming language by Dennis Ritchie (with exceptions to the kernel and I/O). The availability of a high-level language implementation of Unix made its porting to different computer platforms easier.

Due to an earlier antitrust case forbidding it from entering the computer business, AT&T was required to license the operating system's source code to anyone who asked.[31] As a result, Unix grew quickly and became widely adopted by academic institutions and businesses. In 1984, AT&T divested itself of Bell Labs; freed of the legal obligation requiring free licensing, Bell Labs began selling Unix as a proprietary product.

The GNU Project, started in 1983 by Richard Stallman, has the goal of creating a "complete Unix-compatible software system" composed entirely of free software. Work began in 1984.[32] Later, in 1985, Stallman started the Free Software Foundation and wrote the GNU General Public License (GNU GPL) in 1989. By the early 1990s, many of the programs required in an operating system (such as libraries, compilers, text editors, a Unix shell, and a windowing system) were completed, although low-level elements such as device drivers, daemons, and the kernel were stalled and incomplete.[33][not in citation given]

Linus Torvalds has stated that if the GNU kernel had been available at the time (1991), he would not have decided to write his own.[34]

Although not released until 1992 due to legal complications, development of 386BSD, from which NetBSD, OpenBSD and FreeBSD descended, predated that of Linux. Torvalds has also stated that if 386BSD had been available at the time, he probably would not have created Linux.[35]

MINIX was created by Andrew S. Tanenbaum, a computer science professor, and released in 1987 as a minimal Unix-like operating system targeted at students and others who wanted to learn the operating system principles. Although the complete source code of MINIX was freely available, the licensing terms prevented it from being free software until the licensing changed in April 2000.[36]
Creation

In 1991, while attending the University of Helsinki, Torvalds became curious about operating systems[37] and frustrated by the licensing of MINIX, which at the time limited it to educational use only.[36] He began to work on his own operating system kernel, which eventually became the Linux kernel.

Torvalds began the development of the Linux kernel on MINIX and applications written for MINIX were also used on Linux. Later, Linux matured and further Linux kernel development took place on Linux systems.[38] GNU applications also replaced all MINIX components, because it was advantageous to use the freely available code from the GNU Project with the fledgling operating system; code licensed under the GNU GPL can be reused in other computer programs as long as they also are released under the same or a compatible license. Torvalds initiated a switch from his original license, which prohibited commercial redistribution, to the GNU GPL.[39] Developers worked to integrate GNU components with the Linux kernel, making a fully functional and free operating system.[33]
Naming
5.25-inch floppy disks holding a very early version of Linux

Linus Torvalds had wanted to call his invention "Freax", a portmanteau of "free", "freak", and "x" (as an allusion to Unix). During the start of his work on the system, some of the project's makefiles included the name "Freax" for about half a year. Torvalds had already considered the name "Linux", but initially dismissed it as too egotistical.[40]

In order to facilitate development, the files were uploaded to the FTP server (ftp.funet.fi) of FUNET in September 1991. Ari Lemmke, Torvald's coworker at the Helsinki University of Technology (HUT), who was one of the volunteer administrators for the FTP server at the time, did not think that "Freax" was a good name. So, he named the project "Linux" on the server without consulting Torvalds.[40] Later, however, Torvalds consented to "Linux".

To demonstrate how the word "Linux" should be pronounced (Listeni/ˈlɪnəks/ LIN-əks[9][10]), Torvalds included an audio guide (About this sound listen (help·info)) with the kernel source code.[41] Another variant of pronunciation is /ˈlaɪnəks/ LYN-əks.[10][11]
Commercial and popular uptake
Main article: Linux adoption
Ubuntu, a popular Linux distribution
Nexus 5X running Android

Adoption of Linux in production environments, rather than being used only by hobbyists, started to take off first in the mid-1990s in the supercomputing community, where organizations such as NASA started to replace their increasingly expensive machines with clusters of inexpensive commodity computers running Linux. Commercial use followed when Dell and IBM, followed by Hewlett-Packard, started offering Linux support to escape Microsoft's monopoly in the desktop operating system market.[42]

Today, Linux systems are used throughout computing, from embedded systems to supercomputers,[22][43] and have secured a place in server installations such as the popular LAMP application stack.[44] Use of Linux distributions in home and enterprise desktops has been growing.[45][46][47][48][49][50][51] Linux distributions have also become popular in the netbook market, with many devices shipping with customized Linux distributions installed, and Google releasing their own Chrome OS designed for netbooks.

Linux's greatest success in the consumer market is perhaps the mobile device market, with Android being one of the most dominant operating systems on smartphones and very popular on tablets and, more recently, on wearables. Linux gaming is also on the rise with Valve showing its support for Linux and rolling out its own gaming oriented Linux distribution. Linux distributions have also gained popularity with various local and national governments, such as the federal government of Brazil.[52]
Current development

Torvalds continues to direct the development of the kernel.[53] Stallman heads the Free Software Foundation,[54] which in turn supports the GNU components.[55] Finally, individuals and corporations develop third-party non-GNU components. These third-party components comprise a vast body of work and may include both kernel modules and user applications and libraries.

Linux vendors and communities combine and distribute the kernel, GNU components, and non-GNU components, with additional package management software in the form of Linux distributions.
Design

A Linux-based system is a modular Unix-like operating system, deriving much of its basic design from principles established in Unix during the 1970s and 1980s. Such a system uses a monolithic kernel, the Linux kernel, which handles process control, networking, access to the peripherals, and file systems. Device drivers are either integrated directly with the kernel, or added as modules that are loaded while the system is running.[56]

Separate projects that interface with the kernel provide much of the system's higher-level functionality. The GNU userland is an important part of most Linux-based systems, providing the most common implementation of the C library, a popular CLI shell, and many of the common Unix tools which carry out many basic operating system tasks. The graphical user interface (or GUI) used by most Linux systems is built on top of an implementation of the X Window System.[57] More recently, the Linux community seeks to advance to Wayland
