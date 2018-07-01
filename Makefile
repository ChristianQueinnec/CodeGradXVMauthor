# CodeGradXvmauthor

work : lint tests
clean :
	-rm .fw4ex.json [0-9]*ml
	-rm -rf tmp

# ############## Working rules:

lint :
	eslint codegradxvmauthor.js

tests : clean import
	-rm .fw4ex.json [0-9]*ml
	export NODE_TLS_REJECT_UNAUTHORIZED=0 ; jasmine
	export NODE_TLS_REJECT_UNAUTHORIZED=0 ; bash -x shtests/10-job.sh
	export NODE_TLS_REJECT_UNAUTHORIZED=0 ; bash -x shtests/20-exercise.sh
	export NODE_TLS_REJECT_UNAUTHORIZED=0 ; bash -x shtests/30-batch.sh

update :
	-rm -rf node_modules
	npm install codegradxlib@`jq -r .version < ../CodeGradXlib/package.json`
	npm install codegradxagent@`jq -r .version < ../CodeGradXagent/package.json`
	npm install

refresh :
	cp -p ../CodeGradXlib/codegradxlib.js \
	   node_modules/codegradxagent/node_modules/codegradxlib/
	cp -p ../CodeGradXagent/codegradxagent.js \
	   node_modules/codegradxagent/

test-all : 
	cd ../CodeGradXlib/ && m tests
	cd ../CodeGradXagent/ && m tests
	cd ../CodeGradXvmauthor/ && m tests

import :
	cd spec/ && ln -sf ../../CodeGradXlib/spec/vmauth-data.json .
	cd spec/ && cp -pf ../../CodeGradXlib/spec/oefgc.tgz .
	cd spec/ && cp -rpf ../../CodeGradXlib/spec/oefgc .
	cd spec/ && cp -pf ../../CodeGradXlib/spec/min.c .
	cd spec/ && \
	  cp -pf ../../CodeGradXlib/spec/org.example.fw4ex.grading.check.tgz .

# ############## NPM package
# Caution: npm takes the whole directory that is . and not the sole
# content of CodeGradXvmauthor.tgz 

publish : lint clean 
	-rm -rf node_modules/codegradx*
	npm install -S codegradxagent@`jq -r .version < ../CodeGradXagent/package.json`
	npm install -S codegradxlib@`jq -r .version < ../CodeGradXlib/package.json`
	git status .
	-git commit -m "NPM publication `date`" .
	git push
	-rm -f CodeGradXvmauthor.tgz
	m CodeGradXvmauthor.tgz install
	cd tmp/CodeGradXvmauthor/ && npm version patch && npm publish
	cp -pf tmp/CodeGradXvmauthor/package.json .
	rm -rf tmp
	npm install -g codegradxvmauthor

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

# ############## 
init :
	@echo "Answer the following questions:"
	npm init

# end of Makefile
