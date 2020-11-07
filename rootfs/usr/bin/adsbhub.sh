#!/bin/bash
# ------------------------------------------------------------------
# www.adsbhub.org
# version: 1.06
# ------------------------------------------------------------------

ckey="${CLIENTKEY}"
#cmd="nc -w 60 -q 10 ${BEASTHOST} ${BEASTPORT} | nc -w 60 -q 10 data.adsbhub.org 5001"
cmd="socat -t 10 -T 60 -u TCP4:${SBSHOST}:${SBSPORT} TCP4:data.adsbhub.org:5001"
#cmd="nc -w 60 -q 10 localhost 30002 | nc -w 60 -q 10 94.130.23.233 5001"
myip4="0.0.0.0"
myip6="::"
cmin=0

while true; do

    # Check connection and reconnect
    check=`netstat -a | grep "adsbhub[.]org[.]5001 \|adsbhub[.]org:5001 \|data[.]adsbhub[.]org[.]5001 \|data[.]adsbhub[.]org:5001 "`
    #check=`netstat -an | grep "94[.]130[.]23[.]233[.]5001 \|94[.]130[.]23[.]233:5001 "`

    if [ ${#check} -ge 10 ]
    then
      result="connected"
    else
      result="not connected"
      eval "${cmd}" &
    fi

    echo $result


    # Update IP if change
    if [ -n "$ckey" ]
    then
      cmin=$((cmin-1))
      if [ $cmin -le 0 ]
      then
        cmin=5
        currentip4=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://ip4.adsbhub.org/getmyip.php`
        currentip6=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://ip6.adsbhub.org/getmyip.php`

        if ( [ ${#currentip4} -ge 7 ] && [ "$currentip4" != "$myip4" ] ) || ( [ ${#currentip6} -ge 2 ] && [ "$currentip6" != "$myip6" ] )
        then
          skey=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://www.adsbhub.org/key.php`
          if [ ${#skey} -ge 33 ]
          then
            ss=${skey: -1}
            skey=${skey::-1}
            md5=`echo -n $ckey$skey | md5sum | awk '{print $1}'`

            result=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- "https://www.adsbhub.org/updateip.php?sessid=$md5$ss&myip=$currentip4&myip6=$currentip6"`

            if [ "$result" == "$md5$ss" ]
            then
              myip4=$currentip4
              myip6=$currentip6
              echo "$result"
            fi
	  fi
	fi
      fi
    fi

    sleep 60
    
done
