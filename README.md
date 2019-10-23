# Anton CentOS CI Docker container
This container is used for CI testing and building for project Anton
## Example how to run the container
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id-rsa

docker run -e LOCAL_USER_ID=`id -u $USER` \
	   -v ${SSH_AUTH_SOCK}:/tmo/ssh-agent \
	   -v $PWD:/project \
	   anton:latest \
	   /bin/bash
```
