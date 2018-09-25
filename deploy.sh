#!/usr/bin bash
project_name="xx"
git_path=$1
git_branch=$2
sub_project_path=$3
current_path="/export/App"
get_project_name() {
	project_name=${git_path##*/}
	project_name=${project_name%.*}
	echo "项目名称为 $project_name"
}

validation() {
	# 入参1：代表项目名称
	if [ ! -n "$git_path" ]; then
		echo "请填写提交git地址"
		exit 1
	fi
}

switch_branch() {
	# 入参1：代表项目名称
	if [ -n "$git_branch" ]; then
		git checkout -b $git_branch origin/$git_branch
	fi
}

main() {
	validation

	mkdir -p current_path

	cd $current_path

	get_project_name $git_path

	if [ ! -d "$project_name" ]; then
		echo "git clone $git_path"
		git clone $git_path
		echo "cd $project_name"
		cd $project_name
		echo "switch_branch"
		switch_branch
	else
		echo "cd $project_name"
		cd $project_name
		echo "switch_branch"
		switch_branch
		echo "git pull"
		git pull
	fi

	if [ -n "$sub_project_path" ]; then
		echo "cd $sub_project_path"
		cd $sub_project_path
	fi

	if [ -f "pom.xml" ]; then
		echo "mvn package"
		mvn package
	fi
}

main
