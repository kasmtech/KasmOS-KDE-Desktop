.PHONY: clean save-favourites save-favorites

save-favorites:
	git add kde-config/.local/share/kactivitymanagerd/resources/database kde-config/.local/share/kactivitymanagerd/resources/database-shm kde-config/.local/share/kactivitymanagerd/resources/database-wal kde-config/.config/kactivitymanagerd-statsrc

save-favourites: save-favorites

clean:
	git clean -f kde-config/ && git co kde-config/
