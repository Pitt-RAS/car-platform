#!/usr/bin/env bash
# This script manages deployment of the Magellan stack on the NUC

pushd $(dirname $BASH_SOURCE) > /dev/null

source robot.env

if [[ "$1" == "--local" ]]; then
    export LOCAL=true
    shift
fi

if [[ -n "${LOCAL}" ]]; then
    unset DOCKER_HOST
    ROBOT_IP="127.0.0.1"
    DEFAULT_LAUNCH=${DEFAULT_LOCAL_LAUNCH}
else
    export DOCKER_HOST="ssh://ras@${ROBOT_IP}"
    DEFAULT_LAUNCH=${DEFAULT_ROBOT_LAUNCH}
fi

case $1 in
    start)
        shift
        docker stop ${CONTAINER_NAME} &> /dev/null
        docker rm ${CONTAINER_NAME} &> /dev/null
        docker run \
            -d \
            -it \
            --privileged \
            --name ${CONTAINER_NAME} \
            --net host \
            -v /dev/bus/usb:/dev/bus/usb \
            -v /maps:/maps \
            -e ROS_IP=${ROBOT_IP} \
            ${IMAGE_NAME}:dev \
            ${@:-$DEFAULT_LAUNCH}

        if [ $? -eq 0 ]
        then
            $0 watch
        else
            echo "Error starting container"
        fi
    ;;

    stop)
        docker stop ${CONTAINER_NAME} &> /dev/null
        docker rm ${CONTAINER_NAME} &> /dev/null
    ;;

    shutdown)
        ssh ras@${ROBOT_IP} "sudo poweroff" &> /dev/null
    ;;

    shell)
        docker exec -it ${CONTAINER_NAME} /bin/bash
    ;;

    watch)
        docker logs -f ${CONTAINER_NAME}
    ;;

    deploy)
        $0 stop
        set -e
        docker build -t ${IMAGE_NAME}:dev .
        $0 start

	docker system prune
        ./imageprune.py
    ;;

    deploy-teensy)
        docker build -t ${IMAGE_NAME}:teensy .

        docker run \
            -it \
            --privileged \
            --rm \
            --net host \
            -v /dev/bus/usb:/dev/bus/usb \
            ${IMAGE_NAME}:teensy \
            /robot/src/magellan_firmware/download.sh

        docker rmi ${IMAGE_NAME}:teensy
    ;;

    ssh)
        if [[ -n "${LOCAL}" ]]; then
            echo "You're sshing into your own machine!"
        else
            ssh ras@${ROBOT_IP}
        fi
	;;

    *)
        echo "Usage: robot.sh [start|stop|deploy|watch|shell|deploy-teensy|ssh]"
    ;;
esac
