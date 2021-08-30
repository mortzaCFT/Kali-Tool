tool_name=Kali-Tool

src_dir= /usr/share
trigger_dir= /usr/bin

install:

	install -m 755 Kali-Tool $(trigger_dir)
	mkdir -p sources $(src_dir)/$(tool_name)/backups
	cp -vr sources $(src_dir)/$(tool_name)
	cp -vr sources $(src_dir)/$(tool_name)/sources/tool.desktop   /usr/share/
	mv -v sources $(src_dir)/$(tool_name)/sources/tool.desktop   /usr/share/
    
uninstall:

	rm -Rf sources$(trigger_dir)/$(tool_name)
	rm -Rf sources $(src_dir)/$(tool_name)
	rm -Rf sources$(src_dir)/kali-menu/applications/tool.desktop
	rm -Rf sources$(src_dir)/applications/tool.desktop
	
reinstall:

	rm -Rf sources $(trigger_dir)/$(tool_name)
	rm -Rf sources $(src_dir)/$(tool_name)
	rm -Rf sources $(src_dir)/kali-menu/applications/tool.desktop
	rm -Rf sources $(src_dir)/applications/tool.desktop
	install -m 755 Kali-Tool $(trigger_dir)
	mkdir -p sources $(src_dir)/$(tool_name)/backups
	cp -vr sources $(src_dir)/$(tool_name)
	cp -vr sources $(src_dir)/$(tool_name)sources/tool.desktop     /usr/share/kali-menu/applications/
	mv -vr sources $(src_dir)/$(tool_name)sources/tool.desktop    /usr/share/applications/