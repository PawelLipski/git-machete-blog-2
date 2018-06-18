#!/usr/bin/env bash

newb() {
	git checkout -b $1
}

cmt() {
	b=$(git symbolic-ref --short HEAD)
	f=${b/\//-}-${1}-${2}.txt
	touch $f
	git add $f
	git commit -m "$*"
}

newrepo() {
	dir=$1
	rm -fr /tmp/_$dir
	mv ~/$dir /tmp/_$dir
	mkdir ~/$dir
	cd ~/$dir
	opt=$2
	git init $opt
}

newrepo machete-sandbox-remote --bare
newrepo machete-sandbox
git remote add origin ~/machete-sandbox-remote

newb root
	cmt Root
newb develop
	cmt Develop commit
newb allow-ownership-link
	git push -u
	cmt Allow ownership links
newb build-chain
	cmt Build arbitrarily long chains
git checkout allow-ownership-link
	cmt 1st round of fixes
git checkout develop
	cmt Other develop commit
	git push -u
newb call-ws
	cmt Call web service
	cmt 1st round of fixes
	git push -u
	git reset --hard HEAD~
newb drop-constraint # not added to definition file
	cmt Drop unneeded SQL constraints

git checkout root
newb master
	cmt Master commit
	git push -u
newb hotfix/add-trigger
	cmt HOTFIX Add the trigger
	git push -u
	git commit --amend -m 'HOTFIX Add the trigger (amended)'

cat >.git/machete <<EOF
develop
    allow-ownership-link PR #123
        build-chain PR #124
    call-ws
master
    hotfix/add-trigger
EOF

git branch -d root

echo
echo
git machete status $1
echo
echo

