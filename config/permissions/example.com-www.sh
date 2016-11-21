#!/bin/bash

[ $1 ] && /organisation/git/config/permissions/_standard.sh

chmod -R 775 /organisation/websites/example.com/www/public_html/uploads/{downloads,photos}

[ $1 ] && echo "www.example.com permissions have been reset"