current_path="/export/App" #源码路径
out_put_path="/export/output/" #将编译好的class文件与service.sh放到该文件下,映射出去
git_path=$1	#需要编译的源码git地址
git_branch=$2 #需要编译的源码分支
sub_project_path=$3 #需要编译的源码子目录路径


# 开始验证
validation() {
	if [ ! -n "$git_path" ]; then
		echo "请填写提交git地址"
		exit 1
	fi
}

# 切换分支
switch_branch() {
	if [ -n "$git_branch" ]; then
		git checkout -b $git_branch origin/$git_branch
	fi
}

# 主 main 函数
main() {
	echo "获取所有入参: 入参git_path:$git_path,入参git_branch:$git_branch,入参sub_project_path:$sub_project_path"
	validation

	echo "工作路径设置到到源码区 $current_path"
	mkdir -p current_path
	cd $current_path

	project_name=${git_path##*/}
	project_name=${project_name%.*}
	echo "获取项目名称$project_name"

	echo "如果源码区未有该项目[$project_name]，则使用git clone" 
	if [ ! -d "$project_name" ]; then
		echo "git clone $git_path"
		git clone $git_path
		echo "cd $project_name"
		cd $project_name
		echo "switch_branch"
		switch_branch
	else 
		echo "如果源码区存在该项目[$project_name]，则使用git pull" 
		echo "cd $project_name"
		cd $project_name
		echo "switch_branch"
		switch_branch
		echo "git pull"
		git pull
	fi

	echo "如果git地址需要编译的源码在子目录，切换到子目录[$sub_project_path]" 
	if [ -n "$sub_project_path" ]; then
		echo "cd $sub_project_path"
		cd $sub_project_path
		project_name=${sub_project_path##*/}
	fi

	echo "如果当前路径没有pom文件，则无法进行pom编译" 
	if [ -f "pom.xml" ]; then
		echo "mvn package"
		mvn package
	fi

	echo "将编译好的源码以及service.sh放到[$out_put_path],项目名称为[$project_name]"
	mkdir -p $out_put_path
	cp service.sh $out_put_path
	mkdir $out_put_path/$project_name
	cp target/*.jar $out_put_path/$project_name
}


main
