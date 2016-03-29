# RELEASE=`git describe --tags`
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

phonetic-test-${VERSION}.spec : phonetic-test-${VERSION}.spec
	sed -e "s#VERSION#${VERSION}#" -e "s#RELEASE#${RELEASE}#" -e "w${@}" ${<}

phonetic-test-${VERSION}.tar.gz : phonetic-${VERSION}.tar
	cp ${<} ${@}

buildsrpm-test/phonetic-test-${VERSION}-${RELEASE}.src.rpm : phonetic-test-${VERSION}.spec phonetic-${VERSION}.tar.gz
	mkdir --parents buildsrpm-test
	mock --buildsrpm --spec phonetic-test-${VERSION}.spec --sources phonetic-test-${VERSION}.tar.gz --resultdir buildsrpm-test

rebuild-test/phonetic-test-${VERSION}-${RELEASE}.x86_64.rpm : buildsrpm/phonetic-test-${VERSION}-${RELEASE}.src.rpm
	mkdir --parents rebuild-test
	mock --rebuild buildsrpm/phonetic-test-${VERSION}-${RELEASE}.src.rpm --resultdir rebuild-test

install/phonetic-${VERSION}-${RELEASE}.x86_64.rpm : rebuild/phonetic-${VERSION}-${RELEASE}.x86_64.rpm rebuild/phonetic-test-${VERSION}-${RELEASE}.x86_64.rpm
	mkdir --parents init install shell
	mock init --resultdir init
	mock install rebuild/phonetic-${VERSION}-${RELEASE}.x86_64.rpm rebuild/phonetic-test-${VERSION}-${RELEASE}.x86_64.rpm --resultdir install
	mock shell "/usr/bin/test-phonetic" --resultdir shell 

