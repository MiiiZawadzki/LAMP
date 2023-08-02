#!/bin/bash
docker cp sites/$1 lamp_www:/etc/apache2/sites-available/000-default.conf
docker exec -it -u root lamp_www a2ensite 000-default.conf
docker exec -it -u root lamp_www service apache2 reload
