if [ "$(which docker-compose)" == "" ]
then
    echo "Docker compose not found - installing" 
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "docker-compose is available on your PATH"
fi

if [ ! -d ~/mvn-repo ]
then
    echo "mvn-repo missing - creating ..."
    mkdir -p ~/mvn-repo && echo "CREATED"
fi

if [ ! -f docker-compose.yml ]
then
    echo "Docker compose missing - pulling ..."
    wget https://raw.githubusercontent.com/dolb/devop/master/docker-compose/builders/mvn/docker-compose.yml
    echo "Docker compose pulled"
fi

if [ ! -d build-scripts ]
then
    echo "Build scripts not added - creating"
    mkdir -p build-scripts/prod
    mkdir -p build-scripts/dev

    echo "cd $PWD && docker-compose run mvn-builder mvn -P dev -DskipTests clean install" > build-scripts/dev/install.sh
    echo "cd $PWD && docker-compose run mvn-builder mvn -P dev -DskipTests clean package" > build-scripts/dev/package.sh
    echo "cd $PWD && docker-compose run mvn-builder mvn -P prod -DskipTests clean install" > build-scripts/prod/install.sh
    echo "cd $PWD && docker-compose run mvn-builder mvn -P prod -DskipTests clean package" > build-scripts/prod/package.sh
    echo "cd $PWD && docker-compose run mvn-builder mvn -DskipTests clean install" > build-scripts/install.sh
    echo "cd $PWD && docker-compose run mvn-builder mvn -DskipTests clean package" > build-scripts/package.sh

    chmod +x build-scripts/*
    chmod +x build-scripts/dev/*.sh
    chmod +x build-scripts/prod/*.sh

    echo "build-scripts" >> .gitignore

    echo "Build scripts created"
fi




