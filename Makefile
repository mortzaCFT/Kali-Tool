tool_name=Kali-Tool

src_dir= /usr/share
trigger_dir= /usr/bin

install:

	install -m 755 Kali-Tool $(trigger_dir)
	mkdir -p $(src_dir)/$(tool_name)/backups
	cp -vr sources $(src_dir)/$(tool_name)
	cp -vr  $(src_dir)/$(tool_name)sources/Kali-Tool.desktop   /usr/share/kali-menu/applications/
	mv -v  $(src_dir)/$(tool_name)sources/Kali-Tool.desktop   /usr/share/applications/

uninstall:

	rm -Rf $(trigger_dir)/$(tool_name)
	rm -Rf $(src_dir)/$(tool_name)
	rm -Rf $(src_dir)/kali-menu/applications/Kali-Tool.desktop
	rm -Rf $(src_dir)/applications/Kali-Tool.desktop
	
reinstall:

	rm -Rf $(trigger_dir)/$(tool_name)
	rm -Rf $(src_dir)/$(tool_name)
	rm -Rf $(src_dir)/kali-menu/applications/Kali-Tool.desktop
	rm -Rf $(src_dir)/applications/Kali-Tool.desktop
	install -m 755 Kali-Tool $(trigger_dir)
	mkdir -p $(src_dir)/$(tool_name)/backups
	cp -vr  $(src_dir)/$(tool_name)
	cp -vr  $(src_dir)/$(tool_name)sources/Kali-Tool.desktop     /usr/share/kali-menu/applications/
	mv -vr  $(src_dir)/$(tool_name)sources/Kali-Tool.desktop    /usr/share/applications/