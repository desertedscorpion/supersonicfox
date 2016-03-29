RELEASE=0.0.0

phonetic-${VERSION}.spec : phonetic.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

phonetic-${VERSION} :
	mkdir --parents ${@}
	git -C ${@} init
	git -C ${@} remote add origin git@github.com:desertedscorpion/whitevenus.git
	git -C ${@} fetch origin
	git -C ${@} checkout tags/${VERSION}

phonetic-${VERSION}.tar : phonetic-${VERSION}
	tar --create --file ${@} ${<}

phonetic-${VERSION}.tar.gz : phonetic-${VERSION}.tar
	gzip --to-stdout ${<} > ${@}

buildsrpm/phonetic-${VERSION}-${RELEASE}.src.rpm : phonetic-${VERSION}.spec phonetic-${VERSION}.tar.gz
	mkdir --parents buildsrpm
	mock --buildsrpm --spec phonetic-${VERSION}.spec --sources phonetic-${VERSION}.tar.gz --resultdir buildsrpm

rebuild/phonetic-${VERSION}-${RELEASE}.x86_64.rpm : buildsrpm/phonetic-${VERSION}-${RELEASE}.src.rpm
	mkdir --parents rebuild
	mock --rebuild buildsrpm/phonetic-${VERSION}-${RELEASE}.src.rpm --resultdir rebuild
