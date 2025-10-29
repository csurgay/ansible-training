for i in {1..2}; do ssh host$i curl -s localhost | grep "/title"; done

