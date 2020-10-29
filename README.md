# force-directory-cache
partially walks each directory, then sleeps.  Good for your directory cache.
--------


    Usage:  all_find.pl [OPTION] directory [additional dir] .. 
    
    This program slowly walks each directory tree, to keep the VFS tree in the page cache
    this means that other programs will find the directory tree has been cached by Linux
    it's not foolproof, but just runs slowly until you stop it.
    
     -q, 	suppress startup message
     -c, 	set count of files to scan before going to sleep for 5s 
    		defaults to 4000 scans
    
    
    This isn't great on CPU usage, but it's very good on memory, tends to use
    about 7MB. It should use  a few minutes of CPU per week.
    GNU find uses about 1s of CPU per 500,000 files, since I measured.
    This program won't save your cache from being stomped on by rsync.
    it will keep the tree cached in memory under light pressure though.
    installing the nocache utility might help with the rsync problem though.
    samba dir trees aren't kept in the linux cache.  NFS dir trees are, though.
    
    "this does not cache files, it ensures that the directories that contain file 
    inodes are kept in cache."
    
### No need to install anything, it's a standard linux script.    
Just download and run. 


** note I am currently using a different version of this program.  I've found that this program reads the inode data of each file (like stat) but that's not even required... rather it's easier just to read each directory... which is different than reading the inode of each file in a directory.  

** also `sudo bash -c 'echo 5 >/proc/sys/vm/vfs_cache_pressure'`   
setting ..../vfs_cache_pressure to 1000 means the vfs cache is worth 10 times less than file data. setting it to 5, probably means it's worth 20 times more.

one more thing.  how to prune directories from GNU `find` as to make it faster

    find $PATH -path ~/.local -prune -o -path ~/.sword -prune -o -true 
               ^spec path     ^operation                      ^required so rules can not always evaluate to false
               
