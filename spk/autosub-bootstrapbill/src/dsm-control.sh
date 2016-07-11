#!/bin/sh

# Package
PACKAGE="autosub-bootstrapbill"
DNAME="AutoSub-BootstrapBill"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PYTHON=${PYTHON_DIR}/bin/python
PATH="${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PROG_PY="${INSTALL_DIR}/AutoSub.py"
LOG_FILE="${INSTALL_DIR}/AutoSubService.log"

start_daemon ()
{
    # Launch the application in the background
	if [ -f ${INSTALL_DIR}/config.properties ]
	 then
	 su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${PROG_PY} -c "${INSTALL_DIR}/config.properties" -d -l"
	 else
	 su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${PROG_PY} -d -l"
	fi
	
}

stop_daemon ()
{
    # Kill the application
    kill `find /proc -maxdepth 1 -user ${RUNAS} -exec /usr/bin/basename {} \;`
}

daemon_status ()
{
    if [ `find /proc -maxdepth 1 -user ${RUNAS} -exec /usr/bin/basename {} \; | wc -l` -gt 0 ]
    then
        return 0
    else
        return 1
    fi
}

run_in_console ()
{
    # Launch the application in the foreground
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${PROG_PY} -c "${INSTALL_DIR}/config.properties" -l"
}

case $1 in
    start)
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        ;;
    stop)
            echo Stopping ${DNAME} ...
			stop_daemon
            exit 0
        ;;
   status)
	 if daemon_status
        then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    console)
        run_in_console
        exit $?
        ;;
    log)
        echo ${LOG_FILE}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
