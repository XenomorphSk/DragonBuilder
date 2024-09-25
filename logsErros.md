Exportable Squashfs 4.0 filesystem, gzip compressed, data block size 131072
	compressed data, compressed metadata, compressed fragments,
	compressed xattrs, compressed ids
	duplicates are removed
Filesystem size 4344906.49 Kbytes (4243.07 Mbytes)
	30.87% of uncompressed filesystem size (14075304.89 Kbytes)
Inode table size 4548868 bytes (4442.25 Kbytes)
	26.94% of uncompressed inode table size (16884850 bytes)
Directory table size 4582573 bytes (4475.17 Kbytes)
	40.59% of uncompressed directory table size (11290884 bytes)
Xattr table size 242 bytes (0.24 Kbytes)
	37.29% of uncompressed xattr table size (649 bytes)
Number of duplicate files found 61287
Number of inodes 452177
Number of files 316135
Number of fragments 21873
Number of symbolic links  93825
Number of device nodes 0
Number of fifo nodes 0
Number of socket nodes 117
Number of directories 42100
Number of ids (unique uids + gids) 35
Number of uids 18
	root (0)
	daemon (1)
	lp (7)
	lightdm (117)
	administrador (1000)
	distrito (1001)
	unknown (755)
	_apt (105)
	colord (122)
	ntp (106)
	avahi-autoipd (115)
	man (6)
	unknown (62803)
	speech-dispatcher (124)
	geoclue (114)
	nm-openvpn (125)
	tss (107)
	syslog (104)
Number of gids 30
	root (0)
	daemon (1)
	dip (30)
	lp (7)
	shadow (42)
	ssl-cert (117)
	administrador (1000)
	distrito (1001)
	tty (5)
	crontab (105)
	mlocate (120)
	ssh (122)
	messagebus (106)
	utmp (43)
	mail (8)
	staff (50)
	lpadmin (115)
	man (12)
	unknown (62803)
	avahi-autoipd (124)
	colord (131)
	geoclue (123)
	lightdm (125)
	ntp (111)
	nm-openvpn (134)
	sambashare (135)
	tss (112)
	adm (4)
	systemd-journal (101)
	syslog (110)
Sistema de arquivos root copiado com sucesso.
Criando a ISO UEFI personalizada...
xorriso 1.5.2 : RockRidge filesystem manipulator, libburnia project.

Drive current: -outdev 'stdio:custom_linux_uefi.iso'
Media current: stdio file, overwriteable
Media status : is blank
Media summary: 0 sessions, 0 data blocks, 0 data,  177g free
Added to ISO image: directory '/'='/tmp/grub.R86W2V'
xorriso : UPDATE :     575 files added in 1 seconds
xorriso : FAILURE : File exceeds size limit of 4294967295 bytes: '/tmp/iso_build/casper/filesystem.squashfs'

Added to ISO image: directory '/'='/tmp/iso_build'
xorriso : UPDATE :     584 files added in 1 seconds
xorriso : aborting : -abort_on 'FAILURE' encountered 'FAILURE'
grub-mkrescue: erro: `xorriso` invocation failed
.
Erro ao criar a ISO.
