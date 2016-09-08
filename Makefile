work : lint tests
clean :
	-rm .fw4ex.json [0-9]*ml
	-rm -rf tmp

# ############## Working rules:

lint :
	jshint codegradxvmauthor.js spec/*.js

tests : clean import
	./codegradxvmauthor.js -h
	-rm .fw4ex.json [0-9]*ml
	jasmine

import :
	cd spec/ && ln -sf ../../CodeGradXlib/spec/vmauth-data.json .
	cd spec/ && cp -pf ../../CodeGradXlib/spec/oefgc.tgz .
	cd spec/ && cp -rpf ../../CodeGradXlib/spec/oefgc .
	cd spec/ && cp -pf ../../CodeGradXlib/spec/min.c .
	cd spec/ && \
	  cp -pf ../../CodeGradXlib/spec/org.example.fw4ex.grading.check.tgz .

# ############## NPM package

CodeGradXvmauthor.tgz : clean
	-rm -rf tmp
	mkdir -p tmp
	cd tmp/ && git clone https://github.com/ChristianQueinnec/CodeGradXvmauthor.git
	rm -rf tmp/CodeGradXvmauthor/.git
	cp -p package.json tmp/CodeGradXvmauthor/ 
	tar czf CodeGradXvmauthor.tgz -C tmp CodeGradXvmauthor
	tar tzf CodeGradXvmauthor.tgz

REMOTE	=	www.paracamplus.com
install : CodeGradXvmauthor.tgz
	rsync -avu CodeGradXvmauthor.tgz \
		${REMOTE}:/var/www/www.paracamplus.com/Resources/Javascript/

# Caution: npm takes the whole directory that is . and not the sole
# content of CodeGradXvmauthor.tgz 
publish : clean README.pdf
	git status .
	-git commit -m "NPM publication `date`" .
	git push
	-rm -f CodeGradXvmauthor.tgz
	m CodeGradXvmauthor.tgz install
	cd tmp/CodeGradXvmauthor/ && npm version patch && npm publish
	cp -pf tmp/CodeGradXvmauthor/package.json .
	rm -rf tmp

# ############## 
init :
	@echo "Answer the following questions:"
	npm init

# end of Makefile
