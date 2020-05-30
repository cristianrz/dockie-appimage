all: dockie-x86_64.AppImage

dockie-x86_64.AppImage: appimagetool-x86_64.AppImage dockie proot dockie.png docker-hub-pull
	mkdir -p  AppDir/usr/bin
	cp AppRun          AppDir/
	cp dockie.desktop  AppDir/
	cp dockie.png      AppDir/
	cp dockie          AppDir/usr/bin
	cp proot           AppDir/usr/bin
	cp docker-hub-pull AppDir/usr/bin
	ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir
	chmod a-x dockie-x86_64.AppImage

proot:
	curl -L https://gitlab.com/proot/proot/-/jobs/537307719/artifacts/download > artifacts.zip
	unzip artifacts.zip
	cp dist/proot .

appimagetool-x86_64.AppImage:
	curl -L https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage >appimagetool-x86_64.AppImage
	chmod +x appimagetool-x86_64.AppImage

dockie-repo:
	git clone --depth 1 https://github.com/cristianrz/dockie.git dockie-repo

dockie.png: dockie-repo
	cp dockie-repo/docs/whale_small.png dockie.png

dockie: dockie-repo
	cd dockie-repo && ./configure
	cd dockie-repo && make
	cp dockie-repo/dockie .
	chmod +x dockie

docker-hub-pull: dockie-repo
	cp dockie-repo/contrib/docker-hub-pull .
	chmod +x docker-hub-pull

clean:
	rm -f dockie
	rm -f dockie.AppImage
	rm -f appimagetool-x86_64.AppImage
	rm -f dockie.png
	rm -f dockie-x86_64.AppImage
	rm -f docker-hub-pull
	rm -rf AppDir
	rm -rf artifacts.zip
	rm -rf dist
	rm -rf dockie-repo
	rm -rf proot

