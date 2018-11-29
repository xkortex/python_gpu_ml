.PHONY: build
build:
	docker build . -t prefrontalvortex/python_gpu_ml

.PHONY: runbasic
runbasic: 
	docker run -it \
	-v "$(shell pwd):/root" \
	--runtime=nvidia --network=host \
	prefrontalvortex/python_gpu_ml

# counterintuitively, $DISPLAY should be left blank, not fed in the host name or IP
# dont forget `xhost +local:root` if necessary
.PHONY: run
run: 
	docker run -it \
	-e "DISPLAY" \
	-e "QT_X11_NO_MITSHM=1" \
	-v "/tmp/.X11-unix:/tmp/.X11-unix" \
	-v "$(shell pwd):/home/jovyan/work" \
	-p 8888:8888 \
	-v "/home/${USER}:/home/${USER}" \
	--runtime=nvidia --network=host \
	 prefrontalvortex/python_gpu_ml

.PHONY: clean
clean: 
	sudo rm -rf .catkin_tools .cmake .config .ros build* devel* logs*

## broken until i figure out dockerhub
.PHONY: push
push: login
	docker push prefrontalvortex/python_gpu_ml


.PHONY: pull
pull:
	docker pull prefrontalvortex/python_gpu_ml
	

.PHONY: login
login:
	docker login

