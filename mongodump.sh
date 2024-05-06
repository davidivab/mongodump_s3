#! /bin/bash

# Directorio de inicio Linux
export HOME=/home/ubuntu
# Servidor Mongo
HOST="localhost"
# Nombre de la base de datos
NOMBRE_BASE_DATOS="mongo_base_datos"
# Contenedor S3
CONTENEDOR="s3://ivo-genericos/backups"
# Usuario
USUARIO="ubuntu"
# Hora actual
HORA=`/bin/date +%d-%m-%Y-%T`
# Directorio donde almacenaremos el respaldo temporal
DESTINO=/home/$USUARIO/tmp
# Comando para crear un archivo comprimido .tar
TAR=$DESTINO/$HORA.tar
# comando para crear el diretorio (inclusive cuando existe)
/bin/mkdir -p $DESTINO
# Echo de actividad
echo "Realizando respaldo $HOST/$DBNAME al contenedor $CONTENEDOR a las $HORA";
# Comando para ejecutar mongodump en la base de datos configurada
/usr/bin/mongodump -h $HOST -d $NOMBRE_BASE_DATOS -o $DESTINO
# Crear el archivo .tar en el diretorio de destino
/bin/tar cvf $TAR -C $DESTINO .
# Subiendo al contenedor S3
/usr/local/bin/aws s3 cp $TAR $CONTENEDOR

# Log the end of the script
echo "Respaldo de base de datos Mongo ha sido ejecutada correctamente."

# OPCIONAL
# Configura una URL tipo webhook para notificar al finalizar la ejecución del respaldo
WEBHOOK="https://gitbhub.com"
if curl --output /dev/null --silent --head --fail "$URLMAIL"; then
    echo '%s\n' "Webhook completado"
else
    echo '%s\n' "Webhook fallas"
fi
