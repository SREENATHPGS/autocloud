PROJECT_ROOT_DIR=/home/ubuntu/application
REPO_NAME_PREFIX=code_repository-
BRANCH=dev

while getopts ":d:a:" opt; do
      case $opt in
        d)
          echo " -d was triggered, Parameter: $OPTARG" >&2
          DEPLOYMENT=${OPTARG:-dev}
			    
          if [ "$DEPLOYMENT" == "prod" ];then
			       BRANCH="main"
		      elif [ "$DEPLOYMENT" == "dev" ];then
		 		      BRANCH="dev"
			    else
				      echo "Branch not under scanner. Exitting."
				      exit
			    fi		
        ;;
		    
        a)
			    echo " -a was triggered, Parameter: $OPTARG" >&2
			    APPLICATION=${OPTARG:-backend}
		    ;;
        
        ?/)
           echo $opt
           echo "Invalid option:"
           exit 1
         ;;
         
         :)
           echo $opt                        
           echo "Option -$OPTARG requires an argument." >&2
           exit 1
         ;;
      esac
done


function checkout_branch() {
	repo_branch=$1
	echo "Switching to branch $repo_branch."
	git clean -fd
	git reset --hard HEAD
	git checkout $repo_branch
	git pull origin $repo_branch
}

function lookForChanges() {
	repo_dir=$1
	repo_branch=$2

	pushd $repo_dir
	current_version=$(git rev-parse HEAD)
	checkout_branch $repo_branch
	version_after_pull=$(git rev-parse HEAD)
	
	echo "Current version vs version after pull, $current_version, $version_after_pull"

	if [ "$current_version" != "$version_after_pull" ]; then
		echo "Changes"
		return 0
	else
		echo "No changes"
		return 1
	fi
	popd
}


function main() {
	repo_dir=$PROJECT_ROOT_DIR/$DEPLOYMENT/$REPO_NAME_PREFIX$APPLICATION

	echo "Repo dir given is $repo_dir"
	if [ -d $repo_dir ];then
		echo "Dir exists"
		lookForChanges $repo_dir $BRANCH
		changes=$?

		if [ $changes == 0 ];then

			if [ "$APPLICATION" == "backend" ];then
				echo "Deploying backend."
				pushd $repo_dir
					 echo "Kiling the process."
					 pm2 delete $REPO_NAME_PREFIX$DEPLOYMENT-server
					 echo "Starting up new process."
					 pm2 --name transportsevak-$DEPLOYMENT-server start npm -- start
				popd
			elif [ "$APPLICATION" == "frontend" ];then
				echo "deploying frontend."
			fi
		fi
	else
		echo "Given repo dir doesn't exist please check, Exitting.."
		exit
	fi
}

main
