#!/bin/bash

/usr/local/bin/varnishstat -1 > /tmp/varnish.$$

awk '{
        printf ("%s:%s ",$1,$2)
}' /tmp/varnish.$$

rm -rf /tmp/varnish.$$