phonetic-${VERSION}.spec : phonetic.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

phonetic-${VERSION}.tar.gz :
	curl --output ${@} https://github.com/desertedscorpion/whitevenus/releases/tag/${VERSION}

phonetic-${VERSION}.src.rpm : phonetic-${VERSION}.spec phonetic-${VERSION}.tar.gz
	mkdir --parents buildsrpm
	mock --buildsrpm --spec phonetic-${VERSION}.spec --sources phonetic-${VERSION}.tar.gz --resultdir buildsrpm

phonetic-${VERSION}.x86_48.rpm : phonetic-${VERSION}.src.rpm
	mkdir --parents rebuild
	mock --rebuild phonetic-${VERSION}.src.rpm --resultdir rebuild
