# docker-adsbhub

Please see https://www.adsbhub.org/howtofeed.php for instructions. I'm not even sure you need to start with the biggerguy images.

## adsbhub block in docker-compose.yml

  # adsbhub ###################################################################
  adsbhub:
    image: thebiggerguy/docker-ads-b-adsbhub:${TAG:-latest}
    build:
      context: adsbhub
      dockerfile: Dockerfile-adsbhub
      cache_from:
        - thebiggerguy/docker-ads-b-adsbhub
        - thebiggerguy/docker-ads-b-adsbhub:${TAG:-latest}
    depends_on:
      - readsb
    deploy:
      restart_policy:
        condition: always
        delay: 5s

## Contents of adsbhub/Dockerfile-adsbhub

### Note: Make sure you chmod 755 adsbhub-client.sh on your host so that it will execute when copied into the container at build time

FROM multiarch/alpine:armhf-v3.9

RUN apk add --no-cache socat iputils

COPY adsbhub-client.sh /usr/local/bin/adsbhub-client
ENTRYPOINT ["adsbhub-client"]

## Contents of adsbhub/adsbhub-client.sh

### Note: You will need to update the ckey variable in order to complete your registration on the site. Please carefully read the instructions listed at the site above.

#!/bin/bash
# ------------------------------------------------------------------
# www.adsbhub.org
# version: 1.04
# ------------------------------------------------------------------

ckey=''
cmd="nc -w 60 -q 10 readsb 30002 | nc -w 60 -q 10 data.adsbhub.org 5001"
myip="0.0.0.0"
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

    #echo $result


    # Update IP if change
    if [ -n "$ckey" ]
    then
      cmin=$((cmin-1))
      if [ $cmin -le 0 ]
      then
        cmin=5
        currentip=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://data.adsbhub.org/getmyip.php`

        if [ ${#currentip} -ge 7 ] && [ "$currentip" != "$myip" ]
        then
          skey=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- https://www.adsbhub.org/key.php`
          if [ ${#skey} -ge 33 ]
          then
            ss=${skey: -1}
            skey=${skey::-1}
            md5=`echo -n $ckey$skey | md5sum | awk '{print $1}'`

            result=`timeout -s KILL 5 wget -o /dev/null --no-check-certificate -qO- "https://www.adsbhub.org/updateip.php?sessid=$md5$ss&myip=$currentip"`

            if [ "$result" == "$md5$ss" ]
            then
              myip=$currentip
              #echo $result
            fi
	  fi
	fi
      fi
    fi

    sleep 60
    
done
