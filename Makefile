docker:
	docker build -t whosonfirst-data-distributions .

xy:
	 docker run whosonfirst-data-distributions /usr/local/bin/wof-build-distributions -n whosonfirst-data-admin-xy
