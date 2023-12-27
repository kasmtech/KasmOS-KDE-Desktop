.PHONY: clean save-favourites

save-favourites:
	git add kde-config/.local/share/kactivitymanagerd/resources/database kde-config/.local/share/kactivitymanagerd/resources/database-shm kde-config/.local/share/kactivitymanagerd/resources/database-wal kde-config/.config/kactivitymanagerd-statsrc

clean:
	git clean -f kde-config/ && git co kde-config/
