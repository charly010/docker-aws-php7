# Image for AWS AMI

Compiler le container
````bash
$ docker build -t aws-php7 .
````

Lancer une image et se connecter avec un shell
````bash
$ docker run -i -t aws-php7 /bin/bash
````

Soumettre l'image
````bash
$ ./push.sh
````
Ou utiliser le Makefile
                       |
